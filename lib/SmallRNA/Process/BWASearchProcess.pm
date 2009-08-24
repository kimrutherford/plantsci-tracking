package SmallRNA::Process::BWASearchProcess;

=head1 NAME

SmallRNA::Process::BWASearchProcess - Run a BWA search on a fasta file

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Process::BWASearchProcess

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
use File::Temp qw(tempfile);

use Bio::SeqIO;

my $BWA_ARGS = "";

sub _do_system
{
  my $system_args = shift;

  my $retcode = system $system_args;

  if ($retcode != 0) {
    warn "system ($system_args) failed: $?\n";

    if ($? == -1) {
      print STDERR "failed to execute: $!\n";
    }
    elsif ($? & 127) {
      printf STDERR "child died with signal %d, %s coredump\n",
        ($? & 127),  ($? & 128) ? 'with' : 'without';
    }
    else {
      printf STDERR "child exited with value %d\n", $? >> 8;
    } 

    die "command failed - exiting\n"; 
  }
}

=head2
 
 Usage   : SmallRNA::Process::BWASearchProcess(input_file_name => $in_file_name,
                                               output_sam_file_name =>
                                                 $out_sam_file_name,
                                               bwa_path => $bwa_path,
                                               database_file_name =>
                                                 $database_file_name);
 Function: Run a BWA search for the given input file against a fasta database
 Args    : input_file_name - the fasta file of reads
           output_sam_file_name - the output sam file path name
           bwa_path - full path to the BWA executable
           database_file_name - the full path to the target database
 Returns : nothing - either succeeds or calls die()

=cut
sub run
{
  my %params = validate(@_, { bwa_path => 1,
                              input_file_name => 1,
                              database_file_name => 1,
                              output_file_name => 1,
                            });

  my $infile_name = $params{input_file_name};
  my $outfile_name = $params{output_file_name};

  my ($fh, $temp_aln_file_name) =
    tempfile('/tmp/bwa_align_temp.XXXXXX', UNLINK => 0);

  my $log_file_name = "/tmp/BWAProcess.log";

  my $aln_command =
    "$params{bwa_path} aln $params{database_file_name} $infile_name $BWA_ARGS";

  _do_system "$aln_command 2>> $log_file_name > $temp_aln_file_name";

  my @samse_files = ($params{database_file_name}, $temp_aln_file_name, $infile_name);
  my $samse_command =
    "$params{bwa_path} samse -n 10000 @samse_files";

  _do_system "$samse_command 2>> $log_file_name > $outfile_name";
}

1;
