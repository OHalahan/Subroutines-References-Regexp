#!/usr/bin/perl

use strict;
use warnings;

use v5.10;

####### ClassA ########

package ClassA;

sub new {
    my ($class) = @_;
    say "New class: $class";
    return bless {}, $class;
}

sub DESTROY {
    say "DESTROY of class A";
}

####### ClassB ########

package ClassB;

use base qw/ClassA/;

sub DESTROY {
    say "DESTROY of class B";
}

######## main #########

package main;

say "Begin of the program";

my $objA = ClassA->new;
my $objB = ClassB->new;

$objB = undef;
$objA = undef;

say "End of the program";