package SmallRNA::Web::Util;

=head1 NAME

SmallRNA::Web::Util - Utilities for the web code

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Web::Util

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

use SmallRNA::DB;

=head2

 Usage   : my ($field_value, $field_type) =
             SmallRNA::Web::Util::get_field_value($c, $object, $col_conf);
 Function: Get the real value of a field, for display.  The value may be
           straight from the database column, or may be created with Perl code
           in the source key of the configuration.
 Args    : $c - the Catalyst context
           $object - the object
           $col_conf - configuration of this column
                       eg.  { name => 'Sample name',
                              conf => 'name',   # the name field of the sample
                            }
                       or   { name => 'Half size',
                              conf => { perl => '$object->size() / 2' },  # Perl code
                              format => '%6.2f'              # format with sprintf
                            }
                       or   { name => 'Big count',
                              conf => { perl => '$object->count() + 100' },
                              format => integer   # format as integer and right align
                            }
                       
 Return  : $field_value - the value of the field or display or use.  If it is a
                          foreign key the whole object that is returned
           $field_type - can be:
                            'table_id': the id column of this table
                            'foreign_key': this field is a foreign key
                            'attribute': this is a plain attribute field
                            'key_field': this is the attribute field that is the
                               natural primary key for this class
           $ref_display_key - the display key of the referenced object
                              (or undef)

=cut
sub get_field_value
{
  my $c = shift;
  my $object = shift;
  my $col_conf = shift;

  my $type = $object->table();

  if (defined $col_conf->{source} && $col_conf->{source} =~ /[\$\-<>\';]/) {
    # Perl code
    my $field_value = eval $col_conf->{source};
    if ($@) {
      $field_value = $@;
      warn "$@\n";
    }

    return ($field_value, 'attribute', undef);
  }

  my $name = $col_conf->{name};

  my $parent_class_name = SmallRNA::DB::class_name_of_table($type);

  my $field_db_column = $name;

  my $source = $col_conf->{source};
  if (defined $source) {
    $field_db_column = $source;
  }

  if ($name eq "${type}_id") {
    return ($object->$field_db_column(), 'table_id', undef);
  }

  $field_db_column =~ s/_id$//;

  my $field_value = $object->$field_db_column();

  my $info_ref = $parent_class_name->relationship_info($field_db_column);

  if (!defined $info_ref) {
    my $short_field = $field_db_column;
    $short_field =~ s/_id//;
    $info_ref = $parent_class_name->relationship_info($short_field);
  }

  if (defined $info_ref) {
    my %info = %{$info_ref};
    my $referenced_object = $object->$field_db_column();

    if (defined $referenced_object) {
      my $referenced_class_name = $info{class};
      my $referenced_table = SmallRNA::DB::table_name_of_class($referenced_class_name);

      my $primary_key_name = $c->config()->{class_info}->{$referenced_table}->{display_field};

      if (!defined $primary_key_name) {
        die "no class_info/display_field configuration for $referenced_table\n";
      }

      return ($field_value, 'foreign_key', $primary_key_name);
    } else {
      return (undef, 'foreign_key', undef);
    }
  } else {
    my $display_key_field = $c->config()->{class_info}->{$type}->{display_field};

    if (defined $display_key_field && $name eq $display_key_field) {
      return ($field_value, 'key_field', undef);
    } else {
      return ($field_value, 'attribute', undef);
    }
  }
}

1;
