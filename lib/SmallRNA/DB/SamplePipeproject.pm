package SmallRNA::DB::SamplePipeproject;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("sample_pipeproject");
__PACKAGE__->add_columns(
  "sample_pipeproject_id",
  {
    data_type => "integer",
    default_value => "nextval('sample_pipeproject_sample_pipeproject_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "sample",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "pipeproject",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
);
__PACKAGE__->set_primary_key("sample_pipeproject_id");
__PACKAGE__->add_unique_constraint("sample_pipeproject_id_pk", ["sample_pipeproject_id"]);
__PACKAGE__->add_unique_constraint("sample_pipeproject_constraint", ["sample", "pipeproject"]);
__PACKAGE__->belongs_to(
  "pipeproject",
  "SmallRNA::DB::Pipeproject",
  { pipeproject_id => "pipeproject" },
);
__PACKAGE__->belongs_to("sample", "SmallRNA::DB::Sample", { sample_id => "sample" });


# Created by DBIx::Class::Schema::Loader v0.04005
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8kxcgUE5VHL91XyD8fyE1Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
