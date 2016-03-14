use Test::Most;
use Test::Mock::Furl;
use Furl::Response;
use_ok('Google::Client');

ok my $client = Google::Client->new(
    access_token => 'bogey access token'
), 'ok built client';

ok my $files = $client->files, 'got files client';

is $files->base_url, 'https://www.googleapis.com/drive/v3/files', 'file client has correct base_url';

{
    $Mock_furl->mock(
        request => sub {
            return Furl::Response->new(1, 200, 'OK', {'content-type' => 'application/json'}, '{}');
        }
    );

    $Mock_furl_res->mock(
        decoded_content => sub { return '{}'; }
    );

    ok my $json = $files->copy(1234, {}, {}), 'can request to copy files';
}
done_testing;
