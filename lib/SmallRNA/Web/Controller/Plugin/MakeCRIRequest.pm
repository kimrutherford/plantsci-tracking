package SmallRNA::Web::Controller::Plugin::MakeCRIRequest;

=head1 NAME

SmallRNA::Web::Controller::Action - action for creating a sequencing_sample and
  and a CRI request

=head1 SYNOPSIS

=head1 AUTHOR

Kim Rutherford C<< <kmr44@cam.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<kmr44@cam.ac.uk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SmallRNA::Web::Controller::Plugin::MakeCRIRequest

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

use DateTime;

use base 'Catalyst::Controller::HTML::FormFu';

use CRI::SOAP;

sub _create_cri_request
{
  my $config = shift;
  my $sl_identifier = shift;
  my $sample_creator = shift;

  my $host = '192.168.80.1';
  my ($service);

  my $port = 8080;

  eval {
#    CRI::SOAP->debug();
          $service = CRI::SOAP->new('http', $host, $port, '/solexa-ws/SolexaExternalBeanWS', 'http://solexa.webservice.melab.cruk.org/','kr1:kr1', 0);
  };
  if($@) {
    die $@;
  }

  my $sample_info = $service->call('submitRequest', $sl_identifier,
                                   $sample_creator, 2, 45, 'Single End Single Sample',
                                   {sequenceType=>'DNA'},{assayType=>'WHOLE_GENOME'},
                                   '');

  my $slx_id = $sample_info->{slxId};
  my $request_id = $sample_info->{request_id};

  return ($slx_id, $request_id);
}

=head2 make_cri_request

 Usage   : Called as a Catalyst action
 Function: Creates a sequencing_run and adds it to the CRI LIMS.
 Args    : none, but use

=cut
sub make_cri_request : Path('/plugin/make_cri_request') {
  my ($self, $c) = @_;

  my $sequencing_sample_id = $c->req->param("sequencing_sample.id");
  my $schema = $c->schema();

  my $sequencing_sample =
    $schema->find_with_type('SequencingSample',
                            sequencing_sample_id => $sequencing_sample_id);

  my $sequencing_run = undef;
  my $submit_request_error = undef;

  $c->schema()->txn_do(
    sub {
      my ($cri_slx_identifier, $cri_request_identifier);

      eval {
         ($cri_slx_identifier, $cri_request_identifier) =
           _create_cri_request($c->config(), $sequencing_sample->identifier(),
                               $sequencing_sample->sample_creator()->username());
      };
      if ($@) {
        warn "ERROR FROM CRI: $@\n";
        $submit_request_error =
          qq(Failed to create sequencing run - request to CRI failed with error: $@);
        return;
      }

      $sequencing_sample->sequencing_centre_identifier($cri_slx_identifier);
      $sequencing_sample->update();

      my $sequencing_centre = $schema->find_with_type('Organisation',
                                                      name => 'CRUK CRI');

      my $illumina_sequencing_cvterm =
        $schema->find_with_type('Cvterm', name => 'Illumina');
      my $quality_cv = $schema->find_with_type('Cv', name => 'tracking quality values');
      my $unknown_quality_cvterm =
        $schema->find_with_type('Cvterm', { name => 'unknown',
                                            cv_id => $quality_cv->cv_id() });

      $sequencing_run =
        $schema->create_with_type('SequencingRun',
                                    { identifier => $cri_request_identifier,
                                      sequencing_sample => $sequencing_sample_id,
                                      sequencing_centre => $sequencing_centre,
                                      submission_date => DateTime->now(),
                                      sequencing_type => $illumina_sequencing_cvterm,
                                      quality => $unknown_quality_cvterm
                                     });

      $c->flash->{message} = qq(Sequencing run added to CRI database as $cri_slx_identifier, request ID: $cri_request_identifier);
    }
  );

  if (defined $submit_request_error) {
    $c->stash->{error} = $submit_request_error;
    $c->forward('/view/object/sequencing_sample/' . $sequencing_sample_id);
  } else {
    $c->res->redirect($c->uri_for("/view/object/sequencing_run",
                                  $sequencing_run->sequencing_run_id()
                                 ));
    $c->detach();
  }
}

1;
