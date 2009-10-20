package SmallRNA::Web::Controller::Plugin::SampleSubmissionGraph;

=head1 NAME

SmallRNA::Web::Controller::Plugin::SampleSubmissionGraph
  - draw a graph of the number of submissions per quarter

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

=head2 sample_submission_graph

 Usage   : Called as a Catalyst action
 Function: Create a graph of the number of submissions per quarter, store it
           in the stash then forward to SmallRNA::Web::View::Graph
 Args    : none

=cut
sub sample_submission_graph : Path('/plugin/graph/sample_submissions') {
  my ($self, $c) = @_;

  my $schema = $c->schema();
  my $dbh = $schema->storage()->dbh();
  my $query = <<'END';
SELECT COUNT(identifier),
       EXTRACT(YEAR FROM data_received_date) || '_' || EXTRACT(QUARTER FROM data_received_date) AS quarter
  FROM sequencingrun WHERE data_received_date IS NOT NULL
       AND submission_date IS NOT NULL
  GROUP BY quarter
  ORDER BY QUARTER
END

  my $sth = $dbh->prepare($query) || croak $dbh->errstr;
  $sth->execute() || croak $sth->errstr;

  my $cc = Chart::Clicker->new(width => 600, height => 350);

  my @quarters = ();
  my @counts = ();

  my $max_count = 0;

  while (my $r = $sth->fetchrow_hashref()) {
    my $quarter = $r->{quarter};
    my $count = $r->{count};

    if ($count > $max_count) {
      $max_count = $count;
    }

    $quarter =~ s|(.*)_(.*)|$1 + ($2 - 1) / 4|e;

    push @quarters, $quarter;
    push @counts, $count;
  }

  my $series = Chart::Clicker::Data::Series->new(
    keys => \@quarters,
    values => [@counts],
    name => "Samples"
  );

  my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series ]);

  $cc->add_to_datasets($ds);

  my $def = $cc->get_context('default');

  my $area = Chart::Clicker::Renderer::StackedBar->new(opacity => .6);
  $area->brush->width(10);
  $def->renderer($area);
  $def->range_axis->format('%d');
  my @range_ticks = map { $_ * 10 } (1..int($max_count / 10) + 2);
  $def->range_axis->tick_values(\@range_ticks);
  $def->domain_axis->tick_values(\@quarters);
  $def->domain_axis->format(sub {
                             my $val = shift;
                             my $year = int($val);
                             my $quarter = int(($val - int($val)) * 4.0 + 1.5);
                             return "$year qt$quarter";
                           });
  $def->domain_axis->fudge_amount(0.05);

  $c->stash->{graphics_primitive_driver_args} = { format => 'png' };
  $c->stash->{graphics_primitive_content_type} = 'image/png';
  $c->stash->{graphics_primitive} = $cc;
  $c->stash->{graphics_primitive_driver} = 'Cairo';

  $c->forward('SmallRNA::Web::View::Graph');
}

1;
