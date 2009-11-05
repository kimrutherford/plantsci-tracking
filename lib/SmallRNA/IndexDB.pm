package SmallRNA::IndexDB;

=head1 NAME

SmallRNA::IndexDB - Search indexes retrieved from the tracking database

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::IndexDB

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
use Carp;

use Params::Validate qw(:all);
use Moose;

=head2 cache

 cache - a store file handles used by search() to prevent repeated opening and
         closing of index files

=cut
has 'cache' => (
    is  => 'rw'
);

=head2 config

 config - the SmallRNA::Config object

=cut
has 'config' => (
    is => 'ro',
    required => 1
);

use SmallRNA::Index::Manager;

sub BUILD
{
  my $self = shift;
  my $manager = SmallRNA::Index::Manager->new(cache => $self->cache());

  $self->{manager} = $manager;
}

sub _do_search
{
  my $self = shift;

  my $input_pipedata = shift;
  my $index_pipedata = shift;
  my $search_sequence = shift;
  my $retrieve_lines = shift;

  my $cache = $self->{cache};

  my $data_dir = $self->config()->data_directory();

  my $file_name = $input_pipedata->file_name();
  my $index_file_name = $index_pipedata->file_name();

  my $full_input_file_name = $data_dir . '/' . $file_name;
  my $full_index_file_name = $data_dir . '/' . $index_file_name;

  my @matches = $self->{manager}->search(input_file_name => $full_input_file_name,
                                         index_file_name => $full_index_file_name,
                                         search_sequence => $search_sequence,
                                         retrieve_lines => $retrieve_lines);

  return { pipedata => $input_pipedata, matches => \@matches };
}

=head2 search_all

 Function: search all index files for a sequence
 Args    : schema - the schema object
           search_file_type - type of file to search either "gff3" or "fasta"
           sequence - the sequence to find
           retrieve_lines - if true return the matching line from the gff3 or
              fasta file, otherwise just return the position
           verbose - if true print the file currently being searched
 Returns : a list of results, each of which is a map containing the pipedata
           object and the matches. eg.
             [ { pipedata => ..., matches => ... }, { pipedata => ... }, ... ]
           the matches is a list returned by Index::Manager::search()   

=cut
sub search_all
{
  my $self = shift;

  my %params = validate(@_, { schema => 1,
                              search_file_type => 1,
                              sequence => 1,
                              retrieve_lines => 0,
                              verbose => 0 });

  my $schema = $params{schema};
  my $search_file_type = $params{search_file_type};
  my $search_sequence = $params{sequence};
  my $retrieve_lines = $params{retrieve_lines};
  my $verbose = $params{verbose};

  my $file_format = 'seq_offset_index';
  my $expected_content_type = $search_file_type . '_index';

  my $rs = $schema->resultset('Cvterm')->search({
    name => $file_format
  })->search_related('pipedata_format_types');

  my @results = ();

  while (defined (my $index_pipedata = $rs->next())) {
    next if $index_pipedata->content_type()->name() ne $expected_content_type;

    my $pipeprocess = $index_pipedata->generating_pipeprocess();
    my @input_pipedatas = $pipeprocess->input_pipedatas();

    my $input_pipedata = $input_pipedatas[0];

    my $input_pipedata_file_name = $input_pipedata->file_name();

    next unless $input_pipedata_file_name =~ /patman|non_redundant/;

    if ($verbose) {
      warn "checking $input_pipedata_file_name\n";
    }

    my $result = $self->_do_search($input_pipedata, $index_pipedata,
                                   $search_sequence, $retrieve_lines);

    if (@{$result->{matches}}) {
      push @results, $result;
    }
  }

  return @results;
}

1;
