package  TestModelClassName;
use strict;
use warnings;

use DBIx::Skinny::ModelLoader setup => {
    class => 'TestDB',
    conf  => {
        dsn             => 'dbi:SQLite:dbname=:memory:',
        username        => '',
        password        => '',
        connect_options => { AutoCommit => 1 },
    },
    do => q/ 
            create table mock (
                id integer,
                name text,
                status int(1) default 0,
                primary key(id)
            )
        /,
};
1;
