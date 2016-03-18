use Test::Most;
use Test::Mock::Furl;
use Furl::Response;
use_ok('Google::Client');

my $content = '{"kind": "drive#generateIds", "space": "testest", "ids": ["some", "string", "of", "ids"]}';

ok my $client = Google::Client->new(
    access_token => 'bogey access token'
), 'ok built client';

{
    $Mock_furl->mock(
        request => sub {
            return Furl::Response->new(1, 200, 'OK', {'content-type' => 'application/json'}, $content);
        }
    );

    $Mock_furl_res->mock(
        decoded_content => sub { return $content; }
    );

    ok my $json = $client->files->generate_ids({}), 'can request to generate valid file ids';
    ok $json->{ids}, "can read as json";
}
done_testing;
