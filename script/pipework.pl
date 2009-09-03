#!/usr/bin/perl -w

# Main work process called through Torque
#
# The id of the Pipeprocess for this worker to run is passed in the
# PIPEPROCESS_ID environment variable
#
# The ProcessConf for the Pipeprocess is used to decide which
# SmallRNA::RunableI to run.  The Pipeprocess is passed to the run() method
# of the SmallRNA::RunableI.

# Find the pipeprocess with ID from the environment, update start time and
# status, run the process then update finished time and status

use strict;

BEGIN {
  push @INC, '/home/kmr44/vc/pipeline/lib';
  push @INC, '/applications/pipeline/perl_lib/share/perl/5.10.0';
};

use DateTime;
use Carp;
use POSIX qw(nice);

use SmallRNA::Config;
use SmallRNA::DB;
use SmallRNA::DBLayer::Loader;
use SmallRNA::PipeWork;

if (!exists $ENV{PIPEPROCESS_ID}) {
  die "no PIPEPROCESS_ID environment variable\n";
}

my $pipeprocess_id = $ENV{PIPEPROCESS_ID};

my $config = SmallRNA::Config->new();
my $schema = SmallRNA::DB->schema($config);

my $started_status = $schema->find_with_type('Cvterm', name => 'started');

my $pipeprocess = $schema->resultset('Pipeprocess')->find($pipeprocess_id);

if (!defined $pipeprocess) {
  croak "error: can't find pipeprocess with id: $pipeprocess_id\n";
}

if (!$ENV{SMALLRNA_PIPELINE_TEST}) {
  POSIX::nice(19);
}

$schema->txn_do(sub {
                  my $time_started = $pipeprocess->time_started();
                  if (defined $time_started) {
                    warn "error: process $pipeprocess_id already started at: $time_started\n";
                  }

                  if ($pipeprocess->status()->name() ne 'queued') {
                    # already started - perhaps two pipeserv.pl processes are
                    # running?
                    warn 'pipeprocess ', $pipeprocess_id,
                      " already started - exiting\n";
                    exit(0);
                  } else {
                    $pipeprocess->time_started(DateTime->now());
                    $pipeprocess->status($started_status);
                    $pipeprocess->update();
                  }
                  SmallRNA::PipeWork::run_process(schema => $schema,
                                                  config => $config,
                                                  pipeprocess => $pipeprocess);
                });
