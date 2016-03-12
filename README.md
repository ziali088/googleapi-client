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
