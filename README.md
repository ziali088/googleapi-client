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

A base client used to connect to the many resources of <LGoogles REST API|https://developers.google.com/google-apps/products>.
All subclasses can be found in CPAN under the 'GoogleAPI::Client' namespace (eg GoogleAPI::Client::File).

Requests to Googles API require authentication, which this module handles via [Google::OAuth2::Client::Simple](thttps://metacpan.org/pod/Google::OAuth2::Client::Simple).
Before a request is made, a check is performed to see if we have a valid access token in a CHI::Driver. If we don't, the request will through an error.
However, if the access type requested from Google is 'offline', a refresh token request will be made before the request to the resource and the new access token will be set.
