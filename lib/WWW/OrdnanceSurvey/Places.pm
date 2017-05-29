package WWW::OrdnanceSurvey::Places;

use Moo;
use namespace::autoclean;

extends 'WWW::OrdnanceSurvey';
has '+service' => ( default => 'places' );

1;

__END__

=pod

=encoding utf-8
 
=head1 NAME

WWW::OrdnanceSurvey::Places 

=cut
