use t::Utils;
use Test::More;

use TestDB;
use TestModel;

model->_setup_test_db;

my $mock = model('Mock');

is $mock->hello('World'), 'Hello mock World', 'call_cutstom_method';
is undef, $mock->can('helloworld'), 'not defined method';
is $mock->helloworld('Perl'), 'Hello Perl World', 'call_cutstom_method_without_tablename';
isnt undef, $mock->can('helloworld'), 'defined method';

done_testing();
