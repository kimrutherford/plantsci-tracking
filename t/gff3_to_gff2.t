use strict;
use warnings;
use Test::More tests => 3;

use File::Temp qw(tempfile);
use Test::Files;

BEGIN {
  unshift @INC, 't';
  use_ok 'SmallRNA::Process::GFF3ToGFF2Process';
}

my $input_file_name = 't/data/ssaha_search_results.gff3';;

my ($index_fh, $temp_output_file_name) =
  tempfile('/tmp/gff3_to_gff2_test.XXXXXX', UNLINK => 0);

SmallRNA::Process::GFF3ToGFF2Process::run(input_file_name => $input_file_name,
                                          output_file_name => $temp_output_file_name,
                                          sample_name => 'SL260');

ok(-s $temp_output_file_name, 'has output');

compare_ok($temp_output_file_name, 't/data/ssaha_search_results.gff2');
