package  TestDB::Schema;
use DBIx::Skinny::Schema;

install_table mock => schema {
    pk 'id';
    columns qw/ id name status /;
};
