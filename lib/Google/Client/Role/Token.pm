package Google::Client::Role::Token;

use strict;
use warnings;

use Moo::Role;

has access_token => (is => 'rw');

1;
