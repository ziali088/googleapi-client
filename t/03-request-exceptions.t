use Test::Most;

# This test uses one of the client classes (::Files) to test
# the request method that talks to the user agent. It's pretty
# important to do that :)

use Test::Mock::Furl;
use Furl::Response;

use Google::Client;

ok my $client = Google::Client->new(access_token => 'wefjwofjwiojfoaijfoafw'), 'created client ok';

{
    $Mock_furl->mock(
        request => sub {
            return Furl::Response->new(1, 404, 'Not Found', {'content-type' => 'text/html'}, '<html><body>blah</body></html>');
        }
    );

    $Mock_furl_res->mock(
        decoded_content => sub { return '<html><body>blah</body></html>'; }
    );

    throws_ok { $client->files->_request(
      method => 'GET',
      url => 'http://www.googleapis.com/some/test/path'
    ) } qr|error decoding json|i, 'dies if response is not correct json';
}

{
    $Mock_furl->mock(
        request => sub {
            return Furl::Response->new(1, '403', 'Forbidden', {'content-type' => 'application/json'}, '{"error": "bad token"}');
        }
    );

    $Mock_furl_res->mock(decoded_content => sub { return '{"error": "bad token"}'; });
    $Mock_furl_res->mock(is_success => sub { return 0; });
    $Mock_furl_res->mock(as_string => sub { return "403 Forbidden"; });

    throws_ok { $client->files->_request(
      method => 'GET',
      url => 'http://www.googleapis.com/some/test/path'
    ) } qr|google api request failed|i, 'dies if response is not successful';
}

done_testing;
