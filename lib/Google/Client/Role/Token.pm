package Google::Client::Role::Token;

use strict;
use warnings;

use Moo::Role;

has access_token => (is => 'rw');

=head1 NAME

Google::Client::Role::Token

=head2 DESCRIPTION

A role that provides access token attrs/methods for Google::Client::* modules.

=head1 AUTHOR

Ali Zia, C<< <ziali088@gmail.com> >>

=head1 REPOSITORY

https://github.com/ziali088/googleapi-clienat

=head1 COPYRIGHT AND LICENSE

This is free software. You may use it and distribute it under the same terms as Perl itself.
Copyright (C) 2016 - Ali Zia

=cut

1;
