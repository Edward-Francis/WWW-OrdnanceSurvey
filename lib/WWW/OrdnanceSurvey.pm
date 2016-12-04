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

# ATTRIBUTES

has 'api_key' => (
    is       => 'ro',
    required => 1,
);

has 'api_url' => (
    is      => 'ro',
    default => 'https://api.ordnancesurvey.co.uk',
);

has 'version' => (
    is      => 'ro',
    default => 'v1',
);

has 'agent' => (
    is      => 'ro',
    default => sub { LWP::UserAgent->new },
);

has 'format' => (
    is      => 'ro',
    default => 'json',
);

has 'service' => (
    is       => 'ro',
    required => 1,
);

# METHODS

sub perform_request {
    my ( $self, $endpoint, %args ) = @_;

    my $uri    = $self->_uri($endpoint);
    my $api    = $self->api->{ $self->service }->{$endpoint};
    my $method = $api->{method};

    # set defaults
    $args{format} //= $self->format;

    # add query params
    for ( @{ $api->{qs} } ) {
        $uri->query_param( $_ => $args{$_} ) if defined $args{$_};
    }

    # add api key if not added already
    $uri->query_param( key => $self->api_key );

    my $request = HTTP::Request->new( $method, $uri );

    # if ( $method eq 'POST' ) {
    #     $request->content( $args{body_params} || {} );
    #     $request->header( 'Content-Type' => 'application/json' );
    # }

    # make actual request
    my $response = $self->agent->request($request);
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
    my $url = sprintf '%s/%s/%s/%s/', $_[0]->api_url, $_[0]->service,
        $_[0]->version, $endpoint;
    return URI->new($url);

}

1;
