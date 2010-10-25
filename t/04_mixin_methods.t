use t::Utils;
use Test::More;

use TestDB;
use TestModel;

model->_setup_test_db;

my $mock = model('Mock');

is $mock->hello('World'), 'Hello mock World', 'call_cutstom_method';

done_testing();
