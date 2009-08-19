package SmallRNA::Web::Controller::Custom;

=head1 NAME

SmallRNA::Web::Controller::Action - Controller for miscellaneous actions

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Web::Controller::Action

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

use base 'Catalyst::Controller::HTML::FormFu';

sub create_seq_sample : Local {
  my ($self, $c) = @_;

  my $sample_id = $c->req->param("sample.id");
  my $schema = $c->schema();

  my $sample = $schema->find_with_type('Sample', sample_id => $sample_id);

  my $seq_sample = $schema->create_with_type('SequencingSample',
                                             { name => 'SEQSAMP-' . $sample->name() });

  my $description = 'Dummy coded sample for ', $sample->name(), ' - no barcode';
  my $initial_run_cvterm = $schema->find_with_type('Cvterm',
                                                   { name => 'initial run' });
  my $coded_sample = $schema->create_with_type('CodedSample',
                                               { description => $description,
                                                 coded_sample_type => $initial_run_cvterm,
                                                 sample => $sample,
                                                 sequencing_sample => $seq_sample });

  $c->res->redirect($c->uri_for("/new/object/sequencingrun",
                                {
                                  'sequencing_sample.id' => $seq_sample->sequencing_sample_id()
                                }));
  $c->detach();
}

1;
