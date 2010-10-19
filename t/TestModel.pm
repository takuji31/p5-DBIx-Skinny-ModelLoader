package  TestModel;
use strict;
use warnings;

unlink './t/test.db' if -f './t/test.db';

use DBIx::Skinny::ModelLoader setup => {
    skinny => TestDB->new(
        {
            dsn             => 'dbi:SQLite:./t/test.db',
            username        => '',
            password        => '',
            connect_options => { AutoCommit => 1 },
        }
    ),
};
1;
