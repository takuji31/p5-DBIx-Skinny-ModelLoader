use t::Utils;
use Test::More;

use TestDB;
use TestModel;

model->_setup_test_db;

my $mock = model('Mock');

my $result =  $mock->create(
    {
        id     => 1,
        name   => 'hoge',
        status => 1,
    }
);

is $result->id , 1 , 'id';
is $result->name , 'hoge' , 'id';
is $result->status , 1 , 'id';

done_testing();
