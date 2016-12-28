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

    return 1;
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
 
=head1 NAME

WWW::OrdnanceSurvey

=head1 VERSION

0.1

=head2 SYNOPSIS

=head1 DESCRIPTION

=cut