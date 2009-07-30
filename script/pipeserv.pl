#!/usr/bin/perl -w

use strict;

use DateTime;
use FindBin qw($Bin);

use SmallRNA::DB;
use SmallRNA::DBLayer::Loader;
use SmallRNA::ProcessManager;

use SmallRNA::Web;

my $c = SmallRNA::Web->commandline();
my $config = $c->config();

my $schema = SmallRNA::DB->schema($config);

my $pipedata_rs = $schema->resultset('Pipedata')->search();

my $proc_manager = SmallRNA::ProcessManager->new(schema => $schema);

$proc_manager->create_new_pipeprocesses();

my $conf_rs = $schema->resultset('Pipeprocess');
my $queued_status = $schema->find_with_type('Cvterm', name => 'queued');
my $test_mode = $ENV{SMALLRNA_PIPELINE_TEST} || 0;

while (my $pipeprocess = $conf_rs->next()) {
  my $code = sub {
    if ($pipeprocess->status()->name() eq 'not_started') {
      my $pipeprocess_id = $pipeprocess->pipeprocess_id();
      my $pipework_path = "$Bin/pipework.pl";

      my $command =
        "qsub -v PIPEPROCESS_ID=$pipeprocess_id,SMALLRNA_PIPELINE_TEST=$test_mode $pipework_path";

      open my $qsub_handle, '-|', $command
        or die "couldn't open pipe from qsub: $!\n";

      my $qsub_jobid = <$qsub_handle>;

      chomp $qsub_jobid;

      if (!defined $qsub_handle) {
        die "failed to read the job id from qsub command: $!\n";
      }

      chomp $qsub_handle;

      # finish reading everything from the pipe so that qsub doesn't get a SIGPIPE
      1 while (<$qsub_handle>);

      warn "started job with pipeprocess_id: $pipeprocess_id and job id: $qsub_jobid\n";

      close $qsub_handle or die "couldn't close pipe from qsub: $!\n";

      $pipeprocess->job_identifier($qsub_jobid);
      $pipeprocess->time_queued(DateTime->now());
      $pipeprocess->status($queued_status);
      $pipeprocess->update();

      if (defined $ENV{'PIPESERV_MAX_JOBS'} && $ENV{'PIPESERV_MAX_JOBS'} > 0) {
        for (1..1000) {  # don't do it forever, in case there's a problem
          my $count = 0;

          open PIPE, "qstat|" or die;

          while (defined (my $line = <PIPE>)) {
            $count++ if $line =~ / R batch/;
          }

          if ($count >= $ENV{'PIPESERV_MAX_JOBS'}) {
            warn "$count - sleeping\n";
            sleep (20);
          } else {
            last;
          }
        }
      }

      sleep (1);
    }
  };

  $schema->txn_do($code);
}
