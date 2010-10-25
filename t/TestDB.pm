package TestDB;
use strict;
use warnings;
use DBIx::Skinny;
use DBIx::Skinny::Mixin modules => ['+t::Mixin::Test'];

sub _setup_test_db {
    my $self = shift;
    $self->do(q/ 
            create table mock (
                id integer,
                name text,
                status int(1) default 0,
                primary key(id)
            )
        /);
}

1;
