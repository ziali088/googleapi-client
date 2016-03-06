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

A base client used to connect to the many resources of <LGoogles REST API|https://developers.google.com/google-apps/products>.
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

    my $oauth_args = $self->oauth_credentials;
    $oauth_args->{scopes} = $self->scopes;

    return Google::OAuth2::Client::Simple->new(%$oauth_args, ua => $self->ua);
}

1;
