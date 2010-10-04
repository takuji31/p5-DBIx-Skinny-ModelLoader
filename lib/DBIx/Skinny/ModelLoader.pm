package DBIx::Skinny::ModelLoader;
use strict;
use warnings;
our $VERSION = '0.01';
use base qw/Class::Data::Inheritable/;
use String::CamelCase qw/decamelize/;

sub call_method {
    my $class     = shift;
    my $method    = shift;
    my $tablename = $class->call_table_name;
    $class->skinny->$method($tablename,@_);
}

sub import {

    my $class  = shift;
    my $caller = caller;
    my @args   = @_;
    my $model = $class;

    if ( (scalar @args) >= 1 && $args[0] eq '-base' ) {
        $model = $caller;
        {
            no strict 'refs'; ##no critic
            push @{"$caller\::ISA"},$class;
        }
        $caller->mk_classdata('skinny');
        $caller->mk_classdata('call_table_name');
        my @functions
            = qw/insert create bulk_insert update delete find_or_create find_or_insert search search_rs single count data2itr find_or_new/;
        for my $function (@functions) {
            no strict 'refs'; ##no critic
            *{"$caller\::$function"} = sub {
                my $self = shift;
                $caller->call_method($function,@_);
            }
        }
    }

    {
        no strict 'refs'; ##no critic
        no warnings 'redefine'; ##no critic

        my $model_loader = sub {
            my $model_name = $_[1];
            if(defined $model_name){
                $model->call_table_name(decamelize($model_name));
            }
            return $model;
        };
        *{"${caller}\::model"} = $model_loader;
    }

}

sub AUTOLOAD {
    my $class = shift;
    our $AUTOLOAD;
    my $method = $AUTOLOAD;
    $method =~ s/.*:://;
    $class->skinny->$method(@_);
}

1;
__END__

=head1 NAME

DBIx::Skinny::ModelLoader -

=head1 SYNOPSIS

  use DBIx::Skinny::ModelLoader;

=head1 DESCRIPTION

DBIx::Skinny::ModelLoader is

=head1 AUTHOR

Nishibayashi Takuji E<lt>takuji {at} senchan.jpE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
