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
use Chart::Clicker::Renderer::StackedBar;
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

  my $cc = Chart::Clicker->new(width => 800, height => 400);

  my $fastq_pipedata = $sequencingrun->initial_pipedata();

  my $seq_count_prop_type = $schema->find_with_type('Cvterm',
                                                 { name => 'sequence count' });
  my $barcode_prop_type = $schema->find_with_type('Cvterm',
                                                 { name => 'multiplexing code' });

  my %expected_barcode_ids = ();

  my @barcoded_samples = $sequencingrun->sequencing_sample()->search_related('coded_samples');

  for my $barcoded_sample (@barcoded_samples) {
    my $barcode_id = $barcoded_sample->barcode()->identifier();
    $expected_barcode_ids{$barcode_id}++;
  }

  my $fq_seq_count =
    $fastq_pipedata->search_related('pipedata_properties',
                                      { type => $seq_count_prop_type->cvterm_id() })
      ->next()->value();

  # all pipedatas that are generated from the fastq file of this sequencingrun
  my @demultiplex_pipedatas =
    $fastq_pipedata->pipeprocess_in_pipedatas()->search_related('pipeprocess')
      ->search_related('pipedatas');

  my %pipedata_info = ();

  my $total_reads_count = undef;
  my $rejected_reads_count = undef;

  for my $pipedata (@demultiplex_pipedatas) {
    if ($pipedata->content_type()->name() eq 'multiplexed_srna_reads') {
      $total_reads_count = $pipedata->search_related('pipedata_properties',
                                                       {
                                                         type => $seq_count_prop_type->cvterm_id()
                                                       })->next()->value();
    } else {
      if ($pipedata->content_type()->name() eq 'remove_adapter_rejects') {
        $rejected_reads_count = $pipedata->search_related('pipedata_properties',
                                                            {
                                                              type => $seq_count_prop_type->cvterm_id()
                                                            })->next()->value();

      } else {
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
          # we don't know the barcode for this pipedata
        }
      }
    }
  }

  my @series_list = ();

  my @keys = ();
  my @non_expected_barcode_values = ();
  my @expected_barcode_values = ();

  # hacky, but keys must be numbers:
  my %key_names = ();
  my $key_index = 0;

  for my $code_id (keys %pipedata_info) {
    push @keys, $key_index;
    $key_names{$key_index++} = $code_id;

    my $expected_barcode_count = 0;
    my $non_expected_barcode_count = 0;

    if (exists $expected_barcode_ids{$code_id}) {
      $expected_barcode_count = $pipedata_info{$code_id};
    } else {
      $non_expected_barcode_count = $pipedata_info{$code_id};
    }

    push @non_expected_barcode_values, $non_expected_barcode_count;
    push @expected_barcode_values, $expected_barcode_count;
  }

  warn "total_reads_count: $total_reads_count\n";

  if (defined $total_reads_count) {
    my $unknown_barcode_count = $total_reads_count;

    if (defined $rejected_reads_count) {
      $unknown_barcode_count -= $rejected_reads_count;

      push @non_expected_barcode_values, $rejected_reads_count;
      push @expected_barcode_values, 0;
      push @keys, $key_index;
      $key_names{$key_index++} = 'Rejected';
    }

    for my $code_count (values %pipedata_info) {
      $unknown_barcode_count -= $code_count;
    }

    push @non_expected_barcode_values, $unknown_barcode_count;
    push @expected_barcode_values, 0;
    push @keys, $key_index;
    $key_names{$key_index++} = 'Unknown';
  }

  # hack to pad the left and right
  unshift @keys, -1;
  unshift @expected_barcode_values, 0;
  unshift @non_expected_barcode_values, 0;
  push @keys, $key_index;
  push @expected_barcode_values, 0;
  push @non_expected_barcode_values, 0;

  push @series_list,
    Chart::Clicker::Data::Series->new(
      keys => [@keys],
      values => [@expected_barcode_values],
      name => 'Expected barcodes'
    );

  push @series_list,
    Chart::Clicker::Data::Series->new(
      keys => [@keys],
      values => [@non_expected_barcode_values],
      name => 'Other reads'
    );

  my $ds = Chart::Clicker::Data::DataSet->new(series => [ @series_list ]);

  $cc->add_to_datasets($ds);

  my $def = $cc->get_context('default');

  $def->domain_axis->tick_values(\@keys);
  $def->domain_axis->format(sub {
                             my $key = shift;
                             if (exists $key_names{$key}) {
                               return $key_names{$key};
                             } else {
                               return '';
                             }
                           });

  my $bar = Chart::Clicker::Renderer::StackedBar->new(opacity => .6);
  $def->renderer($bar);

  $c->stash->{graphics_primitive_driver_args} = { format => 'png' };
  $c->stash->{graphics_primitive_content_type} = 'image/png';
  $c->stash->{graphics_primitive} = $cc;
  $c->stash->{graphics_primitive_driver} = 'Cairo';

  $c->forward('SmallRNA::Web::View::Graph');
}

1;
