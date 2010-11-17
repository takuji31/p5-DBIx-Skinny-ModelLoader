package DBIx::Skinny::ModelLoader;
use strict;
use warnings;
use UNIVERSAL::require;
use String::CamelCase qw/decamelize/;
use base qw/Class::Data::Inheritable/;

our $VERSION = '0.01';

sub call_method {
    my $class      = shift;
    my $method    = shift;
    my $tablename = $class->table_name;
    return $class->skinny->$method( $tablename, @_ );
}

sub import {
    my $class  = shift;
    my $caller = caller;
    my @args   = @_;
    my $model  = $class;

    #Model class setup
    if ( ( scalar @args ) >= 2 && $args[0] eq 'setup' ) {
        $model = $caller;
        {
            no strict 'refs';    ##no critic
            push @{"$caller\::ISA"}, $class;
        }
        $caller->mk_classdata('skinny');
        $caller->mk_classdata('table_name');
        $caller->mk_classdata('model_table_map' => {});
        my $params = $args[1];
        if ( $params && defined $params->{skinny} ) {
            $caller->skinny( $params->{skinny} );
        }
        else {

            #Skinny setup
            my $skinny_class = $params->{class}
                or die 'Parameter skinny or class required!';
            $skinny_class->require
                or die "Class $skinny_class does not exists";
            my $conf = $params->{conf} || {};

            my $skinny_obj = $skinny_class->new($conf);

            $caller->skinny($skinny_obj);
        }
        my @functions
            = qw/insert create bulk_insert update delete find_or_create find_or_insert
            search search_rs single count data2itr find_or_new/;
        my $methods = $params->{mixin_methods};
        if ( $params && $methods && ref($methods) eq 'ARRAY' ) {
            @functions = ( @functions, @$methods );
        }
        for my $function (@functions) {
            no strict 'refs';    ##no critic
            *{"$caller\::$function"} = sub {
                my $class = shift;
                return $class->call_method( $function, @_ );
            };
        }

        #Row Class Remap
        my $row_class_remap = $params->{row_class_remap};
        if ($row_class_remap) {
            {
                no strict 'refs';
                #export camelize function
                *{"$class\::_camelize"} = \&DBIx::Skinny::_camelize;
            }
            for my $table ( keys %{ $caller->skinny->schema->schema_info } ) {
                my $model_name = _camelize($table);
                $caller->model_table_map->{$model_name} = $table;
                my $row_class  = "$caller\::" . $model_name;
                $row_class->require or next;
                $caller->skinny->attribute->{row_class_map}->{$table}
                    = $row_class;
            }
        }
    }

    #Row class setup
    if ( ( scalar @args ) == 1 && $args[0] eq '-base' ) {
        {
            no strict 'refs';    ##no critic
            push @{"$caller\::ISA"}, 'DBIx::Skinny::Row';
        }
    }

    my $model_loader = sub {
        my $model_name = $_[0];
        if ($model_name) {
            my $table_name = $model->model_table_map->{$model_name} || decamelize($model_name);
            $model->table_name($table_name);
            return $model;
        }
        return $model->skinny;
    };
    {
        no strict 'refs';          ##no critic
        no warnings 'redefine';    ##no critic

        *{"${caller}\::model"} = $model_loader;
    }
    return;

}

sub AUTOLOAD {
    my $class = shift;
    our $AUTOLOAD;
    my $method = $AUTOLOAD;
    ( my $method_name = $method ) =~ s/.*:://;
    {
        no strict 'refs';    ##no critic
        *{$method} = sub { return shift->skinny->$method_name(@_) };
    }
    return $class->$method_name(@_);
}

sub DESTROY { }

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
