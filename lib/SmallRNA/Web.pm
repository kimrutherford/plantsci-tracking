package SmallRNA::Web;

use strict;
use warnings;

use Catalyst::Runtime '5.70';

use Sys::Hostname;

use parent qw/Catalyst/;
use Catalyst qw/ConfigLoader
                StackTrace
                Authentication
                Session
                Session::Store::FastMmap
                Session::State::Cookie
                Static::Simple/;
our $VERSION = '0.01';

my $login = getlogin() || getpwuid($<) || $ENV{USER} ||  'unknown';

my ($host) = Sys::Hostname::hostname() =~ m/^([^\.]+)/;

__PACKAGE__->config(name => 'SmallRNA::Web',
                    'Plugin::ConfigLoader' => {
                      file                => __PACKAGE__->path_to('smallrna_web'),
                      config_local_suffix => $login . '_' . $host,
                    },
                    session => { flash_to_stash => 1 },
                    'View::Graphics::Primitive' => {
                      driver => 'Cairo',
                      driver_args => { format => 'pdf' },
                      content_type => 'application/pdf'
                    },
		    'Plugin::Session' => {
                         expires => 3600,
			 storage => "/tmp/small_session_$login"
		    }
                   );

# Start the application
__PACKAGE__->setup();

my $config = __PACKAGE__->config();

# this is hacky, but allows us to call methods on the config object
bless $config, 'SmallRNA::Config';

use SmallRNA::Config;

$config->setup();

# shortcut to the schema
sub schema
{
  my $self = shift;
  return $self->model('SmallRNAModel')->schema();
}


=head1 NAME

SmallRNA::Web - PlantSci smallRNA application

=head1 SYNOPSIS

    script/smallrna_web_server.pl

=head1 DESCRIPTION

The University of Cambridge Department of Plant Sciences smallRNA application.

=head1 SEE ALSO

L<SmallRNA::Web::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Kim Rutherford <kmr44@cam.ac.uk>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
