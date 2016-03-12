package GoogleAPI::Client;
# ABSTRACT: Google API Client

=head1 NAME

GoogleAPI::Client

=head2 SYNOPSIS

    use GoogleAPI::Client;

    my $api_client = GoogleAPI::Client->new(
        access_token => 'XXXXX'
    );

=head2 DESCRIPTION

A base client used to connect to the many resources of L<Googles REST API|https://developers.google.com/google-apps/products>.
All subclasses can be found in CPAN under the 'GoogleAPI::Client' namespace (eg GoogleAPI::Client::File).

Requests to Googles API require authentication, which can be handled via L<Google::OAuth2::Client::Simple|thttps://metacpan.org/pod/Google::OAuth2::Client::Simple>.

=cut

use Carp;
use Cpanel::JSON::XS;
use Furl;
use Moo;

# Available Google REST APIs
use GoogleAPI::Client::Files;

has access_token => (is => 'rw');

has ua => (
    is => 'ro',
    default => sub { return Furl->new(); }
);

has files => (is => 'lazy');
sub _build_files {
    return GoogleAPI::Client::Files->new();
}

=head2 hook: before request

Hook that checks if an access token is available before
making API requests. Will die with error if not found.

It would be wise to store the access token in a cache
which expires in the 'expires_in' seconds returned
by Google with the token, that way you will know
when to refresh it or request a new one.

=cut

before request => sub {
    my $self = shift;

    unless ( $self->access_token ) {
        Carp::confess('access token not found or may have expired');
    }
};

=head2 request(%req)

Performs a request with the given parameters. These should be the same parameters
accepted by L<Furl::request|https://metacpan.org/pod/Furl>. Returns the responses
JSON.

Will add an Authorization header with the access_token attributes value to the request.

Can die with an error if the response code was not a successful one, or if there was
an error decoding the JSON data.

=cut

sub request {
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

1;
