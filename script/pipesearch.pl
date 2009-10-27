#!/usr/bin/perl -w

use strict;
use warnings;
use Carp;

use SmallRNA::DB;
use SmallRNA::Index::Manager;
use SmallRNA::Config;
use SmallRNA::IndexDB;

use Getopt::Long;

my $config_file_name = shift;

# set defaults
my %options = (
               search_gff => undef,
               search_fasta => undef,
               count_only => undef,
               verbose => undef,
              );

my $option_parser = new Getopt::Long::Parser;
$option_parser->configure("gnu_getopt");

my %opt_config = (
                  "search-gff|g=s" => \$options{search_gff},
                  "search-fasta|s=s" => \$options{search_fasta},
                  "count-only|c" => \$options{count_only},
                  "verbose|v" => \$options{verbose},
                 );

sub usage
{
  die <<"USAGE";
usage: $0 [-v] [-c] <-s|-g> <sequence>

options:
  -s search for a sequence in all non-redundant fasta files
  -g search for occurrence of a sequence in a GFF file
  -c show the count of matches, rather than the matches
  -v verbose

One of -g or -s must be specified
USAGE
}

if (!$option_parser->getoptions(%opt_config)) {
  usage();
}

if (!($options{search_fasta} || $options{search_gff})) {
  usage();
}

my $config = SmallRNA::Config->new($config_file_name);
my $schema = SmallRNA::DB->schema($config);
my $search_sequence = $options{search_fasta} || $options{search_gff};
my $cache = {};
my $index_db = SmallRNA::IndexDB->new(config => $config, cache => $cache);

my @matches;

if ($options{search_fasta}) {
  @matches = $index_db->search_all(schema => $schema, search_file_type => 'fasta',
                                   sequence => $search_sequence,
                                   retrieve_lines => !$options{count_only},
                                   verbose => $options{verbose});
} else {
  @matches = $index_db->search_all(schema => $schema, search_file_type => 'gff3',
                                   sequence => $search_sequence,
                                   retrieve_lines => !$options{count_only},
                                   verbose => $options{verbose});
}

for my $match (@matches) {
  my @results = @{$match->{results}};

  if (@results) {
    print $match->{pipedata}->file_name(), ':';

    if ($options{count_only}) {
      print ' ', scalar(@results), "\n";
    } else {
      print "\n";

      for my $result (@results) {
        my $line = $result->{line};

        print "$line\n";
      }
    }
  }
}
