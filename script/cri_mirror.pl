#!/usr/bin/perl -w

use strict;
use warnings;
use Carp;

use SmallRNA::DB;
use SmallRNA::Config;

use Digest::MD5;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);

use CRI::SOAP;
use constant {STARTED => 'STARTED', COMPLETE => 'COMPLETE'};
use constant {TRUE => 1, FALSE => 0};

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

my $cri_mirror_dir = "/data/archive_data/all_cri_data/current_mirror/current";
my $pipeline_data_dir = "/data/pipeline/data";

sub test_checksum
{
  my $cri_checksum = shift;
  my $cri_file_name = shift;

  my $local_checksum_file_name =
    "$cri_mirror_dir/../local_checksums/$cri_file_name.LOCAL_CHECKSUM";

  if (-f $local_checksum_file_name) {
    print "checksum ok\n";
    # we checked the checksum when the file was created
    return 1;
  } else {
    my $full_cri_file_name = "$cri_mirror_dir/$cri_file_name";

    print "checking checksum of $full_cri_file_name ...\n";

    my $local_md5;

    if ($full_cri_file_name =~ /\.srf/) {
      $local_md5 = $cri_checksum;
    } else {
      my $md5 = Digest::MD5->new;

      open my $cri_file, '<', $full_cri_file_name
        or warn "can't open $full_cri_file_name: $!\n";

      $md5->addfile($cri_file);

      close $cri_file or die "can't close $full_cri_file_name\n";


      $local_md5 = $md5->hexdigest();
    }

    if ($cri_checksum eq $local_md5) {
      print "checksum ($local_md5) ok\n";

      open my $local_checksum_file, '>', $local_checksum_file_name
        or die "can't open $local_checksum_file_name for writing: $!\n";

      print $local_checksum_file $local_md5, "\t", $cri_file_name;

      close $local_checksum_file
        or die "can't close $local_checksum_file: $!\n";

      if ((my $new_file_name = $full_cri_file_name) =~
            s!/current_mirror/current/(.*)\.sequence\.txt\.gz$!/$1.fq.gz!) {
        if (-e $new_file_name) {
          die "won't overwrite existing file: $new_file_name\n";
        } else {
          print "linking to $new_file_name ...\n";
          link $full_cri_file_name, $new_file_name
            or die "couldn't create link to $new_file_name: $!\n";
        }
      } else {
        warn "not uncompressing: $full_cri_file_name\n";
      }

      my $new_pipeline_file_name;

      if ((my $new_file_name = $full_cri_file_name) =~
            s!.*/current_mirror/current/(.*)\.sequence\.txt\.gz$!$pipeline_data_dir/fastq/$1.archive.fq!) {
        $new_pipeline_file_name = "fastq/$1.archive.fq";
        if (-e $new_file_name) {
          die "won't overwrite existing file: $new_file_name\n";
        } else {
          print "uncompressing to $new_file_name ...\n";
          gunzip $full_cri_file_name => $new_file_name;
        }
      } else {
        warn "not uncompressing: $full_cri_file_name\n";
      }

      return (2, $new_pipeline_file_name);
    } else {
      warn "checksum didn't match for $cri_file_name: $cri_checksum <> ",
        $local_md5, "\n";

      return 0;
    }
  }
}

while (1) {

  if (0) {
  system <<"COMM";
(cd $cri_mirror_dir
 lftp -u $cri_username,$cri_password -e 'set ftp:ssl-protect-data true; mirror --only-missing current; quit' 193.60.92.203)
COMM
}
  my @new_file_names = ();

  warn "opening $cri_mirror_dir\n";

  opendir my $dir, $cri_mirror_dir
    or die "can't open $cri_mirror_dir: $!\n";

  while (defined (my $file = readdir($dir))) {
    if ($file =~ /\.CHECKSUMS/) {
      print "found: $file\n";

      my $checksums_file_name = "$cri_mirror_dir/$file";

      open my $checksums_file, '<', $checksums_file_name
        or warn "can't open $checksums_file_name: $!\n";

      while (defined (my $line = <$checksums_file>)) {
        if ($line =~ /^([a-z0-9]+)\s+(.*)/) {
          print "checking: $2\n";

          my ($res, $new_pipeline_file_name) = test_checksum($1, $2);

          if ($res == 2) {
            push @new_file_names, $new_pipeline_file_name;
          }
        }
      }

      close $checksums_file or die "can't close $checksums_file_name: $!\n";
    }
  }

  closedir $dir or warn "can't close $cri_mirror_dir: $!\n";

  # find SequencingSamples that don't have a SequencingRun and check if we now have

exit();

  eval {
    my $samp_rs = $schema->resultset('SequencingSample')->
      search_literal('sequencing_sample_id NOT IN (SELECT sequencing_sample
                                                     FROM sequencing_run)');

    while (my $samp = $samp_rs->next()) {
      my $sequencing_centre_identifier =
        $samp->sequencing_centre_identifier();

      next unless defined $sequencing_centre_identifier;

      print "sxl: $sequencing_centre_identifier\n";

      my @statuses = $service->call('getStatuses', $sequencing_centre_identifier);

      my $sample_info = $statuses[0][0];

      print $sample_info->{sampleRequest}->{slxId}, "\n";

      my @file_locations = $sample_info->{fileLocations};

      my $sequence_file_name;

      for my $loc (@file_locations) {
        if (defined $loc->{filename} &&
            $loc->{filename} =~ /\.sequence\.txt/) {
          $sequence_file_name = $loc->{filename};
        }
      }

      if (defined $sequence_file_name) {
        print "found: $sequence_file_name\n";
      }
    }
    print "end\n";
  };
  if ($@) {
    warn "error during eval(): $@\n";
  }
exit();
}
