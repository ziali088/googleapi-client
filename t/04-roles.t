use Test::Most;

use Class::Load;
use Path::Tiny;

my @children = path("./lib/Google/Client")->children;

foreach my $child ( @children ) {
    next if $child->is_dir;
    my $client = "Google::Client::".$child->basename('.pm');
    my ($class_loaded, $error) = Class::Load::try_load_class($client);
    ok $class_loaded, "loaded client: $client";
    ok $client = $client->new(), 'instantiated client';
    foreach my $role (qw/Google::Client::Role::FurlAgent Google::Client::Role::Token/) {
        ok $client->does($role), "client implements $role";
    }
}

done_testing;
