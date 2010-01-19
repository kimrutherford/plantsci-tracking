package SmallRNA::Web::Controller::Plugin::CumulativeReadsByMonth;

=head1 NAME

SmallRNA::Web::Controller::Plugin::CumulativeReadsByMonth
  - draw a graph of cumulative number of reads over time (by month)

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

# return the total number of sequence reads for which we do not have a data_received_date
sub _unknown_date_total
{
  my $dbh = shift;

  my $query = <<'END';
SELECT SUM(value::INTEGER) FROM sequencing_run, pipedata, pipedata_property, cvterm
 WHERE initial_pipedata = pipedata.pipedata_id
   AND pipedata.pipedata_id = pipedata_property.pipedata
   AND pipedata_property.type = cvterm.cvterm_id
   AND cvterm.name = 'sequence count'
   AND data_received_date IS NULL
END

  my $sth = $dbh->prepare($query) || croak $dbh->errstr;
  $sth->execute() || croak $sth->errstr;

  my $cc = Chart::Clicker->new(width => 800, height => 350);

  my $max_count = 0;

  my %results = ();

  my $r = $sth->fetchrow_hashref();

  return $r->{sum};
}


=head2 cumulative_reads_by_month

 Usage   : Called as a Catalyst action
 Function: Create a graph of the cumulative number of reads by month, store it
           in the stash then forward to SmallRNA::Web::View::Graph
 Args    : none

=cut
sub cumulative_reads_by_month : Path('/plugin/graph/cumulative_reads_by_month') {
  my ($self, $c) = @_;

  my $schema = $c->schema();
  my $dbh = $schema->storage()->dbh();

  my $query = <<'END';
SELECT SUM(value::INTEGER) AS count,
       EXTRACT(YEAR FROM data_received_date) || '_' || EXTRACT(MONTH FROM data_received_date) AS month
  FROM sequencing_run, pipedata, pipedata_property, cvterm
 WHERE initial_pipedata = pipedata.pipedata_id
   AND pipedata.pipedata_id = pipedata_property.pipedata
   AND pipedata_property.type = cvterm.cvterm_id
   AND cvterm.name = 'sequence count'
   AND data_received_date IS NOT NULL
   AND submission_date IS NOT NULL
   GROUP BY month ORDER BY month;
END

  my $sth = $dbh->prepare($query) || croak $dbh->errstr;
  $sth->execute() || croak $sth->errstr;

  my $cc = Chart::Clicker->new(width => 800, height => 500);

  my $max_count = 0;

  my %results = ();

  while (my $r = $sth->fetchrow_hashref()) {
    my $month = $r->{month};
    my $count = $r->{count};

    if ($count > $max_count) {
      $max_count = $count;
    }

    $month =~ s|(.*)_(.*)|$1 + ($2 - 1) / 12|e;

    $results{$month} = $count;
  }

  my $scale_factor = 1_000_000_000.0;

  my $max_month = -1;
  my $min_month = 99999;

  my @months = ();
  my @counts = ();

  my $total = _unknown_date_total($dbh);

  for my $month (sort { $a <=> $b } keys %results) {
    if ($month > $max_month) {
      $max_month = $month;
    }

    $total += $results{$month};

    if ($month > 2008 + 1/12.0) {
      push @months, $month;
      push @counts, $total / $scale_factor;

      if ($month < $min_month) {
        $min_month = $month;
      }
    }
  }

  my @domain_tick_values = @months;

  # add empty columns for aesthetic reasons
  push @months, $max_month + 1.0 / 12;
  push @counts, 0;
  unshift @months, $min_month - 1.0 / 12;
  unshift @counts, 0;

  my $series = Chart::Clicker::Data::Series->new(
    keys => \@months,
    values => [@counts],
    name => "Samples"
  );

  my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series ]);

  $cc->add_to_datasets($ds);

  my $def = $cc->get_context('default');

  my $area = Chart::Clicker::Renderer::StackedBar->new(opacity => .6);
  $area->brush->width(10);
  $def->renderer($area);
  $def->range_axis->format('%2.1f');
  my $tick_spacing = .2;
  my @range_ticks = map {
    $_ * $tick_spacing
  } (1..int(1.0 * $total / $scale_factor / $tick_spacing) + 2);

  $def->range_axis->tick_values(\@range_ticks);
  $def->domain_axis->tick_values([@domain_tick_values]);
  $def->domain_axis->format(sub {
                             my $val = shift;
                             my $year = int($val);
                             my $month = int(($val - int($val)) * 12.0 + 1.5);
                             return sprintf "%s-%d", $month, $year;
                           });
  $def->domain_axis->fudge_amount(0.0);
  $def->domain_axis->tick_label_angle(1.1007963267949);

  $c->stash->{graphics_primitive_driver_args} = { format => 'png' };
  $c->stash->{graphics_primitive_content_type} = 'image/png';
  $c->stash->{graphics_primitive} = $cc;
  $c->stash->{graphics_primitive_driver} = 'Cairo';

  $c->forward('SmallRNA::Web::View::Graph');
}

1;
