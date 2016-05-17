#!/usr/bin/perl

use strict;
use warnings;

use v5.10;

package BaseInsideOut;

{
    my %objects = ();

    sub new {
        my ($class) = @_;

        my $obj_id = _getIdent();

        $objects{$obj_id} = {};

        return bless \$obj_id, $class;
    }

    sub _getIdent { return int(rand(1_000_000)) }

    sub _ident {
        my $self = shift;
        return ${ $self };
    }

    our $AUTOLOAD;
    sub AUTOLOAD {
        my ($self, $value) = @_;

        my ($prefix, $attr) = $AUTOLOAD =~ /.*::(get|set)_(.*)/;

        if ( !$prefix ) {
            die "Method $AUTOLOAD can't be called\n";
        }
        elsif ( $prefix eq 'set' ) {
            $objects{_ident($self)}->{$attr} = $value;
        }
        else {
            return $objects{_ident($self)}->{$attr};
        }
    }

    sub DESTROY {
        my ($self) = @_;
        delete $objects{ _ident($self) };
        say "Object with ID " . _ident($self) . " has been cleaned up";
    }
}

package Person;

use parent -norequire, qw/BaseInsideOut/;

my @allowedAttrs = qw(name age email);

sub new {
    my ($class, $args) = @_;

    my $self = $class->SUPER::new();

    for my $attr ( @allowedAttrs ) {
        die "Attribute '$attr' must be specified" if ! exists $args->{$attr};
    }

    $self->set_name( $args->{name} );
    $self->set_age( $args->{age} );
    $self->set_email( $args->{email} );

    return $self;
}


package main;

my $betty = Person->new({
     name => 'Betty', age => 10, email => 'betty@mail.com'
});

my $mary = Person->new({
    name => 'Mary', age => 12, email => 'mary@mail.com'
});

say $betty->get_name;
say $betty->get_age;
say $betty->get_email;

say "";

say $mary->get_name;
say $mary->get_age;
say $mary->get_email;
