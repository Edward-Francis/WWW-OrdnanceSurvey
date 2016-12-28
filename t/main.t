use Test::More;

use WWW::OrdnanceSurvey::Names  ();
use WWW::OrdnanceSurvey::Places ();
use WWW::OrdnanceSurvey::API    ();

# TEST SETUP
my $api_key = 'TEST_API_KEY';
my $names   = WWW::OrdnanceSurvey::Names->new( api_key => $api_key );
my $places  = WWW::OrdnanceSurvey::Places->new( api_key => $api_key );

# MOO TESTS
isa_ok $names,  'WWW::OrdnanceSurvey';
isa_ok $places, 'WWW::OrdnanceSurvey';

# METHOD TESTS
can_ok $names,  keys %{ WWW::OrdnanceSurvey::API->api('opennames') };
can_ok $places, keys %{ WWW::OrdnanceSurvey::API->api('places') };

done_testing;

