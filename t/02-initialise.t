use Test::Most;

use GoogleAPI::Client;

ok my $client = GoogleAPI::Client->new(
    oauth_credentials => {
        client_id => 'client id',
        client_secret => 'big secret',
        redirect_uri => 'http://www.test.com/callback'
    },
    scopes => ['http://www.google.com/file-scope-uri']
), 'created client ok';

done_testing;
