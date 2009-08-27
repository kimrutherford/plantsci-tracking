package SmallRNA::DB::PipedataProperty;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("pipedata_property");
__PACKAGE__->add_columns(
  "pipedata_property_id",
  {
    data_type => "integer",
    default_value => "nextval('pipedata_property_pipedata_property_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "pipedata",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "type",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "value",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("pipedata_property_id");
__PACKAGE__->add_unique_constraint("pipedata_property_id_pk", ["pipedata_property_id"]);
__PACKAGE__->belongs_to(
  "pipedata",
  "SmallRNA::DB::Pipedata",
  { pipedata_id => "pipedata" },
);
__PACKAGE__->belongs_to("type", "SmallRNA::DB::Cvterm", { cvterm_id => "type" });


# Created by DBIx::Class::Schema::Loader v0.04005
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QrcWfXOEw00Pxb5THL8NoA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
