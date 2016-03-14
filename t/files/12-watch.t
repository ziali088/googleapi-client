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

    ok my $json = $client->files->watch(12, {}, { one => 'two' }), 'can request to watch a file';
}
done_testing;
