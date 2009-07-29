package SmallRNA::DB::Protocol;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("protocol");
__PACKAGE__->add_columns(
  "name",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "description",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("name");
__PACKAGE__->add_unique_constraint("protocol_pk", ["name"]);
__PACKAGE__->has_many(
  "samples",
  "SmallRNA::DB::Sample",
  { "foreign.protocol" => "self.name" },
);


# Created by DBIx::Class::Schema::Loader v0.04005
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FxCUGteadj0VeZ5i0GNKwA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
