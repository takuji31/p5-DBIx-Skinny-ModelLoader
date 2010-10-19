use t::Utils;
use Test::More;

use TestDB;
use TestModel;

model->_setup_test_db;

my $mock = model('Mock');

isa_ok $mock,'TestModel';
