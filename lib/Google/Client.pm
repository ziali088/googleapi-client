package Google::Client;
# ABSTRACT: Google Client

=head1 NAME

Google::Client

=head2 SYNOPSIS

    use Google::Client;

    my $api_client = Google::Client->new(
        access_token => 'XXXXX'
    );

=head2 DESCRIPTION

A base client used to connect to the many resources of L<Googles REST API|https://developers.google.com/google-apps/products>.
All subclasses can be found in CPAN under the 'Google::Client' namespace (eg Google::Client::File).

Requests to Googles API require authentication, which can be handled via L<Google::OAuth2::Client::Simple|https://metacpan.org/pod/Google::OAuth2::Client::Simple>.

=cut

use Carp;
use Cpanel::JSON::XS;
use Furl;
use Moo;
use URI;

# Available Google REST APIs
use Google::Client::Files;

has access_token => (is => 'rw');

has ua => (
    is => 'ro',
    default => sub { return Furl->new(); }
);

has files => (is => 'lazy');
sub _build_files {
    return Google::Client::Files->new(
        access_token => $_[0]->access_token
    );
}

# Hook that checks if an access token is available before
# making API requests. Will die with error if not found.

# It would be wise to store the access token in a cache
# which expires in the 'expires_in' seconds returned
# by Google with the token, that way you will know
# when to refresh it or request a new one.

before _request => sub {
    my $self = shift;

    unless ( $self->access_token ) {
        Carp::confess('access token not found or may have expired');
    }
};

# Performs a request with the given parameters. These should be the same parameters
# accepted by L<Furl::request|https://metacpan.org/pod/Furl>. Returns the responses
# JSON.
# Will add an Authorization header with the access_token attributes value to the request.
# Can die with an error if the response code was not a successful one, or if there was
# an error decoding the JSON data.

sub _request {
    my ($self, %req) = @_;

    $req{headers} = ['Authorization', $self->access_token];
    my $response = $self->ua->request(%req);

    unless ( $response->is_success ) {
        Carp::confess("Google API request failed: \n\n" . $response->as_string);
    }

    my $json = eval { decode_json($response->decoded_content); };
    Carp::confess("Error decoding JSON: $@") if $@;

    return $json;
}

sub _url {
    my ($self, $uri, $params) = @_;
    my $url = URI->new($self->base_url . $uri);
    if ( $params ) {
        $url->query_form($params);
    }
    return $url->as_string;
}

1;
