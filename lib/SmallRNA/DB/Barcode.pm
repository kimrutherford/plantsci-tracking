package SmallRNA::DB::Barcode;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("barcode");
__PACKAGE__->add_columns(
  "barcode_id",
  {
    data_type => "integer",
    default_value => "nextval('barcode_barcode_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "created_stamp",
  {
    data_type => "timestamp without time zone",
    default_value => "now()",
    is_nullable => 0,
    size => 8,
  },
  "identifier",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "barcode_set",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "code",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("barcode_id");
__PACKAGE__->add_unique_constraint("barcode_id_pk", ["barcode_id"]);
__PACKAGE__->add_unique_constraint("barcode_code_constraint", ["code", "barcode_set"]);
__PACKAGE__->add_unique_constraint(
  "barcode_identifier_constraint",
  ["identifier", "barcode_set"],
);
__PACKAGE__->belongs_to(
  "barcode_set",
  "SmallRNA::DB::BarcodeSet",
  { barcode_set_id => "barcode_set" },
);
__PACKAGE__->has_many(
  "coded_samples",
  "SmallRNA::DB::CodedSample",
  { "foreign.barcode" => "self.barcode_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9x8Cak4clfG0eA4VqIeCRw

sub long_identifier
{
  my $self = shift;

  my $barcode_set_name = $self->barcode_set()->name();
  my $barcode_identifier = $self->identifier();
  my $barcode_code = $self->code();

  return "$barcode_set_name $barcode_identifier ($barcode_code)";
}


# You can replace this text with custom content, and it will be preserved on regeneration
1;
