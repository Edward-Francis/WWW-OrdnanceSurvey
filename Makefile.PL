use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'         => 'WWW::OrdnanceSurvey',
    'VERSION_FROM' => 'lib/WWW/OrdnanceSurvey.pm',
    'PREREQ_PM'    => {
        Carp                 => 0,
        constant             => 0,
        Cpanel::JSON::XS     => 0,
        ExtUtils::MakeMaker  => 0,
        LWP::UserAgent       => 0,
        Moo::Role            => 0,
        Moo                  => 0,
        namespace::autoclean => 0,
        Test::DistManifest   => 0,
        Test::More           => 0,
        Test::Perl::Critic   => 0,
        Test::Pod            => 0,
        URI::QueryParam      => 0,
        URI                  => 0,
    },
);

