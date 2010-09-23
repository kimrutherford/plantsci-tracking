#!/usr/bin/perl -w

use strict;
use warnings;
use Carp;

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../../pipeline/svn/lib";
use SmallRNA::DB;
use SmallRNA::Config;

use DBI qw(:sql_types);

my $config_file_name = shift;
my $config = SmallRNA::Config->new($config_file_name);
my $schema = SmallRNA::DB->new($config);

if (@ARGV < 1) {
  croak "$0: error two arguments needed - the config file name and the organism name\n";
}

my $component = $ARGV[1] || 'genome';

my $organism_name = shift;
my $genus;
my $species;

if ($organism_name =~ /(.*)_(.*)/) {
  $genus = $1;
  $species = $2;
} else {
  croak qq(organism name argument needs to be "Genus_species"\n);
}

my $bam_cvterm = $schema->resultset('Cvterm')->find({ name => 'bam' });

my $bam_cvterm_id = $bam_cvterm->cvterm_id();

my $where = <<"WHERE";
  format_type = $bam_cvterm_id
AND
  pipedata_id IN (
    SELECT pipedata
     FROM pipedata_property, cvterm
    WHERE pipedata_property.type = cvterm.cvterm_id
      AND name = 'alignment component'
      AND value = '$component')
AND
  pipedata_id IN (
    SELECT pipedata from
           pipedata_property
                            WHERE type IN (SELECT cvterm_id FROM cvterm
                                              WHERE cv_id IN (SELECT cv_id FROM cv
                                                               WHERE name LIKE 'tracking pipedata property types')
                                                AND name LIKE 'alignment ecotype')

                                AND value = '$organism_name')
WHERE

my $pipedata_rs =
  $schema->resultset('Pipedata')->search( { },
                     { where => \$where,
                       prefetch => [
                       {
                       pipedata_properties => 'type',
                       biosample_pipedatas => {
                         biosample => {
                           biosample_pipeprojects => {
                             pipeproject => {
                               owner => 'organisation' } } } } } ] });


my $database_config = "";
my $track_config = "";

# my @pipedatas = $pipedata_rs->all();
# my @component_pipedata_ids = ();

# my $props_query = <<"END";
# SELECT pipedata_id, cvterm.name, value
#   FROM pipedata, pipedata_property, cvterm
#  WHERE pipedata_property.pipedata = pipedata.pipedata_id
#    AND pipedata_property.type = cvterm.cvterm_id
#    AND cvterm.name = 'alignment component'
#    AND pipedata_id in (?)
#    AND pipedata_property.value = ?
# END

# my $dbh = $schema->storage()->dbh();
# my $sth = $dbh->prepare($props_query) || die $dbh->errstr;
# $sth->bind_param(1, [map { int($_->pipedata_id()) } @pipedatas], { TYPE => SQL_INTEGER });
# $sth->bind_param(2, $component);

# $sth->execute() || die $sth->errstr;;
# while (my $r = $sth->fetchrow_hashref()) {
#   my $pipedata_id = $r->{pipedata_id};
#   push @component_pipedata_ids, $pipedata_id;
# }

# die "@component_pipedata_ids\n";


# $pipedata_rs->reset();

while (defined (my $pipedata = $pipedata_rs->next())) {
  my @samples = $pipedata->biosamples();
  my $sample = $samples[0];
  next unless defined $sample;
  my $sample_name = $sample->name();
  my $sample_description = $sample->description();

  my $owner = ($sample->pipeprojects())[0]->owner();
  my $first_name = $owner->first_name();
  my $last_name = $owner->last_name();

  my $org_name = $owner->organisation()->name();

  my $bam_file = $config->data_directory() . '/' . $pipedata->file_name();

  if (! -s $bam_file) {
    warn "can't find $bam_file\n";
    next;
  }

  $database_config .= <<"DATABASE";

[bam_${sample_name}_db:database]
db_adaptor    = Bio::DB::Sam
db_args       = -bam $bam_file
search options= default

DATABASE

    $track_config .= <<"TRACK";
[$sample_name]
feature = read_pair
database = bam_${sample_name}_db
glyph        = arrow
fgcolor      = \\&fgcolor
linewidth    = \\&abundance
description  = 1
key          = $sample_name - $sample_description
category     = $org_name - $first_name $last_name
link = \\&seqread_link
west         = sub { my \$f = shift; return \$f->reversed() }  # arrow always points right
east         = sub { my \$f = shift; return !\$f->reversed() } # without this hack

TRACK
}

open my $devnull, '>', '/dev/null' or die;

print "$database_config\n";
print "$track_config\n";
