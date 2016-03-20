package Google::Client::Collection;
# ABSTRACT: Google Client Collection

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

# * Any new client should follow the singleton pattern implemented
# above so that things remain consistent. Thanks! *

# Since we are providing a single client which consists of multiple ones,
# we need to refresh the arguments of them (just access_token really)
# so that the latest value is used from the Google::Client instance.

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

=head1 NAME

Google::Client::Collection - Collection of modules to talk with Googles REST API

=head1 SYNOPSIS

    use Google::Client::Collection;

    my $google = Google::Client::Collection->new(
        access_token => 'XXXXX'
    );

    # eg: use a Google::Client::Files client:
    my $json = $google->files->list(); # lists all files available by calling: GET https://www.googleapis.com/drive/v3/files

=head1 DESCRIPTION

A compilation of Google::Client::* clients used to connect to the many resources of L<Googles REST API|https://developers.google.com/google-apps/products>.
All such clients can be found in CPAN under the 'Google::Client' namespace (eg Google::Client::Files).

Sorry for the weird collection affix, Google::Client is taken :(.

You should only ever have to instantiate C<< Google::Client::Collection >>, which will give you access to all the available REST clients (pull requests welcome to add more!).

Requests to Googles API require authentication, which can be handled via L<Google::OAuth2::Client::Simple|https://metacpan.org/pod/Google::OAuth2::Client::Simple>.

Also, make sure you request the right scopes from the user during authentication before using a client, as you will get unauthorized errors from Google (expected).

=head2 files

A L<Google::Client::Files|https://metacpan.org/pod/Google::Client::Files> client.

=head1 AUTHOR

Ali Zia, C<< <ziali088@gmail.com> >>

=head1 REPOSITORY

L<https://github.com/ziali088/googleapi-client>

=head1 COPYRIGHT AND LICENSE

This is free software. You may use it and distribute it under the same terms as Perl itself.
Copyright (C) 2016 - Ali Zia

=cut

1;
