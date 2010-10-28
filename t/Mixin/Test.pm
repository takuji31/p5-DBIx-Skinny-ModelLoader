package  t::Mixin::Test;
use strict;
use warnings;

sub register_method {
    +{
        'hello' => sub {
            my ($class, $table, $msg) = @_;
            return "Hello $table $msg";
        },
        'helloworld' => sub {
            my ($class, $msg) = @_;
            return "Hello $msg World";
        },
    };
}

1;
