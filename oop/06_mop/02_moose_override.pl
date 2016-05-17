#!/usr/bin/perl

use strict;
use warnings;

use v5.10;

# ============ Person ==============

package Person;

use Moose;

has 'name'  => ( is => 'ro', isa => 'Str' );
has 'age'   => ( is => 'rw', isa => 'Int' );
has 'email' => ( is => 'rw', isa => 'Str' );
has 'relatives' => ( is => 'rw', isa => 'ArrayRef[Person]' );

sub printInfo {
    my ($self) = @_;

    say $self->name;
    say $self->age;
    say $self->email;
}

sub getAsHash {
    my ($self) = @_;

    return {
        name  => $self->name,
        age   => $self->age,
        email => $self->email,
    };
}

# ============ Professor ==============

package Professor;

use Moose;

extends 'Person';

has 'degree' => ( is => 'rw', isa => 'Str', required => 1 );

after 'printInfo' => sub {
    my ($self) = @_;

    say $self->degree;
};

around 'getAsHash' => sub {
    my ($orig, $self) = @_;
    my $hash = $self->$orig();
    $hash->{degree} = $self->degree;
    return $hash;
};


# ============ Student ==============

package Student;

use Moose;

extends 'Person';

has 'group' => ( is => 'rw', isa => 'Str', required => 1 );

after 'printInfo' => sub {
    my ($self) = @_;

    say $self->group;
};

around 'getAsHash' => sub {
    my ($orig, $self) = @_;
    my $hash = $self->$orig();
    $hash->{group} = $self->group;
    return $hash;
};

package main;

use Data::Dumper;

my $betty = Professor->new({
        name   => 'Betty',
        age    => 40,
        email  => 'betty@mail.com',
        degree => 'medicine',
    });


my $mary = Student->new({
        name  => 'Mary',
        age   => 19,
        email => 'mary@mail.com',
        group => 'IN-21',
    });

$betty->printInfo;

say "";

$mary->printInfo;

say "";

say Dumper($betty->getAsHash);
say Dumper($mary->getAsHash);
