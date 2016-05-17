#!/usr/bin/perl

use strict;
use warnings;

use v5.10;

package Person;

use Class::Std;

{
    my %name_of  :ATTR( :init_arg<name> :get<name> );
    my %age_of   :ATTR( :init_arg<age> :get<age> );
    my %email_of :ATTR( :init_arg<email> :get<email> );
}

sub printInfo {
    my ($self) = @_;

    say $self->get_name;
    say $self->get_age;
    say $self->get_email;
}

package main;

my $betty = Person->new({
     name => 'Betty', age => 10, email => 'betty@mail.com'
 });

my $mary = Person->new({
    name => 'Mary', age => 12, email => 'mary@mail.com'
  });


$betty->printInfo;

say "";

$mary->printInfo;
