#!/usr/bin/perl

use strict;
use warnings;

use v5.10;

####### ClassA ########

package ClassA;

sub new {
    my ($class) = @_;
    say "New class: A";
    my $self = bless {}, $class; # be careful with __PACKAGE__
    $self->init();
    return $self;
}

sub init {
    my ($class) = @_;
    say "Init of class A. Real class: ". ref($class);
}

sub doSomething {
    my ($self) = @_;
    say "Do action A";
    $self->doSomethingElse;
}

sub doSomethingElse {
    say "Do else action A";
}

sub DESTROY {
    say "DESTROY of class A";
}

####### ClassB ########

package ClassB;

use parent -norequire, qw/ClassA/;

sub new {
    my ($class) = @_;
    say "New class: B";
    my $self = $class->SUPER::new();
    return $self;
}

sub init {
    my ($class) = @_;
    say "Init of class B. Real class: " . ref($class);
}

sub doSomething {
    my ($self) = @_;
    $self->SUPER::doSomething();
    say "Do action B";
}

sub doSomethingElse {
    say "Do else action B";
}

sub DESTROY {
    my ($self) = @_;
    $self->SUPER::DESTROY;
    say "DESTROY of class B";
}

######## main #########

package main;

say "Begin of the program";

say "=========== Object creation =============\n";

my $objA = ClassA->new;

say "";

my $objB = ClassB->new;

say "\n============== Do action ================\n";

$objA->doSomething;

say "";

$objB->doSomething;

say "\n=========== Destroy objects =============\n";

$objB = undef;

say "";

$objA = undef;

say "";

say "End of the program";