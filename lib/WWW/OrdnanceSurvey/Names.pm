package WWW::OrdnanceSurvey::Names;

use Moo;
use namespace::autoclean;

extends 'WWW::OrdnanceSurvey';
has '+service' => ( default => 'opennames' );

1;

__END__

=pod

=encoding utf-8
 
=head1 NAME

WWW::OrdnanceSurvey::Names 

=cut
