package WWW::OrdnanceSurvey::Places;

use Moo;
use namespace::autoclean;

extends 'WWW::OrdnanceSurvey';

has '+service' => ( default => 'places' );

1;
