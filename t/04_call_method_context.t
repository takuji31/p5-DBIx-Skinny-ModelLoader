use t::Utils;
use Test::More;

use TestDB;
use TestModel;

model->_setup_test_db;

my $mock = model('Mock');

$mock->bulk_insert([
    {
        id     => 1,
        name   => 'hoge',
        status => 1,
    },
    {
        id     => 2,
        name   => 'fuga',
        status => 2,
    },
]);

my @result_array = model('Mock')->search({},{});
my $result_iter = model('Mock')->search({},{});

isa_ok $result_iter, 'DBIx::Skinny::Iterator','Scalar context';
isa_ok $result_array[0], 'TestDB::Row::Mock','List context';


done_testing();
