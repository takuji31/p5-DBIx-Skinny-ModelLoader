use t::Utils;
use Test::More;

use TestDB;
use TestModel;

model->_setup_test_db;

my $model = model;
isa_ok $model, 'TestDB';

my $mock = model('Mock');

isa_ok $mock, 'TestModel';

done_testing();
