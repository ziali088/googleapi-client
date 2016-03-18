# NAME

Google::Client

# SYNOPSIS

    use Google::Client;

    my $google = Google::Client->new(
        access_token => 'XXXXX'
    );

    # eg: use a Google::Client::Files client:
    my $json = $google->files->list(); # lists all files available by calling: GET https://www.googleapis.com/drive/v3/files

# DESCRIPTION

A compilation of Google::Client::\* clients used to connect to the many resources of [Googles REST API](https://developers.google.com/google-apps/products).
All such clients can be found in CPAN under the 'Google::Client' namespace (eg Google::Client::Files).

You should only ever have to instantiate `Google::Client`, which will give you access to all the available REST clients (pull requests welcome to add more!).

Requests to Googles API require authentication, which can be handled via [Google::OAuth2::Client::Simple](https://metacpan.org/pod/Google::OAuth2::Client::Simple).

Also, make sure you request the right scopes from the user during authentication before using a client, as you will get unauthorized errors from Google (expected).

## files

A [Google::Client::Files](https://metacpan.org/pod/Google::Client::Files) client.

# AUTHOR

Ali Zia, `<ziali088@gmail.com>`

# REPOSITORY

https://github.com/ziali088/googleapi-client

# COPYRIGHT AND LICENSE

This is free software. You may use it and distribute it under the same terms as Perl itself.
Copyright (C) 2016 - Ali Zia
