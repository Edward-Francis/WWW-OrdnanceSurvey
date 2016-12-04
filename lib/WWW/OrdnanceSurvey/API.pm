package WWW::OrdnanceSurvey::API;

use Moose::Role;

my %API = (

    # documentation: https://apidocs.os.uk/docs/os-names-overview
    opennames => {
        find => {
            method => 'GET',
            qs     => [qw( query format maxresults offset bounds fq )],
        },
        nearest => {
            method => 'GET',
            qs     => [qw( point radius format )],
        },
    },

);

sub api {
    my $name = $_[1] || return \%API;
    return $API{$name};
}

1;
