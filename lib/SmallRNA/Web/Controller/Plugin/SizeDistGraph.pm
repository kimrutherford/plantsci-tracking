package SmallRNA::Web::Controller::Plugin::SizeDistGraph;

=head1 NAME

SmallRNA::Web::Controller::Plugin::SizeDistGraph - Show a graph of read sizes

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Web::Controller::Plugin::SizeDistGraph

=over 4

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009 Kim Rutherford, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 FUNCTIONS

=cut

use strict;
use warnings;
use Carp;

use base 'Catalyst::Controller';

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Renderer::StackedBar;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;

sub _minmax
{
  my @lengths = @_;

  my $min = 999999999999;
  my $max = -999999999999;

  for my $val (@lengths) {
    if ($val < $min) {
      $min = $val;
    }
    if ($val > $max) {
      $max = $val;
    }
  }

  return ($min, $max);
}

=head2 get_pipedata_counts

 Usage   : my ($counts_ref, $min, $max) = get_pipedata_counts($c, $pipedata);
 Function: Count the read counts and first base composition from a file in
           first_base_summary format
 Args    : $c - the Catalyst context
           $pipedata - a Pipedata for a first_base_summary file
 Returns : $counts_ref - a hash from read length to a hash of base to base
                         count.  eg. $counts_ref->{21}{A} will be the number
                         of 21 base reads that start with base "A"

=cut
sub get_pipedata_counts
{
  my $config = shift;
  my $pipedata = shift;

  my $data_directory = $config->data_directory();
  my $file_name = $data_directory . '/' . $pipedata->file_name();

  my %res = ();

  open my $file, '<', $file_name
    or die "can't open $file_name: $!\n";

  my @column_names = ();

  # read header section
  while (defined (my $line = <$file>)) {
    if ($line =~ /^\s+([ATGC])\s+([ATGC])\s+([ATGC])\s+([ATGC])/) {
      @column_names = map { uc $_ } ($1, $2, $3, $4);
      last;
    }
  }

  while (defined (my $line = <$file>)) {
    if ($line =~ /^all/) {
      last;
    } else {
      if ($line =~ /^\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/) {
        my $length = $1;
        my @counts = ($2, $3, $4, $5);
        for (my $i = 0; $i < 4; $i++) {
          $res{$length}{$column_names[$i]} = $counts[$i];
        }
      }
    }
  }

  close $file or die "can't close $file: $!\n";

  my @lengths = keys %res;

  my ($min, $max) = _minmax(@lengths);
  if ($min > 15) {
    $min = 15;
  }
  if ($max < 36) {
    $max = 36;
  }

  return \%res, $min, $max;
}

=head2 sizedist

 Usage   : Called as a Catalyst action
 Function: Given a pipedata_id of a first_base_summary pipedata, create a size
           distribution graph, store it in the stash then forward to
           SmallRNA::Web::View::Graph
 Args    : pipedata_id - the id of the pipedata containing the stats in
                         first_base_summary format

=cut
sub sizedist : Path('/plugin/graph/sizedist') {
  my ($self, $c, $pipedata_id) = @_;

  my $schema = $c->schema();
  my $pipedata = $schema->find_with_type('Pipedata', 'pipedata_id', $pipedata_id);
  my ($counts_ref, $min, $max) = get_pipedata_counts($c->config(), $pipedata);
  my $cc = Chart::Clicker->new(width => 800, height => 480);

  my %counts = %$counts_ref;

  my @lengths = ($min .. $max);

  my @series_list = ();

  for my $base (qw(A T C G)) {
    my @set = map { $counts{$_}{$base} || 0 } @lengths;

    my $series = Chart::Clicker::Data::Series->new(
      keys => \@lengths,
      values => \@set,
      name => "Base $base"
     );

    push @series_list, $series;
  }


  my $ds = Chart::Clicker::Data::DataSet->new(series => [ @series_list ]);

  $cc->add_to_datasets($ds);

  my $def = $cc->get_context('default');

  my $area = Chart::Clicker::Renderer::StackedBar->new(opacity => .6);
  $area->brush->width(10);
  $def->renderer($area);
  $def->range_axis->format('%d');
  $def->domain_axis->tick_values([@lengths]);
  $def->domain_axis->format('%d');
  $def->domain_axis->fudge_amount(0.05);

  $c->stash->{graphics_primitive_driver_args} = { format => 'png' };
  $c->stash->{graphics_primitive_content_type} = 'image/png';
  $c->stash->{graphics_primitive} = $cc;
  $c->stash->{graphics_primitive_driver} = 'Cairo';

  $c->forward('SmallRNA::Web::View::Graph');
}

1;
