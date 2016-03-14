use Test::Most;
use Test::Mock::Furl;
use Furl::Response;
use_ok('Google::Client');

ok my $client = Google::Client->new(
    access_token => 'bogey access token'
), 'ok built client';

{
    $Mock_furl->mock(
        request => sub {
            return Furl::Response->new(1, 200, 'OK', {'content-type' => 'application/json'}, '{}');
        }
    );

    $Mock_furl_res->mock(
        decoded_content => sub { return '{}'; }
    );

    ok my $json = $client->files->get(8), 'can request to get file by fileId';
}
done_testing;
