use strict;
use warnings;
use Test::More tests => 2;

BEGIN {
  unshift @INC, 't';
  use_ok 'SmallRNA::DBLayer::Loader';
}

use SmallRNA::Config;
use SmallRNA::DB;
use SmallRNATest;

my $config = SmallRNA::Config->new('t/test_config.yaml');

my $schema = SmallRNA::DB->schema($config);

# create database and test directories
SmallRNATest::setup($schema, $config);

my $new_identifier =
  SmallRNA::DBLayer::Loader::get_unique_identifier($schema, 'Sample', 'name', 'SL');

is($new_identifier, 'SL237');
