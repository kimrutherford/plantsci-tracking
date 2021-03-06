package SmallRNATest;

=head1 NAME

Test - Code to help with testing

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

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
use File::Path;
use File::Copy;
use Exporter;

our @EXPORT = qw(setup);

sub setup
{
  my $schema = shift;
  my $config = shift;

  if ($config->data_directory() !~ m|^/tmp/.|) {
    croak "pipeline_directory in config file should start with /tmp/\n";
  }

  rmtree($config->data_directory());

  my $fastq_dir = $config->data_directory() . '/fastq';
  mkpath($fastq_dir);

  # SL11 is an example of a data set for which we don't have a fastq file
  my $sl11_dir = $config->data_directory() . '/SL11';
  mkpath($sl11_dir);

  copy('t/data/ID24_171007_FC5359.lane4.fq', $fastq_dir) or die;
  copy('t/data/ID24_171007_FC5359.lane5.fq', $fastq_dir) or die;
  copy('t/data/SL54.ID24_171007_FC5359.lane4.fq', $fastq_dir) or die;
  copy('t/data/SL55.ID24_171007_FC5359.lane5.fq', $fastq_dir) or die;
  copy('t/data/SL234_BCF.090202.30W8NAAXX.s_1.fq', $fastq_dir) or die;
  copy('t/data/SL236.090227.311F6AAXX.s_1.fq', $fastq_dir) or die;
  copy('t/data/SL285.090720.42L77AAXX.s_7.fq', $fastq_dir) or die;
  copy('t/data/SL165.080905.306BFAAXX.s_5.fq', $fastq_dir) or die;
  copy('t/data/SL11.ID15_FC5372.lane2.reads.7_5_2008.fa', $sl11_dir) or die;

  my @connect_info = @{$config->{'Model::SmallRNAModel'}{connect_info}};

  if ($connect_info[0] =~ /dbname=([^;]+)/) {
    my $dbname = $1;
    system ("psql --quiet $dbname < t/data/test_data.sql > /dev/null") == 0 
      or croak "psql failed: $@";
  } else {
    croak "can't understand connect string: $connect_info[0]\n";
  }
}

1;

