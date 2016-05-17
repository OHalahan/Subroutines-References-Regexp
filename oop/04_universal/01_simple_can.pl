#!/usr/bin/perl

use strict;
use warnings;

use v5.10;

####### ClassA ########

package ClassA;

sub new {
    my ($class) = @_;

    my $self = { name => undef, };

    return bless $self, $class;
}

sub can {
    my ($self, $method) = @_;

    my ($prefix, $attr) = $method =~ /^(get|set)_(.*)$/;

    if ( exists $self->{$attr} ) {
        return sub {
            my ($obj, $val) = @_;

            if ( $prefix eq "set" ) {
                $obj->{$attr} = $val
            }
            else {
                return $obj->{$attr};
            }
        };
    }

    return undef;
}

####### ClassB ########

package ClassB;

use parent -norequire, qw/ClassA/;

sub new {
    my ($class) = @_;

    my $self = $class->SUPER::new();

    $self->{age} = undef;

    return $self;
}

######## main #########

package main;

my $objA = ClassA->new;
my $objB = ClassB->new;

for my $obj ( $objA, $objB ) {

    my $method;

    if ( $method = $obj->can('set_name') ) {
        say "Class " . ref($obj) . " has got method 'set_name'";
        $obj->$method('Betty');
    }
    else {
        say "Class " . ref($obj) . " has NOT got method 'set_name'";
    }

    if ( $method = $obj->can('set_age') ) {
        say "Class " . ref($obj) . " has got method 'set_age'";
        $obj->$method(10);
    }
    else {
        say "Class " . ref($obj) . " has NOT got method 'set_age'";
    }

    if ( $method = $obj->can('get_name') ) {
        say "Class " . ref($obj) . " has got method 'get_name': " . $obj->$method;
    }
    else {
        say "Class " . ref($obj) . " has NOT got method 'get_name'";
    }

    if ( $method = $obj->can('get_age') ) {
        say "Class " . ref($obj) . " has got method 'get_age': " . $obj->$method;
    }
    else {
        say "Class " . ref($obj) . " has NOT got method 'get_age'";
    }

    say "";

}
