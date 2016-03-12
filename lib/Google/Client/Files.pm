package Google::Client::Files;

use Moo;
extends 'Google::Client';

use Carp;
use Cpanel::JSON::XS;

has base_url => (
    is => 'ro',
    default => 'https://www.googleapis.com/drive/v3/files'
);

sub copy {
    my ($self, $id, $params, $content) = @_;

    Carp::confess("No fileId provided") unless ($id);

    $content = $content ? encode_json($content) : undef;

    my $url = $self->_url("/$id/copy", $params);

    my $json = $self->_request(
        method => 'POST',
        url => $url,
        content => $content
    );
    return $json;
}

sub create {
    my ($self, $params, $content) = @_;
    unless ( $content && %$content ) {
        Carp::confess("No content provided to create a media upload");
    }

    my $url = $self->_url('/drive/v3/files', $params);

    my $json = $self->_request(
        method => 'POST',
        url => $url,
        content => $content
    );
    return $json;
}

sub create_media {
    my ($self, $params, $content) = @_;
    unless ( $content && %$content ) {
        Carp::confess("No content provided to create a media upload");
    }

    my $url = $self->_url('/upload/drive/v3/files', $params);

    my $json = $self->_request(
        method => 'POST',
        url => $url,
        content => $content
    );
    return $json;
}

1;
