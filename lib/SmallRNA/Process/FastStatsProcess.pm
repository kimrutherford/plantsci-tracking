package SmallRNA::Process::FastStatsProcess;

=head1 NAME

SmallRNA::Process::FastStatsProcess - Summarise a FASTA or FASTQ file

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Process::FastStatsProcess

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
use Carp;
use Bio::SeqIO;
use Params::Validate qw(:all);
use warnings;
use YAML;
use Tie::IxHash;

=head2

 Usage   : SmallRNA::Process::FastStatsProcess::run(input_file_name =>
                                                      $in_file_name,
                                                    output_file_name =>
                                                      $out_file_name);
 Function: Create a statistics/summary file from a FASTQ or FASTA file
 Args    : input_file_name - the input FASTQ/FASTA file name
           output_file_name - the name of the file to write the stats to
 Returns : nothing - either succeeds or calls die()

=cut
sub run
{
  my %params = validate(@_, { input_file_name => 1, output_file_name => 1 });

  my $all_count = 0;
  my $total_bases = 0;
  my $gc_count = 0;
  my $n_count = 0;

  if (!-e $params{input_file_name}) {
    croak "can't find input file: $params{input_file_name}";
  }

  my $format;

  if ($params{input_file_name} =~ /\.(fastq|fq)$/) {
    $format = 'fastfastq';
  } else {
    $format = 'Fasta';
  }

  my $seqio = Bio::SeqIO->new(-file => $params{input_file_name},
                              -format => $format);

  while (defined (my $seq_obj = $seqio->next_seq())) {
    my $sequence;

    if ($format eq 'fastfastq') {
      $sequence = $seq_obj->{sequence};
    } else {
      $sequence = $seq_obj->seq();
    }

    my $seq_len = length $sequence;

    $total_bases += length $sequence;

    $gc_count += $sequence =~ tr/[gcGC]//;
    $n_count += $sequence =~ tr/[nN]//;

    if ($ENV{'SMALLRNA_PIPELINE_TEST'} && $all_count > 1000) {
      last;
    }

    $all_count++;
  }
  
  my %out;
  tie %out, 'Tie::IxHash';

  $out{file} = $params{input_file_name};
  $out{number_of_sequences} = $all_count;
  $out{total_bases} = $total_bases;
  $out{gc_bases} = $gc_count;

  open my $out, '>', $params{output_file_name}
    or die "can't open $params{output_file_name} for writing: $!\n";

  print $out Dump(\%out);

  close $out or die "can't close $params{output_file_name}: $!\n";

  # this is for testing the stats
  return { 'sequence count' => $all_count, 
           'base count' => $total_bases,
           'gc content' => $gc_count,
           'n content' => $n_count
          };
}

1;
