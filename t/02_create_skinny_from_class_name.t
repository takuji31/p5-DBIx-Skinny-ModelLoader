use t::Utils;
use Test::More;

use TestDB;
use TestModelClassName;

my $model = model;
isa_ok $model, 'TestDB';

my $mock = model('Mock');

isa_ok $mock, 'TestModelClassName';

done_testing();
