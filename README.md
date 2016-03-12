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

Requests to Googles API require authentication, which can be handled via [Google::OAuth2::Client::Simple](thttps://metacpan.org/pod/Google::OAuth2::Client::Simple).

## hook: before request

Hook that checks if an access token is available before
making API requests. Will die with error if not found.

It would be wise to store the access token in a cache
which expires in the 'expires\_in' seconds returned
by Google with the token, that way you will know
when to refresh it or request a new one.

## request(%req)

Performs a request with the given parameters. These should be the same parameters
accepted by [Furl::request](https://metacpan.org/pod/Furl). Returns the responses
JSON.

Will add an Authorization header with the access\_token attributes value to the request.

Can die with an error if the response code was not a successful one, or if there was
an error decoding the JSON data.
