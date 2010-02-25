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
use SmallRNA::Web::Controller::View;

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
  } elsif ($type eq 'biosample') {
    $c->stash()->{title} = 'Details for biosample ' . $object->name();
  } elsif ($type eq 'sequencing_run') {
    $c->stash()->{title} = 'Details for sequencing run ' . $object->identifier();
  } elsif ($type eq 'ecotype') {
    $c->stash()->{title} = 'Details for ecotype ' . $object->long_description();
  } elsif ($type eq 'organisation') {
    $c->stash()->{title} = 'Organisation details';
  } elsif ($type eq 'cv') {
    $c->stash()->{title} = 'Controlled vocabulary ' . $object->name();
  } elsif ($type eq 'sequencing_sample') {
    $c->stash()->{title} = 'Sequencing sample ' . $object->identifier();
  } elsif ($type eq 'library') {
    $c->stash()->{title} = 'Library ' . $object->identifier()
      . ' for sample: ' . $object->biosample()->name();
  } elsif ($type eq 'process_conf') {
    $c->stash()->{title} = 'Details for pipeline process configuration type: '
      . $object->type()->name();
  } elsif ($type eq 'process_conf_input') {
    $c->stash()->{title} = 'Details for process input configuration type for : '
      . $object->process_conf()->type()->name();
  }
}

our $TYPE_PATTERN =
  qr()x;

sub object_with_template : LocalRegex('^(cv|person|pipe[^/]+|biosample|sequencing_run|organism|organisation|ecotype|sequencing_sample|library|barcode|barcode_set|process_conf|process_conf_input)/(.*)') {
  my ($self, $c) = @_;
  my ($type, $object_key) = @{$c->req()->captures()};

  my $object = SmallRNA::Web::Controller::View::get_object_by_id_or_name($c, $type, $object_key);
  my $object_id = SmallRNA::DB::id_of_object($object);

  set_template($self, $c, $type, $object_id);
}

1;
