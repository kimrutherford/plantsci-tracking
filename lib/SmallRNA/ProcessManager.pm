package SmallRNA::ProcessManager;

=head1 NAME

SmallRNA::ProcessManager - An in-memory store of the ProcessConf
                           configuration

=head1 SYNOPSIS

The class contains the logic for creating new pipeprocesses based on
the ProcessConfs in the database and the current contents of the
pipeprocess and pipedata tables.

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::ProcessManager

You can also look for information at:

=over 4

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009 Kim Rutherford, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 FUNCTIONS

=cut

use strict;
use Params::Validate qw(:all);
use Set::CrossProduct;

=head2 new

 Usage   : my $conf_store = SmallRNA::ProcessManager->new(schema => $schema);
 Function: Create and return a new ProcessManager object
 Args    : schema - the SmallRNA::DB object

=cut
sub new
{
  my $class = shift;
  my $self = { validate(@_, { schema => 1 }) };

  bless $self, $class;

  return $self;
}

# Create a bit of SQL that constrains a Biosample to have inputs that
# match the given ProcessConfInput and which don't already have a Pipeprocess
# that uses the given ProcessConf
sub _make_bit
{
  my ($conf, $input) = validate_pos(@_, 1, 1);
  my $content_type = $input->content_type();
  my $format_type = $input->format_type();
  my $content_type_id = undef;
  if (defined $content_type) {
    $content_type_id = $content_type->cvterm_id();
  }
  my $format_type_id = undef;
  if (defined $format_type) {
    $format_type_id = $format_type->cvterm_id();
  }
  my $conf_id = $conf->process_conf_id();

  # biosamples where there is a pipedata of the appropriate type for this
  # input, but there isn't an existing pipeprocess for the process_conf

  my $org_constraint = '';

  if (defined $input->ecotype()) {
    my $organism_full_name = $input->ecotype()->organism()->full_name();
    $org_constraint =
      "AND me.biosample_id IN
        (SELECT biosample FROM biosample_ecotype, ecotype, organism
          WHERE biosample_ecotype.ecotype = ecotype.ecotype_id
            AND ecotype.organism = organism.organism_id
            AND organism.genus || ' ' || organism.species = '$organism_full_name')";
  }

  my $content_constraint = '';
  my $format_constraint = '';

  if (defined $content_type_id) {
    $content_constraint = "AND pipedata.content_type = $content_type_id"
  }

  if (defined $format_type_id) {
    $format_constraint = "AND pipedata.format_type = $format_type_id";
  }

  return qq{
    me.biosample_id in (
      SELECT biosample_pipedata.biosample
        FROM biosample_pipedata, pipedata
       WHERE biosample_pipedata.pipedata = pipedata.pipedata_id
$format_constraint
$content_constraint
$org_constraint
         AND NOT pipedata.pipedata_id IN (
           SELECT pipeprocess_in_pipedata.pipedata
             FROM pipeprocess_in_pipedata, pipeprocess
            WHERE pipeprocess_in_pipedata.pipeprocess = pipeprocess.pipeprocess_id
              AND pipeprocess.process_conf = $conf_id
         )
    )
  };
}

# find the sets of pipedatas from the biosample that can be input for the process
sub _find_pipedata
{
  my ($biosample, $process_conf) = @_;

  my @results = ();

  my @inputs = $process_conf->process_conf_inputs();

  for my $input (@inputs) {
    my $content_type = $input->content_type();
    my $format_type = $input->format_type();

    my @matching_pipedatas = ();

    my $cond = { };

    if (defined $content_type) {
      $cond->{content_type} = $content_type->cvterm_id(),
    }
    if (defined $format_type) {
      $cond->{format_type} = $format_type->cvterm_id(),
    }

    my $matching_rs =
      $biosample->biosample_pipedatas()->search_related('pipedata', $cond);

    while (my $pipedata = $matching_rs->next()) {
      push @matching_pipedatas, $pipedata;
    }

    push @results, [@matching_pipedatas];
  }

  my $cross = Set::CrossProduct->new([@results]);

  if (@inputs == 1) {
    return map { [ $_] } @{$results[0]};
  } else {
    return $cross->combinations();
  }
}

# Create a all missing Pipeprocesses for the given biosample
sub _create_biosample_proc
{
  my ($schema, $biosample, $process_conf, $existing_processes) =
    validate_pos(@_, (1) x 4);

  my @retlist = ();

  my @input_pipedata = _find_pipedata($biosample, $process_conf);

  for my $input_pipedata_ref (@input_pipedata) {
    my @input_pipedata = @{$input_pipedata_ref};

    my $key = (join '_', map { $_->pipedata_id() } @input_pipedata) . '_'
      . $process_conf->process_conf_id();

    if (exists $existing_processes->{$key}) {
      # we've created this process already, maybe because it's a remove adaptors
      # process for a multiplexed fastq file and we see the fastq file once per
      # biosample
      next;
    } else {
      $existing_processes->{$key} = 1;
    }

    my $process_conf_name = $process_conf->type()->name();
    my $not_started_status = $schema->find_with_type('Cvterm', name => 'not_started');
    my $description = "processing with conf: $process_conf_name";

    if (defined $process_conf->detail()) {
      $description .= ', ' . $process_conf->detail();
    }

    my %pipeprocess_args = (
      description => $description,
      process_conf => $process_conf,
      status => $not_started_status
    );

    my $pipeprocess = $schema->create_with_type('Pipeprocess',
                                                  {
                                                    %pipeprocess_args
                                                  }
                                                );

    for my $pipe_data (@input_pipedata) {
      $pipeprocess->add_to_input_pipedatas($pipe_data);
    }

    $pipeprocess->update();

    push @retlist, $pipeprocess;
  }

  return @retlist;
}

=head2 create_new_pipeprocesses

 Usage   : my @pipeprocess = $manager->create_new_pipeprocesses();
 Function: Create new pipeprocess objects and return all pipeprocesses
           that can be run given the current process_conf table.  We create a
           new pipeprocess when there are pipedata objects that are valid inputs
           for a ProcessConf and which don't have an existing pipe_process. 
 Args    : none

=cut
sub create_new_pipeprocesses
{
  my ($self) = validate_pos(@_, 1);

  my $schema = $self->{schema};

  my @retlist = ();

  # we query each ProcessConf object then:
  #   - find all biosamples that have pipedata objects that are inputs for the
  #     ProcessConf and that do not have an existing pipeprocess with the
  #     pipedata as input
  #   - for each biosample we found, create any pipeprocesses that are needed

  my $code = sub {
    my $needs_processing_term = 
      $schema->find_with_type('Cvterm', name => 'needs processing');

    my $process_conf_rs = $schema->resultset('ProcessConf');

    while (defined (my $process_conf = $process_conf_rs->next())) {
      my @inputs = $process_conf->process_conf_inputs();

      next unless @inputs > 0;

      my @where_bits = map {
        _make_bit($process_conf, $_);
      } @inputs;

      my $where = join ' AND ', @where_bits;
      $where .= ' AND processing_requirement = ' . $needs_processing_term->cvterm_id();

      my $rs = $schema->resultset('Biosample')->search({}, { where => $where });

      # keep a map so we don't create the same process twice, for example when
      # a fastq file contains more than one biosample - the query above will return
      # all the biosamples for the sequencing run corresponding to the fastq file,
      # all of which have the same fastq file as input
      my %existing_processes = ();

      while (my $biosample = $rs->next()) {
        push @retlist, _create_biosample_proc($schema, $biosample, $process_conf,
                                              \%existing_processes);
      }
    }
  };

  $schema->txn_do($code);

  return @retlist;
}

1;
