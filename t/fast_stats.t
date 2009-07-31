use strict;
use warnings;
use Test::More tests => 7;
use File::Temp qw(tempfile);
use Test::Files;

BEGIN {
  unshift @INC, 't';
  use_ok 'SmallRNA::Process::FastStatsProcess';
}

my @inputs = ({ file_name => 't/data/reads_fasta_summary_test.fasta',
                count => 14,
                gc_count => 149,
                expected_file_name => 't/data/expected_fasta_stats.txt'
              },
              { file_name => 't/data/fastfastq.fq',
                count => 8,
                gc_count => 151,
                expected_file_name => 't/data/expected_fastq_stats.txt'
              });
                            
for my $input (@inputs) {
  my $input_file_name = $input->{file_name};

  my ($fh, $output_file_name) =
    tempfile('/tmp/reads_fast_stats_test.XXXXXX', UNLINK => 0);

  my $res = SmallRNA::Process::FastStatsProcess::run(
    output_file_name => $output_file_name,
    input_file_name => $input_file_name
   );

  is($res->{count}, $input->{count});
  is($res->{gc_count}, $input->{gc_count});
  compare_ok($input->{expected_file_name}, $output_file_name,
             'output file contents');
}
