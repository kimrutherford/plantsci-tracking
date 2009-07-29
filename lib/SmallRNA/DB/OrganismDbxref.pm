package SmallRNA::DB::OrganismDbxref;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("organism_dbxref");
__PACKAGE__->add_columns(
  "organism_dbxref_id",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "organism_id",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "dbxref_id",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
);
__PACKAGE__->belongs_to(
  "organism",
  "SmallRNA::DB::Organism",
  { organism_id => "organism_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AjcKoxOGtu0eONEGZ0S6Sw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
