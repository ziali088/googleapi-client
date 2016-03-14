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

use Moo;

# Available Google REST APIs
use Google::Client::Files;

has access_token => (is => 'rw');

my $filesingleton = undef;
sub files {
    my $self = shift;
    $self->_refresh_singleton_attrs($filesingleton);
    unless ( $filesingleton ) {
        $filesingleton = Google::Client::Files->new(%{$self->_client_args});
    }
    return $filesingleton;
}

sub _refresh_singleton_attrs {
    my ($self, $singleton) = @_;
    if ( $singleton ) {
        if ( !$singleton->access_token ) {
            $singleton->access_token($self->access_token);
        }
        return $singleton;
    }
}

sub _client_args {
    my $self = shift;
    return {
        access_token => $self->access_token,
    };
}

1;
