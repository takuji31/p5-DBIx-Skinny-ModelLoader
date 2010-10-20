package TestDB;
use DBIx::Skinny;

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
