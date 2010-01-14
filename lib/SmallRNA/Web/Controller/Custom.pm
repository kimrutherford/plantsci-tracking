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

sub create_seq_biosample : Local {
  my ($self, $c) = @_;

  my $biosample_id = $c->req->param("biosample.id");
  my $schema = $c->schema();

  my $biosample = $schema->find_with_type('Biosample', biosample_id => $biosample_id);

  my $description = 'Library for ' . $biosample->name() . ' - no barcode';
  my $initial_run_cvterm = $schema->find_with_type('Cvterm',
                                                   { name => 'initial run' });
  my $library = $schema->create_with_type('Library',
                                          { description => $description,
                                            library_type => $initial_run_cvterm,
                                            biosample => $biosample });

  $c->res->redirect($c->uri_for("/new/object/sequencing_sample",
                                {
                                  'library.id' => $library->library_id()
                                }));
  $c->detach();
}

1;
