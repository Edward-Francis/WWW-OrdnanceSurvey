package WWW::OrdnanceSurvey::Places;

use Moo;
use namespace::autoclean;

extends 'WWW::OrdnanceSurvey';
has '+service' => ( default => 'places' );

1;

__END__

=pod

=head1 NAME

WWW::OrdnanceSurvey::Places 

=cut
