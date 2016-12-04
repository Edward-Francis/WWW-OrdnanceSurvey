package WWW::OrdnanceSurvey;

# FIXME: use which perl version?

use Moose;
use namespace::autoclean;

# IMPORTS
use URI;
use Carp;
use URI::QueryParam;
use Cpanel::JSON::XS;
use LWP::UserAgent ();

our $VERSION = '0.0';

with 'WWW::OrdnanceSurvey::API';

# CONSTANTS
use constant API_URL_BASE    => 'https://api.ordnancesurvey.co.uk';
use constant API_URL_VERSION => 'v1';

# ATTRIBUTES

has 'api_key' => ( is => 'ro', required => 1 );
has 'format'  => ( is => 'ro', default  => 'json' );

# PRIVATE ATTRIBUTES

has '_service' => ( is => 'ro', required => 1 );
has '_api_url' => ( is => 'ro', default  => API_URL_BASE );
has '_version' => ( is => 'ro', default  => API_URL_VERSION );
has '_agent'   => ( is => 'ro', default  => sub { LWP::UserAgent->new } );

# METHODS

sub perform_request {
    my ( $self, $endpoint, %args ) = @_;

    my $uri    = $self->_uri($endpoint);
    my $api    = $self->api->{ $self->_service }->{$endpoint};
    my $method = $api->{method};

    # set defaults
    $args{format} //= $self->format;
    $args{key}    //= $self->api_key;

    # add query params
    for ( sort @{ $api->{qs} }, 'key' ) {
        $uri->query_param( $_ => $args{$_} ) if defined $args{$_};
    }

    # add post data

    my $request = HTTP::Request->new( $method, $uri );

    # if ( $method eq 'POST' ) {
    #     $request->content( $args{body_params} || {} );
    #     $request->header( 'Content-Type' => 'application/json' );
    # }

    # make actual request
    my $response = $self->_agent->request($request);
    my $content  = $response->content;

    # handle errors
    if ( !$response->is_success ) {
        croak sprintf 'Unable to request %s - Status: %s (%s) - Error: %s',
            $uri,                  #
            $response->message,    #
            $response->code,       #
            ( $content || 'n/a' ); #
    }

    # return decoded content or as a string
    return $self->format ne 'json' ? $content : decode_json($content);
}

# PRIVATE METHODS

sub _uri {
    my ( $self, $endpoint ) = @_;
    my $url = sprintf '%s/%s/%s/%s/', $_[0]->_api_url, $_[0]->_service,
        $_[0]->_version, $endpoint;
    return URI->new($url);

}

1;
