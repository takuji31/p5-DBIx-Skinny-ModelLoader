package DBIx::Skinny::ModelLoader;
use strict;
use warnings;
our $VERSION = '0.01';
use base qw/Class::Data::Inheritable DBIx::Skinny/;

sub call_method {
    my $class     = shift;
    my $method    = shift;
    my $tablename = shift;
    $class->$method(@_);
}

sub import {
    my $class  = shift;
    my $caller = caller;
    my @args   = @_;

    if ( scalar @args >= 2 && @args[0] eq '-base' ) {
        {
            no strict 'refs';
            push @{"$caller\::ISA"},$class;
        }
        $caller->mk_classdata('skinny');
        my @functions
            = qw/insert create bulk_insert  update delete find_or_create find_or_insert search search_rs single count data2itr find_or_new/;
        for my $function ($functions) {
            *{"$caller\::$function"} = sub {
                my $class = shift;
                call_method($class,@_);
            }
        }
    }

}

sub guess_package_name {

}

sub AUTOLOAD {
    our $AUTOLOAD;
    my $method = $AUTOLOAD;
    $method =~ s/.*:://;
    $self->skinny->$method(@_);
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
