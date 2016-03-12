# NAME

GoogleAPI::Client

## SYNOPSIS

    use GoogleAPI::Client;

    my $api_client = GoogleAPI::Client->new(
        oauth_credentials => {
            client_secret => 'xxxx',
            client_id => 'xxxx',
            redirect_uri => 'http://yourapp.com/oauth-callback-uri',
        },
        scopes => ['your', 'desired', 'scopes']
    );

## DESCRIPTION

A base client used to connect to the many resources of [Googles REST API](https://developers.google.com/google-apps/products).
All subclasses can be found in CPAN under the 'GoogleAPI::Client' namespace (eg GoogleAPI::Client::File).

Requests to Googles API require authentication, which this module handles via [Google::OAuth2::Client::Simple](thttps://metacpan.org/pod/Google::OAuth2::Client::Simple).

## hook: before request

Hook that checks if an access token is available before
making API requests. Will die with error if not found.

## request(%req)

Performs a request with the given parameters. These should be the same parameters
accepted by [Furl::request](https://metacpan.org/pod/Furl). Returns the responses
JSON.

Will add an Authorization header with the access\_token attributes value to the request.

Can die with an error if the response code was not a successful one, or if there was
an error decoding the JSON data.
