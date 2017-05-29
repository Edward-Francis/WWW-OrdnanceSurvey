use Test::More;
eval 'use Test::DistManifest';
plan skip_all => 'Test::DistManifest required to test MANIFEST' if $@;
manifest_ok();
done_testing;
