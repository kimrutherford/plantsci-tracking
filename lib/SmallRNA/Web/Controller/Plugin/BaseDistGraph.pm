package SmallRNA::Web::Controller::Plugin::BaseDistGraph;

=head1 NAME

SmallRNA::Web::Controller::Plugin::BaseDistGraph - Show a graph of base 
   distribution within reads

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Web::Controller::Plugin::BaseDistGraph

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

use YAML qw(LoadFile);

sub _get_base_counts
{
  my $c = shift;
  my $pipedata = shift;

  my $data_directory = $c->config()->data_directory();
  my $file_name = $data_directory . '/' . $pipedata->file_name();

  my $yaml = LoadFile($file_name);
  my $positional_counts = $yaml->{positional_counts};
  my $max = 0;

  for my $base (qw(A T C G N)) {
    if (!defined $positional_counts->{$base}) {
      $positional_counts->{$base} = [];
    }
    my $list_length = scalar(@{$positional_counts->{$base}});
    if ($list_length > $max) {
      $max = $list_length;
    }
  }

  for my $base (qw(A T C G N)) {
    my $list_length = scalar(@{$positional_counts->{$base}});

    if ($list_length < $max) {
      for (my $i = 0; $i < $max; $i++) {
        if (!defined $positional_counts->{$base}->[$i]) {
          $positional_counts->{$base}->[$i] = 0;
        }
      }
    }
  }

  return $positional_counts, $max;
}

=head2 sizedist

 Usage   : Called as a Catalyst action
 Function: Given a pipedata_id of a fast_stats pipedata, create a base
           distribution graph, store it in the stash then forward to
           SmallRNA::Web::View::Graph
 Args    : pipedata_id - the id of the pipedata containing the stats in
                         fasta_stats or fastq_stats format

=cut
sub sizedist : Path('/plugin/graph/basedist') {
  my ($self, $c, $pipedata_id) = @_;

  my $schema = $c->schema();
  my $pipedata = $schema->find_with_type('Pipedata', 'pipedata_id', $pipedata_id);
  my ($positional_counts_ref, $max_read_length) = _get_base_counts($c, $pipedata);
  my $cc = Chart::Clicker->new(width => 800, height => 480);

  my @series_list = ();

  my @base_positions = (1 .. $max_read_length);

  for my $base (qw(A T C G N)) {
    my $set = $positional_counts_ref->{$base};

    use Data::Dumper;

    warn Dumper([\@base_positions, $set]);

    my $series = Chart::Clicker::Data::Series->new(
      keys => [@base_positions],
      values => $set,
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
  $def->domain_axis->tick_values([@base_positions]);
  $def->domain_axis->format('%d');
  $def->domain_axis->fudge_amount(0.05);

  $c->stash->{graphics_primitive_driver_args} = { format => 'png' };
  $c->stash->{graphics_primitive_content_type} = 'image/png';
  $c->stash->{graphics_primitive} = $cc;
  $c->stash->{graphics_primitive_driver} = 'Cairo';

  $c->forward('SmallRNA::Web::View::Graph');
}

1;
