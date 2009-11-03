#!/usr/bin/perl -w

use strict;
use warnings;
use Carp;

use SmallRNA::DB;
use SmallRNA::Config;

my $config_file_name = shift;
my $config = SmallRNA::Config->new($config_file_name);
my $schema = SmallRNA::DB->schema($config);

my $database_config = "";
my $track_config = "";


my $sample_rs = $schema->resultset('Sample');

while (defined (my $sample = $sample_rs->next())) {
  if (($sample->ecotypes())[0]->organism()->full_name() eq 'Arabidopsis thaliana') {
    my $sample_name = $sample->name();

    next if $sample_name =~ /_[A-Z]$/;

    my $owner = ($sample->pipeprojects())[0]->owner();
    my $first_name = $owner->first_name();
    my $last_name = $owner->last_name();

    my $org_name = $owner->organisation()->name();

    my $bam_file = "/data/pipeline/results/node3_test_data/$sample_name/$sample_name.v_Arabidopsis_thaliana_genome.patman.gff3.sam.bam.sorted";

    next if ! -s $bam_file;

    if (1) {
      $database_config .= <<"DATABASE";

[bam_${sample_name}_db:database]
db_adaptor    = Bio::DB::Sam
db_args       = -bam $bam_file
search options= default

DATABASE
    }

    $track_config .= <<"TRACK";
[$sample_name]
feature = read_pair
database = bam_${sample_name}_db
glyph        = arrow
fgcolor      = \\&fgcolor
linewidth    = \\&abundance
description  = 1
key          = $sample_name
category     = $org_name - $first_name $last_name

TRACK

  }
}

open my $devnull, '>', '/dev/null' or die;

my $init_code = <<'INIT_CODE';
INIT_CODE

print <<'END';
[GENERAL]
description   = Arabidopsis thaliana TAIR8
database      = arabidopsis_base

initial landmark = Chr1:1504365..1514364

default tracks = transposable_element
    Chromosome:overview

# examples to show in the introduction
examples = Chr1:1504365..1514364
           ChrC:63781..68780

plugins = FastaDumper

link = sub {
        my $feature = shift;
        my $name = $feature->name();
        $name =~ s/-\d+-\d+//;
        return "http://node3/ui/view/seqread/$name";
      }

# "automatic" classes to try when an unqualified identifier is given
automatic classes = chromosome gene five_prime_UTR mRNA exon three_prime_UTR

init_code = sub fgcolor {
  my $feature=shift;
  my $len = ($feature->stop - $feature->start +1);
  return "pink" if ($len >=15 and $len <20);
  return "red" if ($len >=20 and $len <= 21);
  return "green" if $len >=22 and $len <=23;
  return "blue" if $len >=24 and $len <=25;
  return "gray"
 }
 sub abundance{
   my $feature = shift;
   my $score;
   if ($feature->can('get_tag_values')) {
     $score = $feature->get_tag_values('XS')
   } else {
     $score = $feature->score;
   }
   return log($score); 
 }

#################################
# database definitions
#################################
[arabidopsis_base:database]
db_adaptor    = Bio::DB::SeqFeature::Store
db_args       = -adaptor	DBI::mysql
                -dsn	dbi:mysql:database=arabidopsis_tair_8:host=localhost
                -user	pipe
                -pass   pipe

[arabidopsis_annotation:database]
db_adaptor    = Bio::DB::GFF
db_args       = -adaptor	DBI::mysql
                -dsn	dbi:mysql:database=arath_TAIR7:host=hydrogen
                -user	pipe
                -pass   pipe

END

print $database_config;


print <<'END';

######### end database definitions ############

# Default glyph settings
[TRACK DEFAULTS]
glyph       	= generic
height      	= 8
bgcolor     	= steelblue
fgcolor     	= black
label density	= 25
bump density  	= 100
default varying = 1

### TRACK CONFIGURATION ####
# the remainder of the sections configure individual tracks

#[Chromosome:overview]
#feature		= chromosome
#bgcolor       	= lightslategray
#glyph         	= generic
#fgcolor       	= black
#height        	= 8
#point         	= 1
#citation      	= This track shows the entire chromosome.  A vertical red line shows the position of the detail view below.
#key           	= Chromosome

[RepeatMasker]
feature      = RepeatMasker
glyph        = generic
bgcolor      = white
fgcolor      = orange
strand_arrow = 1
height       = 8
description  = 1
key          = RepeatMasker
link         = AUTO

[tandem_repeat]
feature      = tandem_repeat
glyph        = generic
bgcolor      = white
fgcolor      = orange
strand_arrow = 1
height       = 8
description  = 1
key          = Tandem repeat
link         = AUTO


[IR]
feature      = IR
glyph        = generic
bgcolor      = white
fgcolor      = orange
strand_arrow = 1
height       = 8
description  = 1
key          = Inverted repeat
link         = AUTO

[CEN:overview]
feature      = CEN
glyph        = generic
bgcolor      = white
fgcolor      = orange
strand_arrow = 1
height       = 8
description  = 1
key          = Centromere
link         = AUTO

[CEN_genetic:overview]
feature      = CEN_genetic
glyph        = generic
bgcolor      = white
fgcolor      = orange
strand_arrow = 1
height       = 8
description  = 1
key          = Centromere (genetic)
link         = AUTO



[CEN]
feature      = CEN
glyph        = generic
bgcolor      = white
fgcolor      = orange
strand_arrow = 1
height       = 8
description  = 1
key          = Centromere
link         = AUTO

[CEN_genetic]
feature      = CEN_genetic
glyph        = generic
bgcolor      = white
fgcolor      = orange
strand_arrow = 1
height       = 8
description  = 1
key          = Centromere (genetic)
link         = AUTO


[methylated_region]
feature      = methylated_region
glyph        = generic
bgcolor      = white
fgcolor      = orange
strand_arrow = 1
height       = 8
description  = 1
key          = Methylated region (Ecker)
link         = AUTO




[drm1_drm2_cmt3_methylated_region]
feature      = drm1_drm2_cmt3_methylated_region
glyph        = generic
bgcolor      = white
fgcolor      = orange
strand_arrow = 1
height       = 8
description  = 1
key          = drm1_drm2_cmt3_methylated_region (Ecker)
link         = AUTO



[met1_methylated_region]
feature      = met1_methylated_region
glyph        = generic
bgcolor      = white
fgcolor      = orange
strand_arrow = 1
height       = 8
description  = 1
key          = met1_methylated_region (Ecker)
link         = AUTO


#[Chromosome:overview]
#feature		= chromosome
#bgcolor       	= lightslategray
#glyph         	= generic
#fgcolor       	= black
#height        	= 8
#point         	= 1
#citation      	= This overview track shows the entire chromosome.
#key           	= Chromosome

[BAC]
feature      	= BAC_cloned_genomic_insert
glyph        	= anchored_arrow
bgcolor      	= darkviolet
strand_arrow 	= 1
description  	= 1
category	= Assembly
key          	= Annotation Units
link         	= http://www.arabidopsis.org/servlets/TairObject?name=$name&type=assembly_unit
citation     	= This track shows the BAC sequences.

[Locus]
feature      	= gene pseudogene
glyph        	= generic
bgcolor      	= darksalmon
fgcolor      	= black
font2color   	= blue
strand_arrow 	= 1
height       	= 6
ignore_sub_part = pseudogenic_transcript mRNA ncRNA tRNA snoRNA snRNA rRNA
link         	= http://www.arabidopsis.org/servlets/TairObject?name=$name&type=locus
description  	= 1
key          	= Locus
category     	= Gene
citation     	= This track shows the set of loci in this section of the chromosome.

[ProteinCoding]
feature         = mRNA
glyph           = processed_transcript
bgcolor         = steelblue
fgcolor         = blue
utr_color       = lightblue
label density   = 50
bump density    = 150
description     = 0
link		= http://www.arabidopsis.org/servlets/TairObject?name=$name&type=gene
key             = Protein Coding Gene Models
category        = Gene
citation        = This track shows the transcript of the genes in this section of the chromosome.

[CDS]
feature      	= mRNA
glyph        	= cds
height		= 30
sixframe	= 1
ignore_empty_phase	= 1
frame0f      	= cadetblue
frame1f      	= blue
frame2f      	= darkblue
frame0r      	= darkred
frame1r      	= red
frame2r      	= crimson
font2color	= blue
description	= 0
category	= Gene
key          	= CDS
citation     	= This track shows coding segments for the genes in this section of the chromosome.

[Pseudogene]
feature       	= pseudogenic_transcript
glyph         	= processed_transcript
fgcolor       	= black
bgcolor       	= darkturquoise
height        	= 5
stranded      	= 1
link            = http://www.arabidopsis.org/servlets/TairObject?name=$name&type=gene
key           	= Pseudogenes
category      	= Gene
citation      	= This track shows the pseudogenes or transposons in this section of the chromosome.

[ncRNAs]
feature       	= ncRNA miRNA tRNA snoRNA snRNA rRNA
glyph         	= processed_transcript
fgcolor       	= black
bgcolor       	= mediumorchid
stranded      	= 1
description   	= 1
category	= Gene
link            = http://www.arabidopsis.org/servlets/TairObject?name=$name&type=gene
key           	= Noncoding RNAs
citation      	= This track shows the non-coding RNA sequences.
font2color	= blue
description     = sub {
                        	my $feature = shift;
                        	#my %atts = $feature->attributes;
				#my @load_id = $feature->attributes('load_id');
                        	my $type = $feature->type();
				$type =~ s/^(.*):.*$/$1/;
				$type =~ s/ncRNA/other_RNA/;
				#print "$group\n";
				#foreach my $key (@load_id) #(keys %atts)
				#{
			#		#print "keys $key $atts{$key}\n";
		#			print "$key\n";
	#			}
				return $type;
        		}

[cDNA]
feature       	= cDNA_match
glyph         	= segments
draw_target   	= 1
stranded      	= 1
show_mismach  	= 1
ragged_start  	= 1
bgcolor       	= olivedrab
fgcolor       	= black
#connector     	= solid
group_pattern 	= /\([53]'\)$/
key           	= cDNAs
category      	= Sequence Similarity
font2color    	= blue
label		= sub {
			my $feature = shift;
			my ($alias) = $feature->attributes('Alias');
			return $alias;
		}
link            = http://www.arabidopsis.org/servlets/TairObject?name=$name&type=clone
citation      	= This track shows the cDNA sequences.

[EST]
feature    	= EST_match
glyph           = segments
draw_target     = 1
stranded	= 1
show_mismatch   = 1
ragged_start	= 1
height		= 6
bgcolor         = sub { my $f = shift; return $f->strand > 0 ? 'yellowgreen':'darkkhaki'}
fgcolor		= black
#connector	= dashed
group_pattern   = /\([53]'\)/
font2color      = blue
label		= sub {
			my $feature = shift;
			my ($alias) = $feature->attributes('Alias');
			return $alias;
		}
label density	= 50
key            	= ESTs
category       	= Sequence Similarity
link            = http://www.arabidopsis.org/servlets/TairObject?name=$name&type=cloneend
#link           	= sub {
#                       	my $feature = shift;
#                       	my $name = $feature->attributes('Name');
#                       	#$name2 =~ s/(\(5'\))/ $1/;
#                       	#$name2 =~ s/(\(3'\))/ $1/;
#			return "http://www.arabidopsis.org/servlets/TairObject?name=$name&type=cloneend";
#      		}
citation         	= This track shows the EST sequences.

[EST:20001]
bump	= 0

[EST:1]
bump	= 1

[tDNAs]
feature       	= transposable_element_insertion_site
glyph         	= pinsertion
fgcolor       	= black
bgcolor       	= peru
height        	= 8
length		= 8
stranded      	= 1
description   	= 1
key           	= tDNAs/Transposons
category      	= Variation
link          	= http://www.arabidopsis.org/servlets/TairObject?name=$name&type=polyallele
citation      	= This track shows the tDNA sequences.

[Polymorphism]
feature      	= Allele:Allele deletion:Allele substitution:Allele insertion:Allele indel:Allele compound:Allele
glyph        	= sub {
                	my $feature = shift;
                	return 'triangle' if $feature->method =~ /indel/i;
                	return 'box'      if $feature->method =~ /compound/i;
                	return 'diamond';
        	}
bgcolor      	= sub {
                	my $feature = shift;
                	my $source = $feature->method;
                	return 'red'    if $source eq 'deletion';
                	return 'yellow' if $source eq 'substitution';
                	return 'green'  if $source eq 'insertion';
                	return 'purple' if $source =~ /compound/i;
                	return 'blue'   if $source =~ /Indel/i;
                	return 'white';
        	}
fgcolor      	= black
font2color   	= blue
height       	= 8
description  	= sub {
                	my $feature = shift;
                	my $source = $feature->method;
                	return 'substitution' if $source =~ /substitution/i;
                	return 'deletion'     if $source eq 'deletion';
                	return 'insertion'    if $source eq 'insertion';
                	return 'Indel'        if $source =~ /Indel/i;
                	return 'Compound'     if $source =~ /Compound/i;
                	return $source;
        	}
link         	= http://www.arabidopsis.org/servlets/TairObject?name=$name&type=polyallele
key          	= Polymorphisms
category     	= Variation
citation     	= This track shows polymorphisms.

[Marker]
feature      	= marker
glyph        	= generic
bgcolor      	= firebrick
height       	= 5
key          	= Marker
category     	= Variation
labeldensity 	= 25
label	= sub {
				my $feature = shift;
				my $n = $feature->name();
				$n =~ s/\~/,/g;
				return $n;
			}
font2color   	= blue
link			= sub {
				my $feature = shift;
				my $n = $feature->name();
				$n =~ s/\~/,/g;
				my $lin = "http://www.arabidopsis.org/servlets/TairObject?name=$n&type=marker";
				return $lin;
			}
citation     	= This track show the markers.

[DNA]
glyph          	= dna
#global feature 	= 1
height         	= 40
do_gc          	= 1
fgcolor        	= red
axis_color     	= blue
glyph           = translation
#global feature  = 1
height          = 40
fgcolor         = purple
start_codons    = 0
stop_codons     = 1
translation     = 6frame
#show		= 0
key             = 6-Frame Translation
category        = DNA
citation        = This track shows the 6-frame DNA translation of this part of the chromosome.

############################################################################################################

[mature]
feature      = match:mirBase10.mature
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = 1
height       = 6
description  = 1
key          = mirBase 10.0 mature
#link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name

[maturestar]
feature      = match:mirBase10.maturestar
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = 1
height       = 6
description  = 1
key          = mirBase 10.0 mature star
#link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name

[hairpin]
feature      = match:mirBase10.hairpin
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = 1
height       = 6
description  = 1
key          = mirBase 10.0 hairpin
#link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



############################################################################################################

[AGO1_July06]
feature      = ssaha:AGO1_July06
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = AGO1_July06
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name





[AGO4_A_combined]
feature      = ssaha:AGO4_A_combined
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = AGO4_A_combined
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



#[AGO4_April_06_A]
#feature      = ssaha:AGO4_April_06_A
#glyph        = arrow
#fgcolor      = \&fgcolor
#linewidth    = \&abundance
##height       = 6
#description  = 1
#key          = AGO4_April_06_A
#link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[AGO4_April_06_B]
feature      = ssaha:AGO4_April_06_B
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = AGO4_April_06_B
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name




#[AGO4_C_July06]
#feature      = ssaha:AGO4_C_July06
#glyph        = arrow
#fgcolor      = \&fgcolor
#linewidth    = \&abundance
##height       = 6
#description  = 1
#key          = AGO4_C_July06
#link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[AGO4_C_combined_July06]
feature      = ssaha:AGO4_C_combined_July06
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = AGO4_C_combined_July06
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[AGO4_combined_April_July06]
feature      = ssaha:AGO4_combined_April_July06
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = AGO4_combined_April_July06
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name





[A_thaliana_Col-0_flower]
feature      = ssaha:A_thaliana_Col-0_flower
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = A_thaliana_Col-0_flower
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Arabidopsis_C24a_10_05_06]
feature      = ssaha:Arabidopsis_C24a_10_05_06
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Arabidopsis_C24a_10_05_06
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Arabidopsis_C24b_10_05_06]
feature      = ssaha:Arabidopsis_C24b_10_05_06
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Arabidopsis_C24b_10_05_06
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Arabidopsis_esp4a_10_05_06]
feature      = ssaha:Arabidopsis_esp4a_10_05_06
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Arabidopsis_esp4a_10_05_06
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Arabidopsis_esp4b_10_05_06]
feature      = ssaha:Arabidopsis_esp4b_10_05_06
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Arabidopsis_esp4b_10_05_06
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Arabidopsis_esp5a_10_05_06]
feature      = ssaha:Arabidopsis_esp5a_10_05_06
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Arabidopsis_esp5a_10_05_06
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Arabidopsis_esp5b_10_05_06]
feature      = ssaha:Arabidopsis_esp5b_10_05_06
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Arabidopsis_esp5b_10_05_06
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Carrington_dcl1-7]
feature      = ssaha:Carrington_dcl1-7
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Carrington_dcl1-7
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Carrington_dcl2-1]
feature      = ssaha:Carrington_dcl2-1
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Carrington_dcl2-1
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Carrington_dcl3-1]
feature      = ssaha:Carrington_dcl3-1
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Carrington_dcl3-1
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Carrington_dcl4-2]
feature      = ssaha:Carrington_dcl4-2
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Carrington_dcl4-2
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Carrington_rdr1-1]
feature      = ssaha:Carrington_rdr1-1
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Carrington_rdr1-1
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Carrington_rdr2-1]
feature      = ssaha:Carrington_rdr2-1
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Carrington_rdr2-1
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Carrington_rdr6-15]
feature      = ssaha:Carrington_rdr6-15
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Carrington_rdr6-15
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Carrington_wt]
feature      = ssaha:Carrington_wt
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Carrington_wt
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Col_June_06]
feature      = ssaha:Col_June_06
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Col_June_06
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Col_March_06]
feature      = ssaha:Col_March_06
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Col_March_06
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Col_October_05]
feature      = ssaha:Col_October_05
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Col_October_05
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Col_combined]
feature      = ssaha:Col_combined
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Col_combined
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name





[GSM121453_rdr2]
feature      = ssaha:GSM121453_rdr2
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = GSM121453_rdr2
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[GSM121454_rdr6]
feature      = ssaha:GSM121454_rdr6
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = GSM121454_rdr6
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[GSM121455_wt]
feature      = ssaha:GSM121455_wt
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = GSM121455_wt
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[GSM121456]
feature      = ssaha:GSM121456
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = GSM121456_dcl1-7
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[GSM121457_dcl234]
feature      = ssaha:GSM121457_dcl234
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = GSM121457_dcl234
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Hannon_AGO1_GSM149080]
feature      = ssaha:Hannon_AGO1_GSM149080
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Hannon_AGO1_GSM149080
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Hannon_AGO4_GSM149081]
feature      = ssaha:Hannon_AGO4_GSM149081
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Hannon_AGO4_GSM149081
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Hannon_whole_extracts_GSM149079]
feature      = ssaha:Hannon_whole_extracts_GSM149079
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Hannon_whole_extracts_GSM149079
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Henderson_WT]
feature      = ssaha:Henderson_WT
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Henderson_WT
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Henderson_dcl234]
feature      = ssaha:Henderson_dcl234
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Henderson_dcl234
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[ID25_lane3_new_matrix]
feature      = ssaha:ID25_lane3_new_matrix
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = ID25_lane3_new_matrix.fna
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[ID25_lane4_new_matrix]
feature      = ssaha:ID25_lane4_new_matrix
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = ID25_lane4_new_matrix.fna.clones.trimmed.fa
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[ID25_lane5_new_matrix]
feature      = ssaha:ID25_lane5_new_matrix
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = ID25_lane5_new_matrix.fna.clones.trimmed.fa
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[JH_TCV_earlyIL]
feature      = ssaha:JH_TCV_earlyIL
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = JH_TCV_earlyIL
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[JH_TCV_lateSL]
feature      = ssaha:JH_TCV_lateSL
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = JH_TCV_lateSL
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[JH_mock_earlyIL]
feature      = ssaha:JH_mock_earlyIL
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = JH_mock_earlyIL
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[JH_mock_lateSL]
feature      = ssaha:JH_mock_lateSL
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = JH_mock_lateSL
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[March_07_Col_seedlings]
feature      = ssaha:March_07_Col_seedlings
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = March_07_Col_seedlings
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[March_07_Col_seedlings_2w_cold]
feature      = ssaha:March_07_Col_seedlings_2w_cold
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = March_07_Col_seedlings_2w_cold
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[March_07_fca_fpa_seedlings]
feature      = ssaha:March_07_fca_fpa_seedlings
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = March_07_fca_fpa_seedlings
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Nicolas_Arabidopsis]
feature      = ssaha:Nicolas_Arabidopsis
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Nicolas_Arabidopsis
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Rajagopalan_rosette_leaves]
feature      = ssaha:Rajagopalan_rosette_leaves
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Rajagopalan_rosette_leaves
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Rajagopalan_siliques]
feature      = ssaha:Rajagopalan_siliques
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Rajagopalan_siliques
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Rajagopalan_whole_flowers]
feature      = ssaha:Rajagopalan_whole_flowers
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Rajagopalan_whole_flowers
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[Rajagopalan_whole_seedlings]
feature      = ssaha:Rajagopalan_whole_seedlings
glyph        = arrow
fgcolor      = \&fgcolor
linewidth    = \&abundance
#height       = 6
description  = 1
key          = Rajagopalan_whole_seedlings
link         = /cgi-bin/srna_db/rna_sequence_summary_page.cgi?sequence=$name



[BAC]
feature      	= BAC_cloned_genomic_insert
glyph        	= anchored_arrow
bgcolor      	= darkviolet
strand_arrow 	= 1
description  	= 1
category	= Assembly
key          	= Annotation Units
link         	= http://www.arabidopsis.org/servlets/TairObject?name=$name&type=assembly_unit
citation     	= The positions of the BAC and other genomic clones making up the tiling path are shown.


[Locus]
feature      	= gene pseudogene transposable_element_gene
glyph        	= generic
bgcolor      	= darksalmon
fgcolor      	= black
font2color   	= blue
strand_arrow 	= 1
height       	= 6
ignore_sub_part = pseudogenic_transcript mRNA ncRNA tRNA snoRNA snRNA rRNA
link         	= http://www.arabidopsis.org/servlets/TairObject?name=$name&type=locus
description  	= 1
key          	= Locus
category     	= Gene
title		= sub {
				my $feature = shift;
				my $n = $feature->name();
				my $ref = $feature->seq_id();
				my $start = $feature->start();
				my $end = $feature->end();
				return "Locus: $n $ref:$start..$end";
			}

citation     	= Each locus along with its type is shown here.  Loci are essentially equivalent to genes.



[ProteinCoding]
feature         = mRNA
glyph           = processed_transcript
bgcolor         = steelblue
fgcolor         = blue
utr_color       = lightblue
label density   = 50
bump density    = 150
description     = 0
link		= http://www.arabidopsis.org/servlets/TairObject?name=$name&type=gene
key             = Protein Coding Gene Models
category        = Gene
citation        = Splice variants for loci classed as protein-coding appear in this track.  

END

print "$track_config\n";
