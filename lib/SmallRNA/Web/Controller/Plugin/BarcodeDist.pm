package SmallRNA::Web::Controller::Plugin::BarcodeDist;

=head1 NAME

SmallRNA::Web::Controller::Plugin::BarcodeDist - Show a chart of the
   distribution of barcodes in a sequencing run

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Web::Controller::Plugin::BarcodeDist

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
use Chart::Clicker::Renderer::Pie;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;

=head2 barcode_dist

 Usage   : Called as a Catalyst action
 Function: Given the id of a sequencingrun, create a pie chart of the
           distribution of barcodes in a sequencing run, store it in
           the stash then forward to SmallRNA::Web::View::Graph
 Args    : object_id - the id of the sequencingrun containin

=cut
sub sizedist : Path('/plugin/graph/barcode_dist') {
  my ($self, $c, $object_id) = @_;

  my $schema = $c->schema();
  my $sequencingrun = $schema->find_with_type('Sequencingrun', 'sequencingrun_id', $object_id);

  my $cc = Chart::Clicker->new(width => 400, height => 300);

  my $fastq_pipedata = $sequencingrun->initial_pipedata();

  my $seq_count_prop_type = $schema->find_with_type('Cvterm',
                                                 { name => 'sequence count' });
  my $barcode_prop_type = $schema->find_with_type('Cvterm',
                                                 { name => 'multiplexing code' });

  my $fq_seq_count =
    $fastq_pipedata->search_related('pipedata_properties',
                                      { type => $seq_count_prop_type->cvterm_id() })
      ->next()->value();

  my @demultiplex_pipedatas =
    $fastq_pipedata->pipeprocess_in_pipedatas()->search_related('pipeprocess')
      ->search_related('pipedatas');

  my %pipedata_info = ();

  for my $pipedata (@demultiplex_pipedatas) {
    my $barcode_prop = $pipedata->search_related('pipedata_properties',
                                                   {
                                                     type => $barcode_prop_type->cvterm_id()
                                                    })->next();

    if (defined $barcode_prop) {
      my $seq_count = $pipedata->search_related('pipedata_properties',
                                                  {
                                                    type => $seq_count_prop_type->cvterm_id()
                                                   })->next()->value();

      $pipedata_info{$barcode_prop->value()} = $seq_count;
    } else {
      #
    }
  }

  my @series_list = ();

  for my $code (keys %pipedata_info) {
    my $series = Chart::Clicker::Data::Series->new(
      keys => [1],  # dummy
      values => [$pipedata_info{$code}],
      name => "Code: $code"
     );

    push @series_list, $series;
  }

  my $ds = Chart::Clicker::Data::DataSet->new(series => [ @series_list ]);

  $cc->add_to_datasets($ds);

  my $def = $cc->get_context('default');

  my $pie = Chart::Clicker::Renderer::Pie->new(opacity => .6);
  $def->renderer($pie);

  my $range_axis = $def->range_axis;
  $range_axis->hidden(1);
  $range_axis->tick_values([0]);
  my $domain_axis = $def->domain_axis;
  $domain_axis->hidden(1);

  $c->stash->{graphics_primitive_driver_args} = { format => 'png' };
  $c->stash->{graphics_primitive_content_type} = 'image/png';
  $c->stash->{graphics_primitive} = $cc;
  $c->stash->{graphics_primitive_driver} = 'Cairo';

  $c->forward('SmallRNA::Web::View::Graph');
}

1;
