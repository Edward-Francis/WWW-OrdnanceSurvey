package WWW::OrdnanceSurvey;

use Moo;
use namespace::autoclean;

# ROLES
with 'WWW::OrdnanceSurvey::API';

# VERSION
our $VERSION = '0.0';

# IMPORTS
use URI;
use Carp;
use URI::QueryParam;
use Cpanel::JSON::XS;
use LWP::UserAgent ();

# CONSTANTS
use constant API_URL => 'https://api.ordnancesurvey.co.uk/%s/v1/%s';

# ATTRIBUTES
has 'api_key' => ( is => 'ro', required => 1 );
has 'format'  => ( is => 'ro', default  => 'json' );
has 'service' => ( is => 'ro', required => 1 );
has 'agent'   => ( is => 'ro', default  => sub { LWP::UserAgent->new } );
has 'url'     => ( is => 'ro', default  => API_URL );

# CONSTRUCTOR

sub BUILD {
    my $self       = $_[0];
    my $definition = $self->api( $self->service );

    # add methods
    for my $method ( keys %{$definition} ) {
        __PACKAGE__->meta->add_method(
            $method => sub { shift->perform_request( $method, @_ ) } );
    }
}

# METHODS

sub perform_request {
    my ( $self, $name, %args ) = @_;

    my $service  = $self->service;
    my $api      = $self->api->{$service}->{$name};
    my $endpoint = $api->{endpoint};
    my $method   = $api->{method};

    # create url
    my $url = sprintf $self->url, $service, $endpoint;
    my $uri = URI->new($url);

    # set defaults
    $args{format} //= $self->format;
    $args{key}    //= $self->api_key;

    # add query params
    for ( sort @{ $api->{qs} }, 'key' ) {
        $uri->query_param( $_ => $args{$_} ) if defined $args{$_};
    }

    my $request = HTTP::Request->new( $method, $uri );

    # add post data
    if ( $method eq 'POST' ) {
        my %body = map { $_ => $args{$_} } @{ $api->{body} };
        $request->content( encode_json( \%body ) );
        $request->header( 'Content-Type' => 'application/json' );
    }

    # make actual request
    my $response = $self->agent->request($request);
    my $content  = $response->content;

    # handle errors
    if ( !$response->is_success ) {
        croak sprintf
            'Unable to request %s (%s) - Status: %s (%s) - Error: %s',    #
            $uri,                                                         #
            $method,                                                      #
            $response->message,                                           #
            $response->code,                                              #
            ( $content || 'n/a' );                                        #
    }

    # return decoded content or as a string
    return $self->format ne 'json' ? $content : decode_json($content);
}

1;

__END__

=pod

=encoding utf-8
 
=head1 NAME

WWW::OrdnanceSurvey - Ordnance Survey API Implementation

=head2 SYNOPSIS

    # fetch data from Names API service
    my $names = WWW::OrdnanceSurvey::Names->new( api_key => $api_key );
    my $results = $names->find( query => 'London' );

    # fetch data from Places API service
    my $places = WWW::OrdnanceSurvey::Places->new( api_key => $api_key );
    my $results = $places->match( query => 'SO16' );

=head1 DESCRIPTION

A Perl implementation of the Ordnance Survey API. See L<https://apidocs.os.uk/>
for full specification and documentation.

=head1 METHODS

As defined by L<https://apidocs.os.uk/docs/os-names-endpoints> and L<https://apidocs.os.uk/docs/os-places-endpoints>
for Names and Places API respectively.

=head1 AUTHOR
 
Edward Francis, C<edwardafrancis@gmail.com>

=head1 LICENSE AND COPYRIGHT
 
This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.
 
See http://dev.perl.org/licenses/ for more information.

=cut
