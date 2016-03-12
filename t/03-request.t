use Test::Most;

use Test::Mock::Furl;
use Furl::Response;

$Mock_furl->mock(
    request => sub {
        return Furl::Response->new(1, 200, 'OK', {'content-type' => 'application/json'}, '{}');
    }
);

$Mock_furl_res->mock(
    decoded_content => sub { return '{}'; }
);

use GoogleAPI::Client;

ok my $client = GoogleAPI::Client->new(
    oauth_credentials => {
        client_id => 'client id',
        client_secret => 'big secret',
        redirect_uri => 'http://www.test.com/callback'
    },
    scopes => ['http://www.google.com/file-scope-uri']
), 'created client ok';

throws_ok { $client->request(
  method => 'GET',
  url => 'http://www.googleapis.com/some/test/path'
) } qr|access token not found or may have expired|, 'dies when no access token';

$client->access_token('weaifgqirgjqpe');

lives_ok { $client->request(
    method => 'GET',
    url => 'http://www.googleapis.com/some/test/path',
) } 'lives when given access token and response is good';

done_testing;