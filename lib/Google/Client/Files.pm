package Google::Client::Files;

use Moo;
extends 'Google::Client';

use Carp;
use Cpanel::JSON::XS;
use URI;

has base_url => (
    is => 'ro',
    default => 'https://www.googleapis.com/drive/v3/files'
);

sub copy {
    my ($self, $id, $params, $content) = @_;

    Carp::confess("No fileId provided") unless ($id);

    $content = $content ? encode_json($content) : undef;

    my $url = URI->new($self->base_url . '/' . $id . '/copy');
    $url->query_form($params) if ($params);

    my $json = $self->request(
        method => 'POST',
        url => $url,
        content => $content
    );
    return $json;
}

1;
