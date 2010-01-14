package SmallRNA::Web::Controller::View;

=head1 NAME

SmallRNA::Web::Controller::View - controller to handler /view/... requests

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Web::Controller::View

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
use warnings;
use base 'Catalyst::Controller';

use Lingua::EN::Inflect::Number qw(to_PL);

use SmallRNA::IndexDB;
use SmallRNA::Web::Report;

=head2 get_object_by_id_or_name

 Function: Find and return the object given a database id or display name.
           The database id (eg. biosample_id) is checked first.

=cut
sub get_object_by_id_or_name
{
  my $c = shift;
  my $type = shift;
  my $object_key = shift;

  my $class_name = SmallRNA::DB::class_name_of_table($type);

  if ($object_key =~ /^\d+$/) {
    return $c->schema()->find_with_type($class_name, $object_key);
  } else {
    # try looking up by display name
    my $class_info = $c->config()->{class_info}->{$type};
    if (defined $class_info) {
      if (defined $class_info->{display_field}) {
        return $c->schema()->find_with_type($class_name, 
                                            $class_info->{display_field} =>
                                              $object_key);
      }
    }
  }

  return undef;
}

=head2 object

 Function: Render details about an object (about a row in a table)
 Args    : $type - the object class from the URL
           $object_key - the id or primary key of an object to render

=cut
sub object : Local {
  my ($self, $c, $type, $object_key) = @_;

  my $st = $c->stash;

  eval {
    $st->{title} = "Details for $type $object_key";
    $st->{template} = 'view/object/generic.mhtml';

    $st->{type} = $type;

    my $object = get_object_by_id_or_name($c, $type, $object_key);

    $st->{object} = $object;
  };
  if ($@ || !defined $st->{object}) {
    $c->stash->{error} = qq(No object type "$type" and key = $object_key - $@);
    $c->forward('/start');
  }
}

=head2 list

 Function: Render a list of all objects of a given type
 Args    : $type - the object class from the URL

=cut
sub list : Local {
  my ($self, $c, $type) = @_;

  my $st = $c->stash;

  eval {
    $st->{title} = 'List of all ' . to_PL($type);
    $st->{template} = 'view/list_page.mhtml';
    $st->{type} = $type;

    my $class_name = SmallRNA::DB::class_name_of_table($type);
    my $class_info = $c->config()->{class_info}->{$type};

    # default: order by id
    my $order_by = $type . '_id';

    if (defined $class_info) {
      my @order_by_fields;
      if (defined $class_info->{order_by}) {
        if (ref $class_info->{order_by}) {
          @order_by_fields = @{$class_info->{order_by}};
        } else {
          push @order_by_fields, $class_info->{order_by};
        }
      } else {
        if (defined $class_info->{display_field}) {
          push @order_by_fields, $class_info->{display_field};
        }
      }
      if (@order_by_fields) {
        $order_by = \@order_by_fields;
      }
    }

    my $params = { order_by => $order_by };

    $st->{rs} = $c->schema->resultset($class_name)->search(undef, $params);

    $st->{page} = $c->req->param('page') || 1;
    $st->{numrows} = $c->req->param('numrows') || 20;
  };
  if ($@) {
    $c->stash->{error} = qq(No objects with type: $type - $@);
    $c->forward('/start');
  }

}

sub _get_order_by_field
{
  my $self = shift;
  my $c = shift;
  my $type = shift;

  my $class_info = $c->config()->{class_info}->{$type};

  # default: order by id
  my $order_by = $type . '_id';

  if (defined $class_info) {
    my @order_by_fields;
    if (defined $class_info->{order_by}) {
      if (ref $class_info->{order_by}) {
        @order_by_fields = @{$class_info->{order_by}};
      } else {
        push @order_by_fields, $class_info->{order_by};
      }
    } else {
      if (defined $class_info->{display_field}) {
        push @order_by_fields, $class_info->{display_field};
      }
    }
    if (@order_by_fields) {
      $order_by = \@order_by_fields;
    }
  }

  return $order_by;
}

=head2 report

 Function: Display a report, configuration from the config file
 Args    : $report_name - the report name, used to find the configuration

=cut
sub report : Local {
  my ($self, $c, $report_name) = @_;

  my $st = $c->stash;

  eval {
    my $report_conf = $c->config()->{reports}->{$report_name};

    $st->{title} = $report_conf->{description};
    $st->{template} = 'view/rstable.mhtml';

    my $type = $report_conf->{object_type};

    $st->{type} = $type;

    my $class_name = SmallRNA::DB::class_name_of_table($type);
    my $params = { order_by => $self->_get_order_by_field($c, $type) };

    my $prefetch_conf = $report_conf->{prefetch};

    if (defined $prefetch_conf) {
      $params->{prefetch} = eval "$prefetch_conf";
    }

    $st->{rs} = $c->schema->resultset($class_name)->search({ }, $params);
    $st->{column_confs} = $report_conf->{columns};

    $st->{page} = $c->req->param('page') || 1;
    $st->{numrows} = $c->req->param('numrows') || 20;
  };
  if ($@) {
    $c->stash->{error} = qq(Can't display report for: $report_name - $@);
    $c->forward('/start');
  }
}

=head2 list_collection

 Function: Render a collection from an object of a given type
 Args    : $type - the object class from the URL
           $object_id - the id of an object
           $collection_name - the collection/relation to render

=cut
sub list_collection : LocalRegex('^list/(.+?)/(\d+?)/(.+?)$') {
  my ($self, $c) = @_;

  my ($type, $object_id, $collection_name) = @{$c->req->captures()};

  my $st = $c->stash;

  $st->{title} = "List view of $collection_name for $type with id $object_id";
  $st->{template} = 'view/collection.mhtml';
  $st->{type} = $type;
  my $class_name = SmallRNA::DB::class_name_of_table($type);
  my $object =
    $c->schema()->find_with_type($class_name, "${type}_id" => $object_id);

  $st->{object} = $object;
  $st->{collection_name} = $collection_name;
}

my $index_manager_cache = {};

=head2 seqread

 Function: Show details of a read sequence
 Args    : $read_seq - the sequence

=cut
sub seqread : Local {
  my ($self, $c, $read_seq) = @_;

  my $index_db = SmallRNA::IndexDB->new(config => $c->config(),
                                        cache => $index_manager_cache);

  my $st = $c->stash;

  if (!defined $read_seq || length $read_seq == 0) {
    $c->stash->{error} = qq(No sequence passed to /seqread);
    $c->forward('/start');
  } else {
    $read_seq = uc $read_seq;

    $st->{title} = "Summary for: $read_seq";
    $st->{template} = 'view/seqread.mhtml';
    $st->{read_seq} = $read_seq;

    my @results = $index_db->search_all(schema => $c->schema(),
                                        sequence => $read_seq,
                                        retrieve_lines => 1,
                                        search_file_type => 'gff3');

    my @processed_results = ();

    my %org_results = ();

    RESULT: for my $result (@results) {
      my @matches = @{$result->{matches}};
      my $match_count = scalar(@matches);

      if ($match_count) {
        my $pipedata = $result->{pipedata};

        my $align_component;
        my $align_ecotype;

        for my $prop ($pipedata->pipedata_properties()) {
          if ($prop->type()->name() eq 'alignment ecotype') {
            $align_ecotype = $prop->value();
          }
          if ($prop->type()->name() eq 'alignment component') {
            next RESULT if $prop->value() ne 'genome';
            $align_component = $prop->value();
          }
        }

        if (! exists $org_results{$align_ecotype}) {
          $org_results{$align_ecotype} = [@matches];
        }

        my @processed_matches = ();

        my $redundant_count = undef;
        for my $match (@matches) {
          my $gff3_line = $match->{line};

          my @bits = split (/\t/, $gff3_line);

          my ($ref_name, $source, $type, $start, $end, $score, $strand, $phase,
              $attributes) = @bits;

          if (!defined $redundant_count) {
            $redundant_count = $score;
          }

          push @processed_matches, { ref_name => $ref_name, start => $start,
                                     end => $end, strand => $strand };
        }

        my @biosamples = $pipedata->biosamples();
        my $biosample = $biosamples[0];


        push @processed_results, { pipedata => $pipedata,
                                   redundant_count => $redundant_count,
                                   matches => \@processed_matches,
                                   biosample => $biosample };
      }
    }

    $st->{sample_results} = \@processed_results;
    $st->{organism_results} = \%org_results;
  }
}

1;
