use strict;
use warnings;
use Test::More tests => 3;
use File::Temp qw(tempfile);
use Test::Files;

use YAML;

use SmallRNA::Config;

BEGIN {
  unshift @INC, 't';
  use_ok 'SmallRNA::Process::BWASearchProcess';
}

my $input_file_name = 't/data/reads_fasta_summary_test.fasta';
my $db_file_name = 't/data/arabidopsis_thaliana_test_genome.fasta';

my ($fh, $output_file_name) =
  tempfile('/tmp/bwa_search_test_sam.XXXXXX', UNLINK => 0);

my $config = SmallRNA::Config->new('t/test_config.yaml')->{programs}{bwa};

my $res = SmallRNA::Process::BWASearchProcess::run(
  bwa_path => $config->{path},
  database_file_name => $db_file_name,
  input_file_name => $input_file_name,
  output_file_name => $output_file_name,
);

ok(-s $output_file_name, 'has output');

compare_ok($output_file_name, "t/data/bwa_search_results.sam",
           'results comparison');
