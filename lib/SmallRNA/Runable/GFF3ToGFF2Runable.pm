package SmallRNA::Runable::GFF3ToGFF2Runable;

=head1 NAME

SmallRNA::Runable::GFF3ToGFF2Runable - Create a GFF2 file from a GFF3 file

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Runable::GFF3ToGFF2Runable

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

use Moose;

use SmallRNA::Process::GFF3ToGFF2Process;

extends 'SmallRNA::Runable::SmallRNARunable';

=head2

 Function: Create a GFF2 file from a GFF3 file
 Returns : nothing - either succeeds or calls die()

=cut
sub run
{
  my $self = shift;
  my $schema = $self->schema();

  my $code = sub {
    my $pipeprocess = $self->pipeprocess();

    my @input_pipedatas = $pipeprocess->input_pipedatas();
    if (@input_pipedatas > 1) {
      croak ("pipeprocess ", $pipeprocess->pipeprocess_id(),
             " has more than one input pipedata\n");
    }
    my $input_pipedata = $input_pipedatas[0];

    my @samples = $input_pipedata->samples();

    if (@samples > 1) {
      croak ("pipedata for pipeprocess ", $pipeprocess->pipeprocess_id(),
             " has more than one sample\n")
    }

    my $sample = $samples[0];

    my $sample_name = $sample->name();

    my $input_format_type = $input_pipedata->format_type()->name();
    my $input_content_type = $input_pipedata->content_type()->name();

    if ($input_format_type ne 'gff3') {
      croak("must have 'gff3' as input, not: , $input_format_type");
    }

    my $output_type = 'gff2';
    my $data_dir = $self->config()->data_directory();

    my $input_file_name = $data_dir . '/' . $input_pipedata->file_name();

    my $output_file_name = $input_file_name;

    if ($output_file_name =~ s/\.$input_format_type$/.$output_type/) {
      SmallRNA::Process::GFF3ToGFF2Process::run(input_file_name => $input_file_name,
                                                output_file_name => $output_file_name,
                                                sample_name => $sample_name);

      $self->store_pipedata(generating_pipeprocess => $self->pipeprocess(),
                            file_name => $output_file_name,
                            format_type_name => $output_type,
                            content_type_name => $input_content_type);
    } else {
      croak("pattern match failed on: ", $output_file_name);
    }
  };
  $self->schema->txn_do($code);
}

1;
