package SmallRNA::Web::Controller::View::Object;

=head1 NAME

SmallRNA::Web::Controller::View::Object - Special case handling of objects

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Web::Controller::View::Object

You can also look for information at:

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
use base 'Catalyst::Controller';

use SmallRNA::DB;

sub set_template : Private {
  my ($self, $c, $type, $object_id) = @_;

  SmallRNA::Web::Controller::View::object($self, $c, $type, $object_id);

  $c->stash()->{template} = "view/object/$type.mhtml";

  my $class_name = SmallRNA::DB::class_name_of_table($type);

  my $object = $c->schema()->resultset($class_name)->find($object_id);

  if ($type eq 'person') {
    $c->stash()->{title} = 'User details for ' . $object->full_name();
  } elsif ($type eq 'pipeproject') {
    $c->stash()->{title} = 'Details for project ' . $object->description();
  } elsif ($type eq 'pipeprocess') {
    $c->stash()->{title} = 'Details for process ' . $object->description();
  } elsif ($type eq 'pipedata') {
    $c->stash()->{title} = 'Details for data ' . $object->file_name();
  } elsif ($type eq 'organism') {
    $c->stash()->{title} = 'Details for organism ' . $object->full_name();
  } elsif ($type eq 'sample') {
    $c->stash()->{title} = 'Details for sample ' . $object->name();
  } elsif ($type eq 'sequencingrun') {
    $c->stash()->{title} = 'Details for sequencing run ' . $object->identifier();
  } elsif ($type eq 'ecotype') {
    $c->stash()->{title} = 'Details for ecotype ' . $object->long_description();
  } elsif ($type eq 'organisation') {
    $c->stash()->{title} = 'Organisation details';
  } elsif ($type eq 'cv') {
    $c->stash()->{title} = 'Controlled vocabulary ' . $object->name();
  } elsif ($type eq 'sequencing_sample') {
    $c->stash()->{title} = 'Sequencing sample ' . $object->name();
  } elsif ($type eq 'coded_sample') {
    $c->stash()->{title} = 'Sample with barcode for sample: ' . $object->sample()->name();
  }
}

sub object_with_template : LocalRegex('^(cv|person|pipe[^/]+|sample|sequencingrun|organism|organisation|ecotype|sequencing_sample|coded_sample|barcode|barcode_set)/(.*)') {
  my ($self, $c) = @_;
  my ($type, $object_id) = @{$c->req()->captures()};
  set_template($self, $c, $type, $object_id);
}

1;
