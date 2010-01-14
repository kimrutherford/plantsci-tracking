#!/usr/bin/perl -w

use strict;
use warnings;
use Carp;

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../../pipeline/svn/lib";
use SmallRNA::DB;
use SmallRNA::Config;


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

my $pipedata_where = <<"WHERE";
    ( SELECT pipedata_property.pipedata
       FROM pipedata_property, cvterm format_type, cvterm property_type
      WHERE pipedata_property.type = property_type.cvterm_id
        AND me.format_type = format_type.cvterm_id
        AND property_type.name LIKE 'alignment %'
        AND pipedata_property.value = '$organism_name'
        AND format_type.name = 'bam' )
WHERE

my $bam_cvterm = $schema->resultset('Cvterm')->find({ name => 'bam' });

my $alignment_types_cv =
  $schema->resultset('Cvterm')
     ->find({ name => 'tracking pipedata property types'});

my $prop_where = <<"WHERE";
  pipedata_property_id in ( SELECT pipedata_property_id from pipedata_property
                              WHERE type IN (SELECT cvterm_id FROM cvterm
                                              WHERE cv_id IN (SELECT cv_id FROM cv
                                                               WHERE name LIKE 'tracking pipedata property types')
                                                AND name LIKE 'alignment ecotype')

                                AND value = '$organism_name')
WHERE

my $pipedata_rs =
  $schema->resultset('PipedataProperty')->search( { },
                                                  { where => \$prop_where } )
    ->search_related('pipedata', { format_type => $bam_cvterm->cvterm_id() },
                     { prefetch => [ {
                       biosample_pipedatas => {
                         biosample => {
                           biosample_pipeprojects => {
                             pipeproject => {
                               owner => 'organisation' } } } } } ] });


my $database_config = "";
my $track_config = "";

while (defined (my $pipedata = $pipedata_rs->next())) {
  my @pipedata_properties = 
    $pipedata->pipedata_properties()->search({}, 
                                               {
                                                 prefetch => 'type'
                                                });

  if (!grep { $_->type()->name() eq 'alignment component' && 
              $_->value() eq $component } @pipedata_properties) {
    next;
  }

  my @biosamples = $pipedata->biosamples();
  my $biosample = $biosamples[0];
  my $biosample_name = $biosample->name();
  my $biosample_description = $biosample->description();

  my $owner = ($biosample->pipeprojects())[0]->owner();
  my $first_name = $owner->first_name();
  my $last_name = $owner->last_name();

  my $org_name = $owner->organisation()->name();

  my $bam_file = $config->data_directory() . '/' . $pipedata->file_name();

  if (! -s $bam_file) {
    warn "can't find $bam_file\n";
    next;
  }

  $database_config .= <<"DATABASE";

[bam_${biosample_name}_db:database]
db_adaptor    = Bio::DB::Sam
db_args       = -bam $bam_file
search options= default

DATABASE

    $track_config .= <<"TRACK";
[$biosample_name]
feature = read_pair
database = bam_${biosample_name}_db
glyph        = arrow
fgcolor      = \\&fgcolor
linewidth    = \\&abundance
description  = 1
key          = $biosample_name - $biosample_description
category     = $org_name - $first_name $last_name
link = \\&seqread_link
west         = sub { my \$f = shift; return \$f->reversed() }  # arrow always points right
east         = sub { my \$f = shift; return !\$f->reversed() } # without this hack

TRACK
}

open my $devnull, '>', '/dev/null' or die;

print "$database_config\n";
print "$track_config\n";
