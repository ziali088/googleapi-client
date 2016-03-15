package Google::Client::Role::FurlAgent;

use strict;
use warnings;

use Moo::Role;

use Carp;
use Cpanel::JSON::XS;
use Furl;
use URI;

has ua => (
    is => 'ro',
    default => sub { return Furl->new(); }
);

# Hook that checks if an access token is available before
# making API requests. Will die with error if not found.

# It would be wise to store the access token in a cache
# which expires in the 'expires_in' seconds returned
# by Google with the token, that way you will know
# when to refresh it or request a new one.

before _request => sub {
    my $self = shift;

    unless ( $self->access_token ) {
        confess('access token not found or may have expired');
    }
};

# Performs a request with the given parameters. These should be the same parameters
# accepted by L<Furl::request|https://metacpan.org/pod/Furl>. Returns the responses
# JSON.
# Will add an Authorization header with the access_token attributes value to the request.
# Can die with an error if the response code was not a successful one, or if there was
# an error decoding the JSON data. For requests that do not return any content, will
# just return undef to indicate we have received no content.

sub _request {
    my ($self, %req) = @_;

    $req{headers} = ['Authorization', 'Bearer '.$self->access_token];
    my $response = $self->ua->request(%req);

    unless ( $response->is_success ) {
        confess("Google API request failed: \n\n" . $response->as_string);
    }

    return unless ( $response->decoded_content );

    my $json = eval { decode_json($response->decoded_content); };
    confess("Error decoding JSON: $@") if $@;

    return $json;
}

sub _url {
    my ($self, $uri, $params) = @_;
    $uri ||= '';
    my $url = URI->new($self->base_url . $uri);
    if ( $params ) {
        $url->query_form($params);
    }
    return $url->as_string;
}

1;
