use Test::Most;
use Test::Mock::Furl;
use Furl::Response;
use CHI;
use Path::Tiny;
use Google::Client::Collection;

my $content = path('./t/files/file-resource-object.json')->slurp;

my $chi = CHI->new(driver => 'Memory', global => 0);
$chi->set('file-client', 'test-access-token', 5);
ok my $client = Google::Client::Collection->new(
    cache => $chi,
), 'ok built client';
$client->set_cache_key('file-client');

{
    $Mock_furl->mock(
        request => sub {
            return Furl::Response->new(1, 200, 'OK', {'content-type' => 'application/json'}, $content);
        }
    );

    $Mock_furl_res->mock(
        decoded_content => sub { return $content; }
    );

    ok my $json = $client->files->copy(1234, {}, {}), 'can request to copy files';
    ok $json->{id}, 'can read "id" field from response';
}
done_testing;
