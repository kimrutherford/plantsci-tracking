package SmallRNA::Web::Controller::Plugin::SizeDist;

=head1 NAME

SmallRNA::Web::Controller::Plugin::SizeDist - Action to get raw size
                                              distribution values

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Web::Controller::Plugin::SizeDist

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

use SmallRNA::Web::Controller::Plugin::SizeDistGraph;

=head2 sizedist

 Usage   : Called as a Catalyst action
 Function: Given a pipedata_id of a first_base_summary pipedata, return a size
           distribution as a TSV file
 Args    : pipedata_id - the id of the pipedata containing the stats in
                         first_base_summary format

=cut
sub sizedist : Path('/plugin/sizedist/tsv') {
  my ($self, $c, $pipedata_id) = @_;

  my $schema = $c->schema();
  my $pipedata = $schema->find_with_type('Pipedata', 'pipedata_id', $pipedata_id);
  my ($counts_ref, $min, $max) =
    SmallRNA::Web::Controller::Plugin::SizeDistGraph::get_pipedata_counts($c, $pipedata);

  my %counts = %$counts_ref;
  my @lengths = ($min .. $max);

  my $results = "\t" . (join "\t", @lengths) . "\n";

  my @totals = ();

  for my $base (qw(A T C G N)) {
    $results .= "$base";
    my @set = ();
    for my $len (@lengths) {
      my $count = $counts{$len}{$base} || 0;
      push @set, $count;
      $totals[$len] += $count;
      $results .= "\t$count";
    }
    $results .= "\n";
  }

  $results .= "Total:\t" . (join "\t", @totals[@lengths]) . "\n";

  $c->res->content_type('text/plain');
  $c->res->body($results);
}

1;
