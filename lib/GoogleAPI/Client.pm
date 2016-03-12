use strict;
use warnings;
package GoogleAPI::Client;
# ABSTRACT: Google API Client

=head1 NAME

GoogleAPI::Client

=head2 SYNOPSIS

    use GoogleAPI::Client;

    my $api_client = GoogleAPI::Client->new(
        oauth_credentials => {
            client_secret => 'xxxx',
            client_id => 'xxxx',
            redirect_uri => 'http://yourapp.com/oauth-callback-uri',
        },
        scopes => ['your', 'desired', 'scopes']
    );

=head2 DESCRIPTION

A base client used to connect to the many resources of L<Googles REST API|https://developers.google.com/google-apps/products>.
All subclasses can be found in CPAN under the 'GoogleAPI::Client' namespace (eg GoogleAPI::Client::File).

Requests to Googles API require authentication, which this module handles via L<Google::OAuth2::Client::Simple|thttps://metacpan.org/pod/Google::OAuth2::Client::Simple>.

=cut

use Carp;
use Cpanel::JSON::XS;
use Furl;
use Google::OAuth2::Client::Simple;
use Moo;

# Available Google REST APIs
use GoogleAPI::Client::Files;

has ua => (
    is => 'ro',
    default => sub { return Furl->new(); }
);

has access_token => (
    is => 'rw'
);

has oauth_credentials => (
    is => 'ro',
    isa => sub { Carp::confess('oauth_credentials must be a hashref') unless ref($_[0]) eq 'HASH'; },
    required => 1,
);

has scopes => (
    is => 'ro',
    isa => sub { Carp::confess('scopes must be an arrayref') unless ref($_[0]) eq 'ARRAY'; },
    required => 1,
);

has oauth => (is => 'lazy');
sub _build_oauth {
    my $self = shift;
    my $args = $self->_common_args;
    return Google::OAuth2::Client::Simple->new(%$args, ua => $self->ua);
}

has files => (is => 'lazy');
sub _build_files {
    my $self = shift;
    my $args = $self->_common_args;
    return GoogleAPI::Client::Files->new(%$args);
}

sub _common_args {
    my $self = shift;
    my $args = $self->oauth_credentials;
    $args->{scopes} = $self->scopes;
    return $args;
}

=head2 hook: before request

Hook that checks if an access token is available before
making API requests. Will die with error if not found.

=cut

before request => sub {
    my $self = shift;

    unless ( $self->access_token ) {
        Carp::confess('access token not found or may have expired');
    }
};

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
