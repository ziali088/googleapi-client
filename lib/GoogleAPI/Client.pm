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
Before a request is made, a check is performed to see if we have a valid access token in a CHI::Driver. If we don't, the request will through an error.
However, if the access type requested from Google is 'offline', a refresh token request will be made before the request to the resource and the new access token will be set.

=cut

use Carp;
use CHI;
use Furl;
use Google::OAuth2::Client::Simple;
use Moo;

# Available Google REST APIs
use GoogleAPI::Client::Files;

has ua => (
    is => 'ro',
    default => sub { return Furl->new(); }
);

has chi => (
    is => 'ro',
    isa => sub { Carp::confess('chi must be an instance of CHI::Driver') unless $_[0]->isa('CHI::Driver'); },
    default => sub {
        return CHI->new(driver => 'Memory', global => 1);
    }
);

has access_token_key => (
    is => 'ro',
    lazy => 1,
    default => sub {
        return __PACKAGE__.'-access-token-'.$_[0]->oauth_credentials->{client_id};
    }
);

has refresh_token_key => (
    is => 'ro',
    lazy => 1,
    default => sub {
        return __PACKAGE__.'-refresh-token-'.$_[0]->oauth_credentials->{client_id};
    }
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

Hook that checks if an access token is available in the CHI
before making any API request. Will attempt to refresh the
access token if a refresh token exists in CHI with a key
of C<refresh_token_key>, otherwise will die with error
if not found.

=cut

before request => sub {
    my $self = shift;
    my $access_token = $self->chi->get($self->access_token_key);
    my $refresh_token = $self->chi->get($self->refresh_token_key);

    unless ( $access_token ) {
        if ( $refresh_token ) {
            my $token_ref = $self->oauth->refresh_token($refresh_token);
            if ( $token_ref ) {
                $self->chi->set(
                    $self->access_token_key,
                    $token_ref->{access_token},
                    { expires_in => $token_ref->{expires_in}, expires_variance => 0.25 }
                );
            }
        }
        else {
            Carp::confess('access token expired in chi and cannot refresh');
        }
    }
};

sub request {
    my ($self, %req) = @_;

    $req{headers} = ['Authorization', $self->chi->get($self->access_token_key)];
    my $response = $self->ua->request(%req);

    return JSON::from_json($response->decoded_content);
}

1;
