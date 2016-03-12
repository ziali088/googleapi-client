# NAME

Google::Client

## SYNOPSIS

    use Google::Client;

    my $api_client = Google::Client->new(
        access_token => 'XXXXX'
    );

## DESCRIPTION

A base client used to connect to the many resources of [Googles REST API](https://developers.google.com/google-apps/products).
All subclasses can be found in CPAN under the 'Google::Client' namespace (eg Google::Client::File).

Requests to Googles API require authentication, which can be handled via [Google::OAuth2::Client::Simple](https://metacpan.org/pod/Google::OAuth2::Client::Simple).
