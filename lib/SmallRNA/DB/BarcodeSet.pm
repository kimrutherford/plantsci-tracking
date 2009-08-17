package SmallRNA::DB::BarcodeSet;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("barcode_set");
__PACKAGE__->add_columns(
  "barcode_set_id",
  {
    data_type => "integer",
    default_value => "nextval('barcode_set_barcode_set_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "position_in_read",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "name",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("barcode_set_id");
__PACKAGE__->add_unique_constraint("barcode_set_id_pk", ["barcode_set_id"]);
__PACKAGE__->add_unique_constraint("barcode_set_name_key", ["name"]);
__PACKAGE__->has_many(
  "barcodes",
  "SmallRNA::DB::Barcode",
  { "foreign.barcode_set" => "self.barcode_set_id" },
);
__PACKAGE__->belongs_to(
  "position_in_read",
  "SmallRNA::DB::Cvterm",
  { cvterm_id => "position_in_read" },
);


# Created by DBIx::Class::Schema::Loader v0.04005
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oJLnGHllWHi9K7STfUAPzg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
