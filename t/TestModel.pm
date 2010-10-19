package  TestModel;
use strict;
use warnings;

use DBIx::Skinny::ModelLoader setup => {
    skinny => TestDB->new(
        {
            dsn             => 'dbi:SQLite:dbname=:memory:',
            username        => '',
            password        => '',
            connect_options => { AutoCommit => 1 },
        }
    ),
};
1;
