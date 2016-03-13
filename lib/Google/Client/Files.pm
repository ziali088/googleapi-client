package Google::Client::Files;

use Moo;
extends 'Google::Client';

use Carp;
use Cpanel::JSON::XS;
use Furl;

has base_url => (
    is => 'ro',
    default => 'https://www.googleapis.com/drive/v3/files'
);

has access_token => (is => 'rw');

has ua => (
    is => 'ro',
    default => sub { return Furl->new(); }
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
        content => encode_json($content)
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
        content => encode_json($content)
    );
    return $json;
}

sub delete {
    my ($self, $id) = @_;
    Carp::confess("No ID provided") unless ($id);
    my $url = $self->_url("/$id");
    $self->_request(
        method => 'DELETE',
        url => $url
    );
    return 1;
}

sub empty_trash {
    my ($self) = @_;
    $self->_request(
        method => 'DELETE',
        url => $self->_url('/trash')
    );
    return 1;
}

sub export {
    my ($self, $id, $params) = @_;
    Carp::confess("No ID provided") unless ($id);
    Carp::confess("mimeType is a required param to export files") unless ($params->{mimeType});
    my $url = $self->_url("/$id/export", $params);
    my $json = $self->_request(
        method => 'GET',
        url => $url
    );
    return $json;
}

sub generate_ids {
    my ($self, $params) = @_;
    my $url = $self->_url('/generateIds', $params);
    my $json = $self->_request(
        method => 'GET',
        url => $url
    );
    return $json;
}

sub get {
    my ($self, $id, $params) = @_;
    Carp::confess("No ID provided") unless ($id);
    my $url = $self->_url("/$id", $params);
    my $json = $self->_request(
        method => 'GET',
        url => $url
    );
}

sub list {
    my ($self, $params) = @_;
    my $url = $self->_url(undef, $params);
    my $json = $self->_request(
        method => 'GET',
        url => $url
    );
    return $json;
}

sub update_media {
    my ($self, $id, $params, $content) = @_;
    Carp::confess("No ID provided") unless ($id);
    unless ( $content && %$content ) {
        Carp::confess("No content provided to update");
    }
    my $url = $self->_url("/upload/drive/v3/files/$id", $params);
    my $json = $self->_request(
        method => 'PATCH',
        url => $url,
        content => encode_json($content)
    );
    return $json;
}

sub update {
    my ($self, $id, $params, $content) = @_;
    Carp::confess("No ID provided") unless ($id);
    unless ( $content && %$content ) {
        Carp::confess("No content provided to update");
    }
    my $url = $self->_url("/$id", $params);
    my $json = $self->_request(
        method => 'PATCH',
        url => $url,
        content => encode_json($content)
    );
    return $json;
}

sub watch {
    my ($self, $id, $params, $content) = @_;
    Carp::confess("No ID provided") unless ($id);
    my $url = $self->_url("/$id/watch", $params);
    $content = $content ? encode_json($content) : undef;
    my $json = $self->_request(
        method => 'POST',
        url => $url,
        content => $content
    );
    return $json;
}

1;
