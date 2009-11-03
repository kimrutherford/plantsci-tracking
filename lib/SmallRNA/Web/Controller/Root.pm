package SmallRNA::Web::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

SmallRNA::Web::Controller::Root - Root Controller for SmallRNA::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

sub default :Path {
  my ( $self, $c ) = @_;
  $c->response->body( 'Page not found' );
  $c->response->status(404);
}

sub start : Path('/') {
  my ($self, $c) = @_;
  $c->stash->{title} = 'Start page';
  $c->stash->{template} = 'start.mhtml';
}

=head2 end

 Attempt to render a view, if needed.

=cut

sub end : Private {
  my $self = shift;
  my $c = shift;

  # copied from RenderView.pm
  if (! $c->response->content_type ) {
    $c->response->content_type( 'text/html; charset=utf-8' );
  }
  return 1 if $c->req->method eq 'HEAD';
  return 1 if length( $c->response->body );
  return 1 if scalar @{ $c->error } && !$c->stash->{template};
  return 1 if $c->response->status =~ /^(?:204|3\d\d)$/;
  $c->forward('SmallRNA::Web::View::Mason');
}

=head2 login

 Try to authenticate a user based on username and password parameters

=cut
sub login : Global {
  my ( $self, $c ) = @_;
  my $username = $c->req->param('username');
  my $password = $c->req->param('password');

  my $return_path = $c->req->param('return_path');

  if ($c->authenticate({username => $username, password => $password})) {
    if ($return_path =~ m:logout:) {
      $c->forward('/start');
      return 0;
    }
  } else {
    $c->stash->{error} = "log in failed";
  }

  $c->res->redirect($return_path, 302);
  $c->detach();
  return 0;
}

=head2 logout

 Log out the user and return to the front page.

=cut

sub logout : Global {
  my ( $self, $c ) = @_;
  $c->logout;

  $c->forward('/start');
}

=head2 head

 Output contents of the <head> section

=cut

sub head : Global {
  my ( $self, $c ) = @_;

  $c->stash->{title} = $c->req->param("page_title");
  $c->stash->{template} = 'head.mhtml';
}

=head2 header

 Output html for the top of the page, inside <body>

=cut
sub header : Global {
  my ( $self, $c ) = @_;

  $c->stash->{template} = 'header.mhtml';
}

=head1 AUTHOR

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
