package WWW::OrdnanceSurvey::API;

use Moo::Role;

my %API = (

    # documentation: https://apidocs.os.uk/docs/os-names-overview
    opennames => {
        find => {
            endpoint => 'find',
            method => 'GET',
            qs =>
                [ 'query', 'format', 'maxresults', 'offset', 'bounds', 'fq' ],
        },
        nearest => {
            endpoint => 'nearest',
            method => 'GET',
            qs     => [ 'point', 'radius', 'format' ],
        },
    },

    # documentation: https://apidocs.os.uk/docs/os-places-overview
    places => {

        match => {
            method => 'GET',
            qs     => [
                'query',      'format',
                'maxresults', 'offset',
                'dataset',    'lr',
                'minmatch',   'matchprecision',
                'fq',         'output_srs'
            ],
        },

        find => {
            method => 'GET',
            qs     => [
                'query',      'format',
                'maxresults', 'offset',
                'dataset',    'lr',
                'minmatch',   'matchprecision',
                'fq',         'output_srs'
            ],
        },

        postcode => {
            method => 'GET',
            qs     => [
                'postcode', 'format', 'maxresults', 'offset',
                'dataset',  'lr',     'fq',         'output_srs'
            ],
        },

        uprn => {
            method => 'GET',
            qs => [ 'uprn', 'format', 'dataset', 'lr', 'fq', 'output_srs' ],
        },

        nearest => {
            method => 'GET',
            qs     => [
                'point', 'radius', 'format',     'dataset',
                'lr',    'fq',     'output_srs', 'srs',
            ],
        },

        bbox => {
            method => 'GET',
            qs     => [
                'bbox',    'format', 'maxresults', 'offset',
                'dataset', 'lr',     'fq',         'output_srs',
                'srs'
            ],
        },

        radius => {
            method => 'GET',
            qs     => [
                'point',      'radius',  'format', 'maxresults',
                'offset',     'dataset', 'lr',     'fq',
                'output_srs', 'srs'
            ],

        },

        polygon => {
            endpoint => 'addresses/polygon',
            method => 'POST',
            qs     => [
                'referencepoint', 'maxresults',
                'dataset',        'offset',
                'lr',             'fq',
                'output_srs',     'srs'
            ],
            body     => [ 'type', 'geometry' ],
        },
    },

);

sub api {
    my $name = $_[1] || return \%API;
    return $API{$name};
}

1;
