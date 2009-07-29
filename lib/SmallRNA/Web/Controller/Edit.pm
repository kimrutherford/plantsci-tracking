package SmallRNA::Web::Controller::Edit;

=head1 NAME

SmallRNA::Web::Controller::Edit - controller to handler /edit/... requests

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Web::Controller::Edit

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
use Carp;

use base 'Catalyst::Controller::HTML::FormFu';

use SmallRNA::DBLayer::Path;

sub _get_field_values
{
  my $c = shift;
  my $table_name = shift;
  my $class_name = shift;
  my $select_values = shift;
  my $field_info = shift;
  my $type = shift;

  my $field_name = $c->config()->{class_info}->{$table_name}->{display_field};

  my $values_constraint = $field_info->{values_constraint};

  my $constraint_path = undef;
  my $constraint_value = undef;

  # constrain the possible values shown in the list by using the
  # values_constraint from the config file
  if (defined $values_constraint) {
    my $pattern = qr|^\s*(.*?)\s*=\s*"(.*)"\s*$|;
    if ($values_constraint =~ /$pattern/) {
      $constraint_path = SmallRNA::DBLayer::Path->new(path_string => $1);
      $constraint_value = $2;
    } else {
      die "values_constraint '$values_constraint' doesn't match pattern: $pattern\n";
    }
  }

  my $rs = $c->schema()->resultset($class_name);

  my @res = ();

  while (defined (my $row = $rs->next())) {
    if (defined $values_constraint) {
      my $this_constrain_value = $constraint_path->resolve($row);
      next unless $constraint_value eq $this_constrain_value;
    }

    # multi-column primary keys aren't supported
    my $table_pk_column = ($row->primary_columns())[0];

    my $option = { value => $row->$table_pk_column(),
                   label => $row->$field_name() };

    if (grep { $row->$table_pk_column() eq $_ } @$select_values) {
      if ($type eq 'Select') {
        $option->{attributes} = { selected => 't' };
      } else {
        $option->{attributes} = { checked => 't' };
      }
    }

    push @res, $option;
  }

  return @res;
}

# the names of buttons in the form so we can skip them later
my @INPUT_BUTTON_NAMES = qw(submit cancel);

sub _init_form_field
{
  my $c = shift;
  my $field_info = shift;
  my $object = shift;
  my $type = shift;

  my $field_label = $field_info->{field_label};

  my $display_field_label = $field_label;
  $display_field_label =~ s/_/ /g;

  next unless $field_info->{editable};

  my $field_db_column = $field_label;

  if (defined $field_info->{field_conf}) {
    $field_db_column = $field_info->{field_conf};
  }

  my $elem = {
    name => $field_label, label => $display_field_label
  };

  my $class_name = SmallRNA::DB::class_name_of_table($type);
  my $db_source = $c->schema()->source($class_name);

  my $info_ref;

  if (!$field_info->{is_collection}) {
    $info_ref = $class_name->relationship_info($field_db_column);
  }

  if (defined $info_ref) {
    my %info = %{$info_ref};
    my $referenced_class_name = $info{class};

    my $referenced_table = SmallRNA::DB::table_name_of_class($referenced_class_name);

    if (!defined $field_label) {
      die "no display_key_fields configuration for $referenced_table\n";
    }

    $elem->{type} = 'Select';
    my $current_value = undef;
    if (defined $object && defined $object->$field_db_column()) {
      my $other_object = $object->$field_db_column();
      my $table_pk_column = ($other_object->primary_columns())[0];

      $current_value = $other_object->$table_pk_column();
    } else {
      $current_value = $c->req->param("$referenced_table.id");
    }

    my @current_values = ();

    if (defined $current_value) {
      push @current_values, $current_value;
    }

    $elem->{options} = [_get_field_values($c, $referenced_table,
                                          $referenced_class_name,
                                          [@current_values], $field_info,
                                          'Select')];

    my $field_is_nullable = $db_source->column_info($field_db_column)->{is_nullable};

    if ($field_is_nullable) {
      # add a blank to the select list if this field can be null
      unshift @{$elem->{options}}, [0, ''];
    }
  } else {
    if ($field_info->{is_collection}) {
      my $referenced_class_name = $field_info->{referenced_class};

      my $referenced_table = SmallRNA::DB::table_name_of_class($referenced_class_name);

      $elem->{type} = 'Checkboxgroup';

      my @current_values = ();
      if (defined $object) {
        my $rs = $object->$field_db_column();
        while (defined (my $row = $rs->next())) {
          my $row_pk_field = ($row->primary_columns())[0];
          push @current_values, $row->$row_pk_field();
        }
      } else {
        push @current_values, $c->req->param("$referenced_table.id");
      }

      $elem->{options} = [_get_field_values($c, $referenced_table,
                                            $referenced_class_name,
                                            [@current_values], $field_info,
                                            'Checkboxgroup')];
    } else {
      $elem->{type} = 'Text';
      if (!$db_source->column_info($field_db_column)->{is_nullable}) {
        $elem->{constraints} = [ { type => 'Length',  min => 1 },
          'Required' ];
      }
      if (defined $object) {
        $elem->{value} = $object->$field_db_column();
      } else {
        # try to set the default value (if configured)
        my $default_value_code = $field_info->{default_value};

        if (defined $default_value_code) {
          $elem->{value} = eval "$default_value_code";
          if ($@) {
            warn "error evaluating default_value configuration for "
              . "'$field_label': $@";
          }
        }
      }
    }
  }

  return $elem;
}

# Initialise the form using the list of field_infos in the config file.
# Attributes will be rendered as text areas, references as pop ups.
sub _initialise_form
{
  my $c = shift;
  my $object = shift;
  my $type = shift;
  my $form = shift;

  my @elements = ();

  my @field_infos = @{$c->config()->{class_info}->{$type}->{field_info_list}};

  for my $field_info (@field_infos) {
    if (!$field_info->{admin_only} ||
          $c->user_exists() && $c->user()->role()->name() eq 'admin') {
      push @elements, _init_form_field($c, $field_info, $object, $type);
    }
  }

  $form->default_args({elements => { Text => { size => 50 } } });

  $form->auto_fieldset(1);
  $form->elements([
                    @elements,
                    { name => 'clear-div', type => 'Block',
                      attributes => { style => 'clear: both;' } },
                    map { {
                      name => $_, type => 'Submit', value => ucfirst $_
                    } } @INPUT_BUTTON_NAMES,
                  ]);

}

sub _create_object {
  my $c = shift;
  my $table_name = shift;
  my $form = shift;

  my $schema = $c->schema();

  my $class_name = SmallRNA::DB::class_name_of_table($table_name);

  my $class_info_ref = $c->config()->{class_info}->{$table_name};
  if (!defined $class_info_ref) {
    croak "can't find configuration for editing $table_name objects\n";
  }

  my %form_params = %{$form->params()};
  my %object_params = ();

  for my $name (keys %form_params) {
    if (grep { $_ eq $name } @INPUT_BUTTON_NAMES) {
      next;
    }

    my $field_info_ref = $class_info_ref->{field_infos}->{$name};
    my %field_info = %{$field_info_ref};

    next if $field_info{is_collection};

    my $field_db_column = $name;

    if (defined $field_info{field_conf}) {
      $field_db_column = $field_info{field_conf};
    }

    my $value = $form_params{$name};

    my $info_ref = $class_name->relationship_info($field_db_column);

    if (defined $info_ref && $value == 0) {
      # special case for undefined references which are represented in the form
      # as a 0
      $value = undef;
    }

    if ($value =~ /^\s*$/) {
      # if the user doesn't enter anything, use undef
      $value = undef;
    }

    $object_params{$field_db_column} = $value;
  }

  my $object = $schema->create_with_type($class_name, { %object_params });

  # set collections - this is a hack because the other fields will be set for a
  # second time
  _update_object($c, $object, $form);
}

# update the object based on the form values
sub _update_object {
  my $c = shift;
  my $object = shift;
  my $form = shift;

  my %form_params = %{$form->params()};

  my $type = $object->table();
  my $class_name = SmallRNA::DB::class_name_of_table($type);

  my $class_info_ref = $c->config()->{class_info}->{$type};

  for my $name (keys %form_params) {
    if (grep { $_ eq $name } @INPUT_BUTTON_NAMES) {
      next;
    }

    my $field_info_ref = $class_info_ref->{field_infos}->{$name};
    my %field_info = %{$field_info_ref};

    my $field_db_column = $name;

    if (defined $field_info{field_conf}) {
      $field_db_column = $field_info{field_conf};
    }

    my $value = $form_params{$name};
    my $info_ref = $object->relationship_info($field_db_column);

    if (defined $info_ref && $value == 0) {
      # special case for undefined references which are represented in the form
      # as a 0
      $value = undef;
    }

    if (defined $value && $field_info{is_collection}) {
      # special case for collections, we need to look up the objects
      my $referenced_class_name = $field_info{referenced_class};
      my $referenced_table = SmallRNA::DB::table_name_of_class($referenced_class_name);
      my $set_meth = "set_$field_db_column";

      my @values;

      if (ref $value) {
        @values = @$value;
      } else {
        @values = ($value);
      }

      @values = map {
        $c->schema()->find_with_type($referenced_class_name,
                                     "${referenced_table}_id" => $_);
      } @values;

      $object->$set_meth(@values);
    } else {
      $object->$field_db_column($value);
    }
  }

  $object->update();
}

sub object : Regex('(new|edit)/object/([^/]+)(?:/([^/]+))?') {
  my ($self, $c) = @_;

  my ($req_type, $type, $object_id) = @{$c->req->captures()};

  my $object = undef;

  if (defined $object_id) {
    my $class_name = SmallRNA::DB::class_name_of_table($type);
    $object = $c->schema()->find_with_type($class_name, "${type}_id" => $object_id);
  }

  my $st = $c->stash;

  my $display_type_name = SmallRNA::DB::display_name($type);

  if ($req_type eq 'new') {
    $st->{title} = "New $display_type_name";
  } else {
    $st->{title} = "Edit $display_type_name";
  }

  $st->{template} = "edit.mhtml";

  my $form = $self->form;

  _initialise_form($c, $object, $type, $form);

  $form->process;

  $c->stash->{form} = $form;

  if ($form->submitted() && defined $c->req->param('cancel')) {
    if ($req_type eq 'new') {
      $c->res->redirect($c->uri_for("/"));
      $c->detach();
    } else {
      $c->res->redirect($c->uri_for("/view/object/$type/$object_id"));
      $c->detach();
    }
  }

  if ($form->submitted_and_valid()) {
    if ($req_type eq 'new') {
      $c->schema()->txn_do(sub {
                             my $object = _create_object($c, $type, $form);

                             # multi-column primary keys aren't supported
                             my $table_pk_field = ($object->primary_columns())[0];

                             # get the id so we can redirect below
                             $object_id = $object->$table_pk_field();
                           });
    } else {
      $c->schema()->txn_do(sub {
                             _update_object($c, $object, $form);
                           });
    }

    $c->res->redirect($c->uri_for("/view/object/$type/$object_id"));
    $c->detach();
  }
}

1;
