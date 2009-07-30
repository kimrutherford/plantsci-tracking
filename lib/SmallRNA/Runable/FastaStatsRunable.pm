package SmallRNA::Runable::FastaStatsRunable;

=head1 NAME

SmallRNA::Runable::FastaStatsRunable - A Runable that summarises the content
                                         and composition of a FASTA file

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Runable::FastaStatsRunable

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
use Moose;
use Carp;

use SmallRNA::Process::FastaStatsProcess;

extends 'SmallRNA::Runable::SmallRNARunable';

=head2

 Function: Create a file with summary/statistical information about a FASTA file
 Returns : nothing - either succeeds or calls die()

=cut
sub run
{
  my $self = shift;
  my $schema = $self->schema();

  my $code = sub {
    my $summary_term_name = 'first_base_summary';
    my $pipeprocess = $self->pipeprocess();

    my @input_pipedatas = $pipeprocess->input_pipedatas();
    if (@input_pipedatas > 1) {
      croak ("pipeprocess ", $pipeprocess->pipeprocess_id(),
             " has more than one input pipedata\n");
    }
    my $input_pipedata = $input_pipedatas[0];
    my $data_dir = $self->config()->data_directory();

    my $input_file_name = $input_pipedata->file_name();
    my $out_file_name = $input_file_name;

    my $suffix = "fasta|fa";
    if (!($out_file_name =~ s/(\.$suffix)?$/.fasta_stats/)) {
      croak qq(pattern match failed "$out_file_name" doesn't end with: $suffix);
    }

    SmallRNA::Process::FastaStatsProcess::run(input_file_name =>
                                                "$data_dir/" . $input_file_name,
                                              output_file_name =>
                                                "$data_dir/" . $out_file_name);

    my @samples = $input_pipedata->samples();

    $self->store_pipedata(generating_pipeprocess => $self->pipeprocess(),
                          file_name => $out_file_name,
                          format_type_name => 'text',
                          content_type_name => $summary_term_name,
                          samples => \@samples);
  };
  $self->schema->txn_do($code);
}

1;
