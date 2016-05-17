#!/usr/bin/perl

use strict;
use warnings;

use v5.10;

####### ClassA ########

package ClassA;

sub new {
    my ($class) = @_;
    say "New class: A";
    my $self = bless {}, $class;
    return $self;
}

our $AUTOLOAD;
sub AUTOLOAD {
    say "AUTOLOAD of class A: called - $AUTOLOAD";

    my ($self, $arg) = @_;

    my ($prefix, $attr) = $AUTOLOAD =~ /.*::(set|get)_(.*)/;

    if ( $prefix eq 'get' ) {
        return $self->{$attr};
    }
    else {
        $self->{$attr} = $arg;
    }
}

####### ClassB ########

package ClassB;

use parent -norequire, qw/ClassA/;

our $AUTOLOAD;
sub AUTOLOAD {
    say "AUTOLOAD of class B: called - $AUTOLOAD";
    my ($self, $arg) = @_;
    my ($method) = $AUTOLOAD =~ /.*::(.*)/;
    return $self->"SUPER::$method"($arg);
}

######## main #########

package main;

my $objA = ClassA->new;
my $objB = ClassB->new;

$objA->set_name('Betty');

say "Object A name: " . $objA->get_name();

$objB->set_length(10);

say "Object B length: " . $objB->get_length();
