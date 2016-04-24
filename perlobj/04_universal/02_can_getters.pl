#!/usr/bin/perl

use strict;
use warnings;

use v5.10;

####### ClassA ########

package ClassA;

sub new {
    my ($class) = @_;
    my $self = bless {}, $class;
    return $self;
}

sub set_name {
    my ($self, $value) = @_;
    return $self->{name} = $value;
}

sub get_name {
    return shift->{name};
}

####### ClassB ########

package ClassB;

use parent -norequire, qw/ClassA/;

sub set_age {
    my ($self, $value) = @_;
    return $self->{age} = $value;
}

sub get_age {
    return shift->{age};
}


######## main #########

package main;

my $objA = ClassA->new;
my $objB = ClassB->new;

for my $obj ( $objA, $objB ) {

    if ( $obj->can('set_name') ) {
        say "Class " . ref($obj) . " has got method 'set_name'";
        $obj->set_name('Betty');
    }
    else {
        say "Class " . ref($obj) . " has NOT got method 'set_name'";
    }

    if ( $obj->can('set_age') ) {
        say "Class " . ref($obj) . " has got method 'set_age'";
        $obj->set_age(10);
    }
    else {
        say "Class " . ref($obj) . " has NOT got method 'set_age'";
    }

    if ( $obj->can('get_name') ) {
        say "Class " . ref($obj) . " has got method 'get_name': " . $obj->get_name;
    }
    else {
        say "Class " . ref($obj) . " has NOT got method 'get_name'";
    }

    if ( $obj->can('get_age') ) {
        say "Class " . ref($obj) . " has got method 'get_age': " . $obj->get_age;
    }
    else {
        say "Class " . ref($obj) . " has NOT got method 'get_age'";
    }

    say "";

}
