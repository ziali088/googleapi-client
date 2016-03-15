use Test::Most;

use_ok('Google::Client::Files');
can_ok(
    'Google::Client::Files',
    qw/
    copy
    create
    create_media
    delete
    empty_trash
    export
    generate_ids
    get
    list
    update
    update_media
    watch
    /
);

done_testing;
