#!/usr/bin/perl -w

# Set the sequencing_centre_identifier for those sequencing samples that
# are missing one.
# The identifiers are found by querying the CRI LIMS.

use strict;
use CRI::SOAP;
use constant {STARTED => 'STARTED', COMPLETE => 'COMPLETE'};
use constant {TRUE => 1, FALSE => 0};


use SmallRNA::DB;
use SmallRNA::Config;

my $config_file_name = shift;

my $config = SmallRNA::Config->new($config_file_name);

my $schema = SmallRNA::DB->new($config);

my $host = $config->{cri_api}{host};
my $port = $config->{cri_api}{port};
my $cri_username = $config->{cri_api}{username};
my $cri_password = $config->{cri_api}{password};

my $service;

eval {
  warn "connecting ...\n";
  $service = CRI::SOAP->new('https', $host, $port,
                            '/services/genomics/solexa-ws/SolexaExternalBeanWS',
                            'http://solexa.webservice.melab.cruk.org/',
                            "$cri_username:$cri_password", 0);
  warn "connected\n";
};
if($@) {
  print "error: $@\n";
}

eval {
  my $work = sub {
    my $samp_rs = $schema->resultset('SequencingSample')->search({
      sequencing_centre_identifier => undef
     });

    while (my $samp = $samp_rs->next()) {
      my $biosample = ($samp->libraries())[0]->biosample();
      my $name = $biosample->name();

      next unless $name =~ /sl(\d+)/i && $1 > 150;

      print $name, "\n";

      my @statuses = $service->call('getStatuses', $name);
      my $slx_id = $statuses[0][0]->{sampleRequest}->{slxId};

      next unless defined $slx_id;
      print "$slx_id\n";
      next if $slx_id eq 'Unassigned';
      $samp->sequencing_centre_identifier($slx_id);
      $samp->update();
    }
  };

  $schema->txn_do($work);
};

if($@) {
  print "error: $@\n";
}
