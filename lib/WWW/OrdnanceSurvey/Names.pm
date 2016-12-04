package WWW::OrdnanceSurvey::Names;

use Moose;
use namespace::autoclean;

extends 'WWW::OrdnanceSurvey';

has '+_service' => ( default => 'opennames' );

sub find    { shift->perform_request( 'find',    @_ ) }
sub nearest { shift->perform_request( 'nearest', @_ ) }

1;
