package SmallRNA::Web::Report;

=head1 NAME

SmallRNA::Web::Reports::Util - Utility methods for reports

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Web::Reports::Util

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

my %_biosample_props_cache = ();

my $_cache_time = undef;
my $MAX_CACHE_AGE = 10 * 60;  # 10 minutes

sub _get_biosample_props
{
  my $biosample = shift;

  if (exists $_biosample_props_cache{$biosample->biosample_id()}) {
    return %{$_biosample_props_cache{$biosample->biosample_id()}};
  }

  my @pipedatas = $biosample->pipedatas()->search({}, { prefetch => [
                                                       'content_type',
                                                       'format_type',
                                                       { pipedata_properties => 'type' } ] });

  my %results = ();

  for my $pipedata (@pipedatas) {
    my %props = ();
    my @pipedata_properties = $pipedata->pipedata_properties();

    for my $pipedata_property (@pipedata_properties) {
      $props{$pipedata_property->type()->name()} = $pipedata_property->value();
    }

    my $prop_key = $pipedata->content_type()->name() . ':' . $pipedata->format_type()->name();

    if (defined $props{'alignment component'}) {
      $prop_key .= ':' . $props{'alignment component'};
    }

    $results{$prop_key} = \%props;
  }

  $_biosample_props_cache{$biosample->biosample_id()} = \%results;

  return %results;
}

sub get_pipedata_property
{
  my $biosample = shift;
  my $alignment_component = shift;
  my $wanted_content_type_name = shift;
  my $wanted_format_type_name = shift;
  my $property_type_name = shift;

  my %results = _get_biosample_props($biosample);
  my $prop_ref = $results{"$wanted_content_type_name:$wanted_format_type_name"};

  if (!defined $prop_ref && defined $alignment_component) {
    $prop_ref = $results{"$wanted_content_type_name:$wanted_format_type_name:$alignment_component"};
  }

  return undef unless defined $prop_ref;

  my %props = %{$prop_ref};

  if (!exists $props{'alignment component'} ||
        $props{'alignment component'} eq $alignment_component) {
    if (exists $props{$property_type_name}) {
      return $props{$property_type_name};

    }
  }

  return undef;
}

sub get_pipedata_property_precent
{
  my $biosample = shift;
  my %args = @_;

  if (defined $args{first} && defined $args{second}) {
    my $first_val = get_pipedata_property($biosample, @{$args{first}});
    my $second_val = get_pipedata_property($biosample, @{$args{second}});

    if (defined $first_val && defined $second_val && $second_val != 0) {
      return int(10000 * $first_val / $second_val) / 100;
    } else {
      return undef;
    }
  } else {
    croak "must pass 'first' and 'second' parameters\n";
  }
}

1;
