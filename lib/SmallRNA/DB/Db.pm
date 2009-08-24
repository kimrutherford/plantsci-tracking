package SmallRNA::DB::Db;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("db");
__PACKAGE__->add_columns(
  "db_id",
  {
    data_type => "integer",
    default_value => "nextval('db_db_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "name",
  {
    data_type => "character varying",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "description",
  {
    data_type => "character varying",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "urlprefix",
  {
    data_type => "character varying",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "url",
  {
    data_type => "character varying",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("db_id");
__PACKAGE__->add_unique_constraint("db_c1", ["name"]);
__PACKAGE__->add_unique_constraint("db_pkey", ["db_id"]);
__PACKAGE__->has_many(
  "dbxrefs",
  "SmallRNA::DB::Dbxref",
  { "foreign.db_id" => "self.db_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:495qDitFdkBR+/vjrowk+Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
