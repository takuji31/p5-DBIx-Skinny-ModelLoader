package DBIx::Skinny::ModelLoader;
use strict;
use warnings;
use UNIVERSAL::require;
use base qw/Class::Data::Inheritable Class::Accessor::Fast/;
use String::CamelCase qw/decamelize/;

our $VERSION = '0.01';

sub new {
    my ( $class, $args ) = @_;
    bless $args, $class;
}

sub call_method {
    my $self      = shift;
    my $method    = shift;
    my $tablename = $self->_table_name;
    $self->skinny->$method( $tablename, @_ );
}

sub instance_table : lvalue {
    my $class = shift;
    my $table = $class->_instance_table;
    $table;
}

sub import {
    my $class  = shift;
    my $caller = caller;
    my @args   = @_;
    my $model  = $class;

    if ( ( scalar @args ) >= 2 && $args[0] eq 'setup' ) {
        $model = $caller;
        {
            no strict 'refs';    ##no critic
            push @{"$caller\::ISA"}, $class;
        }
        $caller->mk_classdata('skinny');
        $caller->mk_classdata(_instance_table => {});
        $caller->mk_accessors(qw/_table_name/);
        my $params = $args[1];
        if ( $params && defined $params->{skinny} ) {
            $caller->skinny( $params->{skinny} );
        }
        else {

            #Skinny setup
            my $skinny_class = $params->{class}
              or die 'Parameter skinny or class required!';
            $skinny_class->require or die "Class $skinny_class does not exists";
            my $conf = $params->{conf} || {};

            my $skinny_obj = $skinny_class->new($conf);

            #init connect
            if ( $params->{do} ) {
                $skinny_obj->do( $params->{do} );
            }
            $caller->skinny($skinny_obj);
        }
        my @functions = qw/insert create bulk_insert update delete find_or_create find_or_insert 
            search search_rs single count data2itr find_or_new/;
        for my $function (@functions) {
            no strict 'refs';    ##no critic
            *{"$caller\::$function"} = sub {
                my $self = shift;
                $self->call_method( $function, @_ );
              }
        }
    }

    {
        no strict 'refs';          ##no critic
        no warnings 'redefine';    ##no critic

        my $model_loader = sub {
            my $model_name = $_[0];
            if ($model_name) {
                my $table_name = decamelize($model_name);
                my $instance   = $model->instance_table->{$table_name};
                unless ($instance) {
                    $instance = $model->new( { _table_name => $table_name } );
                    $model->instance_table->{$table_name} = $instance;
                }
                $instance->_table_name($table_name);
                return $instance;
            }
            return $model->skinny;
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

sub DESTROY {}

1;
__END__

=head1 NAME

DBIx::Skinny::ModelLoader -

=head1 SYNOPSIS

  package Hoge::DB::Main;
  use DBIx::Skinny;

  package Hoge::Model;
  use DBIx::Skinny::ModelLoader setup => {
      skinny => container('db') # instance
  };

  package Hoge::Page::Hoge;
  use Hoge::Model;

  sub dispatch_hoge {

    #instance of Hoge::DB::Main
    my $model = model;

    #instance of Hoge::Model
    my $fuga = model('Fuga');

    #Like $model->create('user',{id => 1, name => 'hoge'});
    #returns DBIx::Skinny::Row
    my $user = model('User')->create({id => 1,name => 'hoge'});

    #Like $model->search('user',{id => 1});
    #returns DBIx::Skinny::Row
    my $login_user = model('User')->search({id => 1});

  }

=head1 DESCRIPTION

DBIx::Skinny::ModelLoader is a Model Loader for DBIx::Skinny

=head1 AUTHOR

Nishibayashi Takuji E<lt>takuji {at} senchan.jpE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
