#!/usr/bin/perl -w

# script to populate the barcode table

use strict;
use warnings;
use Carp;

use SmallRNA::DB;
use SmallRNA::DBLayer::Loader;

use SmallRNA::Web;

my $c = SmallRNA::Web->commandline();
my $config = $c->config();

my $schema = SmallRNA::DB->schema($config);

my %barcodes = (
                TACCT => 'A',
                TACGA => 'B',
                TAGCA => 'C',
                TAGGT => 'D',
                TCAAG => 'E',
                TCATC => 'F',
                TCTAC => 'G',
                TCTTG => 'H',
                TGAAC => 'I',
                TGTTG => 'J',
                TGTTC => 'K',
               );

my $loader = SmallRNA::DBLayer::Loader->new(schema => $schema);

$schema->txn_do(sub {
  my $set_rs = $schema->resultset('BarcodeSet');
  my $set = $set_rs->create({ name => 'DBC set' });

  for my $barcode (sort keys %barcodes) {
    my $barcode_identifier = $barcodes{$barcode};

    my $rs = $schema->resultset('Barcode');
    $rs->create({
                 identifier => $barcode_identifier,
                 code => $barcode,
                 barcode_set => $set
                });
  }
});

my %terms = (
             'tracking file format types' =>
             {
              'fastq' => 'FastQ format file',
              'fs' => 'FASTA format with an empty description line',
              'fasta' => 'FASTA format',
              'gff2' => 'GFF2 format',
              'gff3' => 'GFF3 format',
              'seq_offset_index' => 'An index of a GFF3 or FASTA format file',
              'text' => 'A human readable text file with summaries or statistics',
              'tsv' => 'A file containing tab-separated value',
             },
             'tracking file content types' =>
             {
              'raw_srna_reads' =>
                'Raw small RNA sequence reads from a non-multiplexed sequencing run, before any processing',
              'multiplexed_srna_reads' =>
                'Raw small RNA sequence reads from a multiplexed sequencing run, before any processing',
              'raw_genomic_dna_reads' =>
                'Raw DNA sequence reads with quality scores',
              'srna_reads' =>
                'Small RNA sequence reads that have been processed to remove adapters',
              'non_redundant_srna_reads' =>
                'Small RNA sequence reads without adapters with redundant sequences removed',
              'genomic_dna_reads' =>
                'Genomic DNA reads',
              'non_redundant_genomic_dna_reads' =>
                'DNA sequence reads with redundant sequences removed',
              'genomic_dna_tags' =>
                'DNA reads that have been trimmed to a fixed number of bases',
              'non_redundant_genomic_dna_tags' =>
                'Trimmed DNA sequence reads with redundant sequences removed',
              'srna_reads_nuclear_alignment' =>
                'Small RNA to genome alignments',
              'srna_reads_mitochondrial_alignment' =>
                'Small RNA to mitochondrial dna alignments',
              'srna_reads_chloroplast_alignment' =>
                'Small RNA to chloroplast dna alignments',
              'remove_adapter_rejects' =>
                'Small RNA sequence reads that were rejected by the remove adapters step',
              'remove_adapter_unknown_barcode' =>
                'Small RNA sequence reads that were rejected by the remove adapters step because they did not match an expected barcode',
              'first_base_summary' =>
                'A summary of the first base composition of sequences from a fasta file',
              'fasta_stats' =>
                'Summary information and statistics about a FASTA file',
              'fastq_stats' =>
                'Summary information and statistics about a FASTQ file',
              'genome_aligned_srna_reads' =>
                'Small RNA reads that have been aligned against the genome',
              'genome_aligned_genomic_dna_reads' =>
                'DNA reads that have been aligned against the genome',
              'genome_aligned_genomic_dna_tags' =>
                'DNA tags that have been aligned against the genome',
              'gff3_index' =>
                'An index of a gff3 file that has the read sequence as the key',
              'fasta_index' =>
                'An index of a fasta file that has the sequence as the key',
             },
             'tracking sequencing method' =>
             {
              'Illumina' => 'Illumina sequencing method',
             },
             'tracking multiplexing types' =>
             {
              'non-multiplexed' => 'One sample per sequencing run',
              'DCB multiplexed' => 'multiplexed sequencing run using DCB group barcodes',
             },
             'tracking project types' =>
             {
              'small RNA sequencing' => 'Small RNA sequencing',
              'DNA tag sequencing' => 'Sequencing of fragments of genomic DNA',
             },
             'tracking molecule types' =>
             {
              'DNA' => 'Deoxyribonucleic acid',
              'RNA' => 'Ribonucleic acid',
             },
             'tracking quality values' =>
             {
              'high' => 'high quality',
              'medium' => 'medium quality',
              'low' => 'low quality',
              'unknown' => 'unknown quality',
             },
             'tracking pipeprocess status' =>
             {
              'not_started' => 'Process has not been queued yet',
              'queued' => 'A job is queued to run this process',
              'started' => 'Processing has started',
              'finished' => 'Processing is done',
             },
             'tracking sample processing requirements' =>
             {
              'no processing' => 'Processing should not be performed for this sample',
              'needs processing' =>' Processing should be performed for this sample',
             },
             'tracking analysis types' =>
             {
              'non-multiplexed sequencing run' =>
                'This pseudo-analysis generates raw sequence files, ' .
                'with quality scores, with no multiplexing',
              'multiplexed sequencing run' =>
                'This pseudo-analysis generates raw sequence files, ' .
                'with quality scores, and uses multiplexing/barcodes',
              'remove adapters' => 'Read FastQ files, process each read to remove the adapter',
              'trim reads' => 'Read FastQ files, process each read and trim to a fixed length',
              'remove adapters and de-multiplex' =>
                'Read FastQ files, process each read to remove the adapter and split the result based on the barcode',
              'trim reads' =>
                'Read FastQ files, trim each read to a fixed length and then create a fasta file',
              'summarise fasta first base' =>
                'Read a fasta file of short sequences and summarise the first base composition',
              'calculate fasta or fastq file statistics' =>
                'Get sequence composition statistics from a FASTA or FASTQ file',
              'remove redundant reads' =>
                'Read a fasta file of short sequences, remove redundant reads '
                  . 'and add a count to the header',
              'ssaha alignment' =>
                'Align reads against a sequence database with SSAHA',
              'genome aligned reads filter' =>
                'Filter a fasta file, creating a file containing only genome aligned reads',
              'gff3 to gff2 converter' =>
                'Convert a GFF3 file into a GFF2 file',
              'gff3 index' =>
                'Create an index of GFF3 file',
              'fasta index' =>
                'Create an index of FASTA file',
             },
             'tracking coded sample types' =>
             {
              'initial run' => 'intial sequencing run',
              'technical replicate' => 'technical replicate/re-run',
              'biological replicate' => 'biological replicate/re-run',
              'failure re-run' => 're-run because of failure'
             },
             'tracking treatment types' => { 'no treatment' => 'no treatment' },
             'tracking fractionation types' => { 'no fractionation' => 'no fractionation' },

             'tracking users types' =>
             {
              'admin' => 'Admin user - full privileges',
              'local' => 'Local user - full access to all data but not full delete/edit privileges',
              'external' => 'External user - access only to selected data, no delete/edit privileges',
             },
             'tracking sample types' =>
             {
               small_rna_seq => 'Small RNA sequences',
               chip_seq => 'Chromatin immunoprecipitation (ChIP) and sequencing',
               mrna_expression => 'Expression analysis of mRNA',
               dna_seq => 'Genomic DNA sequence',
             }
            );

my %cvterm_objs = ();

$schema->txn_do(sub {
  for my $term_cv_name (sort keys %terms) {
    my $cv_rs = $schema->resultset('Cv');
    my $cv = $cv_rs->create({ name => $term_cv_name});

    my %cvterms = %{$terms{$term_cv_name}};

    for my $cvterm_name (sort keys %cvterms) {
      my $definition = $cvterms{$cvterm_name};

      my $rs = $schema->resultset('Cvterm');

      my $obj = $rs->create({name => $cvterm_name,
                             definition => $definition,
                             cv => $cv});

      $cvterm_objs{$cvterm_name} = $obj;
    }
  }
});

$schema->txn_commit();

my @orgs = ({ name => "DCB",
              description => 'David Baulcombe Lab, University of Cambridge, Dept. of Plant Sciences' },
            { name => 'CRUK CRI',
              description => 'Cancer Research UK, Cambridge Research Institute' },
            { name => 'Sainsbury',
              description => 'Sainsbury Laboratory' },
            { name => 'JIC',
              description => 'John Innes Centre' },
            { name => 'BGI',
              description => 'Beijing Genomics Institute' },
            { name => 'CSHL',
              description => 'Cold Spring Harbor Laboratory' },
           );

$schema->txn_do(sub {
                  for my $org (@orgs) {
                    $schema->create_with_type('Organisation', $org);
                  }
                });
my @organisms = ({ genus => "Arabidopsis", species => "thaliana",
                   abbreviation => "arath", common_name => "thale cress" },
                 { genus => "Chlamydomonas", species => "reinhardtii",
                   abbreviation => "chlre", common_name => "chlamy"},
                 { genus => "Cardamine", species => "hirsuta",
                   abbreviation => "", common_name => "Hairy bittercress" },
                 { genus => "Caenorhabditis", species => "elegans",
                   abbreviation => "caeel", common_name => "worm" },
                 { genus => "Dictyostelium", species => "discoideum",
                   abbreviation => "dicdi", common_name => "Slime mold" },
                 { genus => "Homo", species => "sapiens",
                   abbreviation => "human", common_name => "human" },
                 { genus => "Lycopersicon", species => "esculentum",
                   abbreviation => "", common_name => "tomato" },
                 { genus => "Zea", species => "mays",
                   abbreviation => "maize", common_name => "corn" },
                 { genus => "Oryza", species => "sativa",
                   abbreviation => "orysa", common_name => "rice" },
                 { genus => "Nicotiana", species => "benthamiana",
                   abbreviation => "nicbe", common_name => "tabaco" },
                 { genus => "Schizosaccharomyces", species => "pombe",
                   abbreviation => "schpo", common_name => "pombe" },
                 { genus => "Carmovirus", species => "turnip crinkle virus",
                   abbreviation => "tcv", common_name => "tcv" },
                 { genus => "Benyvirus", species => "rice stripe virus",
                   abbreviation => "rsv", common_name => "rsv" },
                 { genus => "Unknown", species => "unknown",
                   abbreviation => "none", common_name => "none" },
                );

my %organism_objects = ();

$schema->txn_do(sub {
                  for my $organism_desc (@organisms) {
                    my $organism_obj = $loader->add_organism($organism_desc);
                    my $key = $organism_obj->genus() . ' ' . $organism_obj->species();
                    $organism_objects{$key} = $organism_obj;
                  }
                });

my @ecotypes = (
    { description => "unspecified", org => "Arabidopsis thaliana" },
    { description => "Col", org => "Arabidopsis thaliana" },
    { description => "WS", org => "Arabidopsis thaliana" },
    { description => "Ler", org => "Arabidopsis thaliana" },
    { description => "C24", org => "Arabidopsis thaliana" },
    { description => "Cvi", org => "Arabidopsis thaliana" },
    { description => "unspecified", org => "Chlamydomonas reinhardtii" },
    { description => "unspecified", org => "Cardamine hirsuta" },
    { description => "unspecified", org => "Caenorhabditis elegans" },
    { description => "unspecified", org => "Dictyostelium discoideum" },
    { description => "unspecified", org => "Homo sapiens" },
    { description => "unspecified", org => "Lycopersicon esculentum" },
    { description => "unspecified", org => "Zea mays" },
    { description => "B73", org => "Zea mays" },
    { description => "Mo17", org => "Zea mays" },
    { description => "unspecified", org => "Nicotiana benthamiana" },
    { description => "unspecified", org => "Schizosaccharomyces pombe" },
    { description => "unspecified", org => "Oryza sativa" },
    { description => "indica", org => "Oryza sativa" },
    { description => "japonica", org => "Oryza sativa" },
    { description => "unspecified", org => "Carmovirus turnip crinkle virus" },
    { description => "unspecified", org => "Benyvirus rice stripe virus" },
    { description => "unspecified", org => "Unknown unknown" },
   );

my %ecotype_objs = ();

$schema->txn_do(sub {
                  for my $ecotype (@ecotypes) {
                    my $org_obj = $organism_objects{$ecotype->{org}};

                    if (!defined $org_obj) {
                      croak "can't find organism for ", $ecotype->{org}, "\n";
                    }

                    my $obj =
                      $schema->create_with_type('Ecotype',
                                                {
                                                  description => $ecotype->{description},
                                                  organism => $org_obj,
                                                });
                    my $ecotype_desc =
                      $ecotype->{description} . ' ' . $ecotype->{org};
                    $ecotype_objs{$ecotype_desc} = $obj;
                  }
                });

my @tissues = (
    { description => "unspecified", org => "Arabidopsis thaliana" },
    { description => "unopened flowers (stage 0-12)", org => "Arabidopsis thaliana" },
    { description => "open flowers (stage 13)", org => "Arabidopsis thaliana" },
    { description => "young siliques (<7 dpf)", org => "Arabidopsis thaliana" },
    { description => "mature siliques (>7 dpf)", org => "Arabidopsis thaliana" },
    { description => "young leaves (<14 days)", org => "Arabidopsis thaliana" },
    { description => "mature leaves (>14 days)", org => "Arabidopsis thaliana" },
    { description => "vegetative meristem", org => "Arabidopsis thaliana" },
    { description => "floral meristem", org => "Arabidopsis thaliana" },
    { description => "roots (including meristem)", org => "Arabidopsis thaliana" },
    { description => "seedlings (roots, cotyledons, leaves, and meristem)", org => "Arabidopsis thaliana" },
    { description => "cauline leaves", org => "Arabidopsis thaliana" },
    { description => "stem", org => "Arabidopsis thaliana" },

    { description => "unspecified", org => "Chlamydomonas reinhardtii" },
    { description => "vegetative cells", org => "Chlamydomonas reinhardtii" },
    { description => "gametes", org => "Chlamydomonas reinhardtii" },

    { description => "unspecified", org => "Cardamine hirsuta" },
    { description => "unspecified", org => "Caenorhabditis elegans" },
    { description => "unspecified", org => "Dictyostelium discoideum" },
    { description => "unspecified", org => "Homo sapiens" },
    { description => "unspecified", org => "Lycopersicon esculentum" },
    { description => "unspecified", org => "Zea mays" },
    { description => "unspecified", org => "Nicotiana benthamiana" },
    { description => "unspecified", org => "Schizosaccharomyces pombe" },
    { description => "unspecified", org => "Oryza sativa" },
    { description => "unspecified", org => "Carmovirus turnip crinkle virus" },
    { description => "unspecified", org => "Benyvirus rice stripe virus" },
    { description => "unspecified", org => "Unknown unknown" },
   );

my %tissue_objs = ();

$schema->txn_do(sub {
                  for my $tissue (@tissues) {
                    my $org_obj = $organism_objects{$tissue->{org}};

                    if (!defined $org_obj) {
                      croak "can't find organism for ", $tissue->{org}, "\n";
                    }

                    my $obj =
                      $schema->create_with_type('Tissue',
                                                {
                                                  description => $tissue->{description},
                                                  organism => $org_obj,
                                                });
                    my $tissue_desc =
                      $tissue->{description} . ' ' . $tissue->{org};
                    $tissue_objs{$tissue_desc} = $obj;
                  }
                });

my @people = (
              ['Andy Bassett', 'andy_bassett', 'DCB'],
              ['David Baulcombe', 'david_baulcombe', 'DCB'],
              ['Amy Beeken', 'amy_beeken', 'DCB'],
              ['Paola Fedita', 'paola_fedita', 'DCB'],
              ['Susi Heimstaedt', 'susi_heimstaedt', 'DCB'],
              ['Jagger Harvey', 'jagger_harvey', 'DCB'],
              ['Ericka Havecker', 'ericka_havecker', 'DCB'],
              ['Ian Henderson', 'ian_henderson', 'DCB'],
              ['Charles Melnyk', 'charles_melnyk', 'DCB'],
              ['Attila Molnar', 'attila_molnar', 'DCB'],
              ['Becky Mosher', 'becky_mosher', 'DCB'],
              ['Kanu Patel', 'kanu_patel', 'DCB'],
              ['Anna Peters', 'anna_peters', 'DCB'],
              ['Kim Rutherford', 'kim_rutherford', 'DCB', 'admin'],
              ['Iain Searle', 'iain_searle', 'DCB'],
              ['Padubidri Shivaprasad', 'padubidri_shivaprasad', 'DCB'],
              ['Shuoya Tang', 'shuoya_tang', 'DCB'],
              ['Laura Taylor', 'laura_taylor', 'DCB'],
              ['Craig Thompson', 'craig_thompson', 'DCB'],
              ['Natasha Elina', 'natasha_elina', 'DCB'],
              ['Krys Kelly', 'krys_kelly', 'DCB'],
              ['Hannes V', 'hannes_v', 'DCB'],
             );

$schema->txn_do(sub {
  my $role_cvterm_rs = $schema->resultset('Cvterm');
  my $admin_role_cvterm = $role_cvterm_rs->find({ name => 'admin' });
  my $local_role_cvterm = $role_cvterm_rs->find({ name => 'local' });

  for my $person (@people) {
    my ($person_name, $username, $organisation_name, $admin) = @$person;

    my $rs = $schema->resultset('Organisation');
    my $organisation = $rs->find({
                                  name => $organisation_name
                                 });

    my $role_cvterm;

    if (defined $admin) {
      $role_cvterm = $admin_role_cvterm;
    } else {
      $role_cvterm = $local_role_cvterm;
    }

    if ($person_name =~ /(.*) (.*)/) {
      $loader->add_person(first_name => $1, last_name => $2,
                          username => $username,
                          password => $username,
                          organisation => $organisation,
                          role => $role_cvterm);
    } else {
      die "no space in name: $person_name\n";
    }
  }
});

my @analyses = (
                {
                 type_term_name => 'non-multiplexed sequencing run',
                 detail => 'Sainsbury',
                 inputs => []
                },
                {
                 type_term_name => 'non-multiplexed sequencing run',
                 detail => 'CRI',
                 inputs => []
                },
                {
                 type_term_name => 'multiplexed sequencing run',
                 detail => 'CRI',
                 inputs => []
                },
                {
                 type_term_name => 'non-multiplexed sequencing run',
                 detail => 'BGI',
                 inputs => []
                },
                {
                 type_term_name => 'non-multiplexed sequencing run',
                 detail => 'CSHL',
                 inputs => []
                },
                {
                 type_term_name => 'trim reads',
                 detail => 'processing_type: trim',
                 runable_name => 'SmallRNA::Runable::FastqToFastaRunable',
                 inputs => [
                     {
                       format_type => 'fastq',
                       content_type => 'raw_genomic_dna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'remove adapters',
                 detail => 'processing_type: remove_adapters',
                 runable_name => 'SmallRNA::Runable::FastqToFastaRunable',
                 inputs => [
                     {
                       format_type => 'fastq',
                       content_type => 'raw_srna_reads',
                     }
                    ]
                },
                {
                  type_term_name => 'remove adapters and de-multiplex',
                  detail => 'processing_type: remove_adapters',
                  runable_name => 'SmallRNA::Runable::FastqToFastaRunable',
                  inputs => [
                      {
                        format_type => 'fastq',
                        content_type => 'multiplexed_srna_reads',
                      }
                     ]
                },
                {
                 type_term_name => 'calculate fasta or fastq file statistics',
                 runable_name => 'SmallRNA::Runable::FastStatsRunable',
                 inputs => [
                     {
                       format_type => 'fastq',
                       content_type => 'raw_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'calculate fasta or fastq file statistics',
                 runable_name => 'SmallRNA::Runable::FastStatsRunable',
                 inputs => [
                     {
                       format_type => 'fastq',
                       content_type => 'raw_genomic_dna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'calculate fasta or fastq file statistics',
                 runable_name => 'SmallRNA::Runable::FastStatsRunable',
                 inputs => [
                     {
                       format_type => 'fasta',
                       content_type => 'srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'calculate fasta or fastq file statistics',
                 runable_name => 'SmallRNA::Runable::FastStatsRunable',
                 inputs => [
                     {
                       format_type => 'fasta',
                       content_type => 'non_redundant_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'calculate fasta or fastq file statistics',
                 runable_name => 'SmallRNA::Runable::FastStatsRunable',
                 inputs => [
                     {
                       format_type => 'fasta',
                       content_type => 'genome_aligned_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'summarise fasta first base',
                 runable_name => 'SmallRNA::Runable::FirstBaseCompSummaryRunable',
                 inputs => [
                     {
                       format_type => 'fasta',
                       content_type => 'srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'summarise fasta first base',
                 runable_name => 'SmallRNA::Runable::FirstBaseCompSummaryRunable',
                 inputs => [
                     {
                       format_type => 'fasta',
                       content_type => 'non_redundant_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'summarise fasta first base',
                 runable_name => 'SmallRNA::Runable::FirstBaseCompSummaryRunable',
                 inputs => [
                     {
                       format_type => 'fasta',
                       content_type => 'raw_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'summarise fasta first base',
                 runable_name => 'SmallRNA::Runable::FirstBaseCompSummaryRunable',
                 inputs => [
                     {
                       format_type => 'fasta',
                       content_type => 'multiplexed_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'remove redundant reads',
                 runable_name => 'SmallRNA::Runable::NonRedundantFastaRunable',
                 inputs => [
                     {
                       format_type => 'fasta',
                       content_type => 'genomic_dna_tags',
                     }
                    ]
                },
                {
                 type_term_name => 'remove redundant reads',
                 runable_name => 'SmallRNA::Runable::NonRedundantFastaRunable',
                 inputs => [
                     {
                       format_type => 'fasta',
                       content_type => 'genomic_dna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'remove redundant reads',
                 runable_name => 'SmallRNA::Runable::NonRedundantFastaRunable',
                 inputs => [
                     {
                       format_type => 'fasta',
                       content_type => 'srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'gff3 index',
                 runable_name => 'SmallRNA::Runable::CreateIndexRunable',
                 inputs => [
                     {
                       format_type => 'gff3',
                       content_type => 'genome_aligned_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'fasta index',
                 runable_name => 'SmallRNA::Runable::CreateIndexRunable',
                 inputs => [
                     {
                       format_type => 'fasta',
                       content_type => 'non_redundant_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'ssaha alignment',
                 detail => 'component: genome',
                 runable_name => 'SmallRNA::Runable::SSAHASearchRunable',
                 inputs => [
                     {
                       ecotype_name => 'unspecified Arabidopsis thaliana',
                       format_type => 'fasta',
                       content_type => 'non_redundant_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'ssaha alignment',
                 detail => 'component: genome',
                 runable_name => 'SmallRNA::Runable::SSAHASearchRunable',
                 inputs => [
                     {
                       ecotype_name => 'unspecified Lycopersicon esculentum',
                       format_type => 'fasta',
                       content_type => 'non_redundant_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'ssaha alignment',
                 detail => 'component: genome',
                 runable_name => 'SmallRNA::Runable::SSAHASearchRunable',
                 inputs => [
                     {
                       ecotype_name => 'unspecified Carmovirus turnip crinkle virus',
                       format_type => 'fasta',
                       content_type => 'non_redundant_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'ssaha alignment',
                 detail => 'component: genome',
                 runable_name => 'SmallRNA::Runable::SSAHASearchRunable',
                 inputs => [
                     {
                       ecotype_name => 'unspecified Oryza sativa',
                       format_type => 'fasta',
                       content_type => 'non_redundant_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'ssaha alignment',
                 detail => 'component: genome',
                 runable_name => 'SmallRNA::Runable::SSAHASearchRunable',
                 inputs => [
                     {
                       ecotype_name => 'unspecified Benyvirus rice stripe virus',
                       format_type => 'fasta',
                       content_type => 'non_redundant_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'ssaha alignment',
                 detail => 'component: genome',
                 runable_name => 'SmallRNA::Runable::SSAHASearchRunable',
                 inputs => [
                     {
                       ecotype_name => 'unspecified Chlamydomonas reinhardtii',
                       format_type => 'fasta',
                       content_type => 'non_redundant_srna_reads',
                     }
                    ]
                },
                {
                 type_term_name => 'ssaha alignment',
                 detail => 'component: genome',
                 runable_name => 'SmallRNA::Runable::SSAHASearchRunable',
                 inputs => [
                     {
                       ecotype_name => 'unspecified Chlamydomonas reinhardtii',
                       format_type => 'fasta',
                       content_type => 'non_redundant_genomic_dna_tags',
                     }
                    ]
                },
                {
                 type_term_name => 'genome aligned reads filter',
                 runable_name => 'SmallRNA::Runable::GenomeMatchingReadsRunable',
                 inputs => [
                     {
                       format_type => 'gff3',
                       content_type => 'genome_aligned_srna_reads'
                     }
                   ]
                },
                {
                 type_term_name => 'gff3 to gff2 converter',
                 runable_name => 'SmallRNA::Runable::GFF3ToGFF2Runable',
                 inputs => [
                     {
                       format_type => 'gff3',
                     }
                   ]
                },
                # {
                #  type_term_name => 'ssaha alignment',
                #  detail => 'versus: Arabidopsis tRNA+rRNA',
                #  runable_name => 'SmallRNA::Runable::SSAHASearchRunable',
                #  inputs => [
                #      {
                #        format_type => 'fasta',
                #        content_type => 'srna_reads',
                #      }
                #     ]
                # }
               );

$schema->txn_do(sub {
  for my $analysis (@analyses) {
    my %conf = %$analysis;

    my $type_cvterm_rs = $schema->resultset('Cvterm');
    my $type_cvterm = $type_cvterm_rs->find({ name => $conf{type_term_name} });

    if (!defined $type_cvterm) {
      die "can't find cvterm for $conf{type_term_name}\n";
    }

    my $process_conf = $schema->create_with_type('ProcessConf', {
      type => $type_cvterm,
      detail => $conf{detail},
      runable_name => $conf{runable_name},
    });

    for my $input (@{$conf{inputs}}) {
      my %args = (
        process_conf => $process_conf
      );

      if (defined $input->{content_type}) {
        $args{content_type} = $cvterm_objs{$input->{content_type}};
      }

      if (defined $input->{format_type}) {
        $args{format_type} = $cvterm_objs{$input->{format_type}};
      }

      if (defined $input->{ecotype_name}) {
        $args{ecotype} = $ecotype_objs{$input->{ecotype_name}};
      }
      $schema->create_with_type('ProcessConfInput', { %args });
    }
  }
});

my @protocols = (
              ['unknown', ''],
             );

$schema->txn_do(sub {
  for my $protocol (@protocols) {
    my ($name, $description) = @$protocol;
    $schema->create_with_type('Protocol',
                                {
                                  name => $name,
                                  description => $description,
                                });

  }
});
