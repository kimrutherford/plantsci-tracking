#!/usr/bin/perl
   eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
       if $running_under_some_shell;

use strict;
use warnings;
use Carp;
use v5.10;

use Getopt::Long;
use Pod::Usage;
use YAML qw(LoadFile);

my $CONF_FILE = 'smallrna_web.yaml';
my $TEMPLATE_FILE = $CONF_FILE . '.template';

=head1 NAME

pipeinit.pl - deploy a pipeline database

=head1 SYNOPSIS

This script creates a suitable configuration file and PostgreSQL database for
running an analysis pipeline.

=head1 DESCRIPTION

See http://pipeline.plantsci.cam.ac.uk/trac for pipeline documentation.

=head1 Options

=over 3

=item B<-H>, B<--database-host>

Database host

=item B<-D>, B<--database-name>

Database name

=item B<-U>, B<--database-user-name>

Database user name

=item B<-P>, B<--database-password>

Database password

=item B<-d>, B<--pipeline-directory>

Directory used by the pipeline code

=item B<-p>, B<--pipeline-process-directory>

Sub-driectory of pipeline-directory where the results of processing will be
stored

=item B<-f>, B<--args-from>

Reads the values for the arguments above from the given file

=item B<-?>, B<--help>

show a usage message

=back

=head1 BUGS

None known

=head1 AUTHOR

Kim Rutherford <kmr44@cam.ac.uk>

=cut

my $option_parser = new Getopt::Long::Parser;
$option_parser->configure("gnu_getopt");

my $need_help = 0;
my $args_file = undef;

my %options = ();

my %opt_config = (
                  "args-from|f=s" => \$args_file,
                  "database-user-name|U=s" => undef,
                  "database-password|P=s" => undef,
                  "database-name|D=s" => undef,
                  "database-host|H=s" => undef,
                  "pipeline-directory|d=s" => undef,
                  "pipeline-process-directory|p=s" => undef,
                  "help|?" => \$need_help,
                 );

for my $opt_str (keys %opt_config) {
  (my $opt_key = $opt_str) =~ s/\|.*//;
  if (!defined $opt_config{$opt_str}) {
    $options{$opt_key} = undef;
    $opt_config{$opt_str} = \$options{$opt_key};
  }
}

if (!$option_parser->getoptions(%opt_config)) {
  usage(1);
}

if ($need_help) {
  usage(0);
}

sub usage
{
  my $exit_val = shift;
  my $message = shift;
  if (defined $message) {
    pod2usage(-verbose => 1, -exitval => $exit_val, -message => $message);
  } else {
    pod2usage(-verbose => 3, -exitval => $exit_val);
  }
}

if (defined $args_file) {
  my $yaml_args = LoadFile($args_file);

  for my $key (keys %$yaml_args) {
    if (!defined $options{$key}) {
      $options{$key} = $yaml_args->{$key}
    }
  }
}

my $errors = '';
for my $key (keys %options) {
  if (!defined $options{$key}) {
    $errors .= "Parameter '--$key' not set\n";
  }
}

if ($errors) {
  usage(1, $errors);
}

open TEMPLATE_FILE, '<', $TEMPLATE_FILE
  or croak "can't open '$TEMPLATE_FILE' for reading: $!\n";

open CONF_FILE, '>', $CONF_FILE
  or croak "can't open '$CONF_FILE' for writing: $!\n";

while (defined (my $line = <TEMPLATE_FILE>)) {
  for my $key (keys %options) {
    $line =~ s/\$\{$key\}/$options{$key}/;
  }

  print CONF_FILE $line;
}

close CONF_FILE or croak "can't close $CONF_FILE: $!\n";
close TEMPLATE_FILE or croak "can't close $TEMPLATE_FILE: $!\n";
