#!/usr/bin/perl -w

use strict;
use warnings;
use Carp;

use SmallRNA::DB;
use SmallRNA::DBLayer::Loader;
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
  warn "connecting to $cri_username\@$host:$port ...\n";
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
my $pipeline_data_dir = $config->data_directory();

my $cri_fastq_file_suffix = '.sequence.txt';

sub test_checksum
{
  my $cri_checksum = shift;
  my $cri_file_name = shift;

  my $local_checksum_file_name =
    "$cri_mirror_dir/../local_checksums/$cri_file_name.LOCAL_CHECKSUM";

  if (-f $local_checksum_file_name) {
    print "checksum from previous run ok\n";
    # we checked the checksum when the file was created
    return 1;
  } else {
    my $full_cri_file_name = "$cri_mirror_dir/$cri_file_name";

    print "checking checksum of $full_cri_file_name ...\n";

    my $local_md5;

    if (0 && $full_cri_file_name =~ /\.srf/) {
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
            s!/current_mirror/current/!/!) {
        if (-e $new_file_name) {
          die "won't overwrite existing file: $new_file_name\n";
        } else {
          print "linking to $new_file_name ...\n";
          link $full_cri_file_name, $new_file_name
            or die "couldn't create link to $new_file_name: $!\n";
        }
      } else {
        warn "not linking: $full_cri_file_name\n";
      }

      my $new_pipeline_file_name;

      if ((my $new_file_name = $full_cri_file_name) =~
            s{.*/current_mirror/current/(.*$cri_fastq_file_suffix)\.gz$}
             {$pipeline_data_dir/fastq/$1.fq}) {
        $new_pipeline_file_name = "fastq/$1.fq";
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

my $loader = SmallRNA::DBLayer::Loader->new(schema => $schema);

while (1) {

  # mirror, then check the checksums of new files

  system <<"COMM";
(cd $cri_mirror_dir/..
 lftp -u $cri_username,$cri_password -e 'set ftp:ssl-protect-data true; mirror --only-missing current; quit' 193.60.92.203)
COMM

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

  # Find SequencingRuns that don't have an initial_pipedata and check if we
  # have a data file now

  eval {
    print "querying ...\n";

    my $run_rs = $schema->resultset('SequencingRun')->
      search({ initial_pipedata => undef },
             { prefetch => 'sequencing_sample' });

    while (my $run = $run_rs->next()) {
      my $sequencing_sample = $run->sequencing_sample();
      my $sequencing_centre_identifier =
        $sequencing_sample->sequencing_centre_identifier();

      next unless defined $sequencing_centre_identifier;

      print "sxl: $sequencing_centre_identifier\n";

      my @statuses = $service->call('getStatuses', $sequencing_centre_identifier);

      my $sample_info = $statuses[0][0];

      if (!defined $sample_info) {
        warn "no sample information for: $sequencing_centre_identifier\n";
        next;
      }

      print $sample_info->{sampleRequest}->{slxId}, "\n";

      next unless defined $sample_info->{fileLocations};

      my @file_locations = @{$sample_info->{fileLocations}};

      my $sequence_file_name;

      for my $loc (@file_locations) {
        if (defined $loc->{filename} &&
            $loc->{filename} =~ /\.sequence\.txt/) {
          $sequence_file_name = $loc->{filename};
        }
      }

      next unless defined $sequence_file_name;

      print "found file name in LIMS: $sequence_file_name\n";

      $sequence_file_name =~ s<(.*)\.gz><fastq/$1.fq>;

      my @biosamples = map { $_->biosample() } $sequencing_sample->libraries();
      my $molecule_type = $biosamples[0]->molecule_type()->name();

      if (grep { $_ eq $sequence_file_name } @new_file_names) {
        $loader->create_initial_pipedata($config, $run, $sequence_file_name,
                                         $molecule_type, [@biosamples]);
        print "added $sequence_file_name to the database\n";
      } else {
        warn "no matching file downloaded for $sequence_file_name\n";
        # we might have downloaded it but failed to add it to the database,
        # so try again if there isn't a pipedata for the file
        if (-f $pipeline_data_dir . '/' . $sequence_file_name) {
          if ($schema->resultset('Pipedata')->
                search({file_name => $sequence_file_name})->count() == 0) {
            $loader->create_initial_pipedata($config, $run, $sequence_file_name,
                                             $molecule_type, [@biosamples]);
          }
        }
      }
    }
    print "finished local database check\n";
  };
  if ($@) {
    warn "error during eval(): $@\n";
  }

  print "sleeping ...\n";

  sleep 60*60;
}
