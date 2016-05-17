#!/usr/bin/perl

use strict;
use warnings;

use v5.10;

package Person;

use Moose;

has 'name'  => ( is => 'ro', isa => 'Str' );
has 'age'   => ( is => 'rw', isa => 'Int' );
has 'email' => ( is => 'rw', isa => 'Str' );

sub printInfo {
    my ($self) = @_;

    say $self->name;
    say $self->age;
    say $self->email;
}

#__PACKAGE__->make_imutable;

package main;

my $betty = Person->new({ name => 'Betty', age => 10, email => 'betty@mail.com' });
my $mary = Person->new({ name => 'Mary', age => 12, email => 'mary@mail.com' });

$betty->printInfo;

say "";

$mary->printInfo;
