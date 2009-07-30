use strict;
use warnings;
use Test::More tests => 4;
use File::Temp qw(tempfile);
use Test::Files;

BEGIN {
  unshift @INC, 't';
  use_ok 'SmallRNA::Process::FastaStatsProcess';
}

my $input_file_name = 't/data/reads_fasta_summary_test.fasta';

my ($fh, $output_file_name) =
  tempfile('/tmp/reads_fasta_stats_test.XXXXXX', UNLINK => 0);

my $res = SmallRNA::Process::FastaStatsProcess::run(
  output_file_name => $output_file_name,
  input_file_name => $input_file_name
 );

is($res->{count}, 14);
is($res->{gc_count}, 149);
compare_ok('t/data/expected_fasta_stats.txt', $output_file_name, 
           'output file contents');

