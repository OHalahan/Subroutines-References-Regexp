package Modules::Dots;

# module for generating the DOT ang its direction

use strict;
use warnings;
use feature "switch";

sub new {
    my $class = shift;
    my $self = {};
    bless( $self, $class );
    $self->init(@_);
    return $self;
}

sub init {
    my $self = shift;
    my ( $gl_x, $gl_y, $objects ) = @_;
    my ( $x, $y ) = ( int rand $gl_x, int rand $gl_y );
    # check that object is created not on the another object or obstacle
    unless ( check( $x, $y, $objects, $gl_x, $gl_y ) ) {
        $self->{x} = $x;
        $self->{y} = $y;
    } else {
        $self->init(@_);
    }
}

sub check {
    my ( $x, $y, $objects, $global_x, $global_y ) = @_;
    return 1 unless ( ( $x < $global_x ) and ( $x > 0 ) and ( $y < $global_y ) and ( $y > 0 ) );
    for ( @{$objects} ) {
        if ( ( $x == $_->get_x ) and ( $y == $_->get_y ) ) {return 1};
    }
    return 0;
}

sub print_out {
    my ( $objects, $global_x, $global_y ) = @_;
    my $matrix;
    for my $row ( 0 .. $global_x ) {
        for my $elem ( 0 .. $global_y ) {
            $matrix->[$row][$elem] = " ";
        }
    }
    for ( @{$objects} ) {
        $matrix->[$_->get_x][$_->get_y] = "x";
    }
    print "\033[2J";
    for ( @{$matrix} ) {
        for ( @{$_} ) {
            print "$_";
        }
        print "\n";
    }
}

sub move_all {
    my $objects = shift;
    for ( @{$objects} ) {
        my ( $new_x, $new_y ) = ( $_->move() );
        unless ( check( $new_x, $new_y, $objects, @_ ) ) {
            $_->set_x($new_x);
            $_->set_y($new_y);
        }
    }
}

sub move {
    my $self = shift;
    my $dir = int rand 8;
    my ( $new_x, $new_y );
    given ($dir) {
        when(0) { $new_x = $self->{x}+1; $new_y = $self->{y}  ; }
        when(1) { $new_x = $self->{x}+1; $new_y = $self->{y}+1; }
        when(2) { $new_x = $self->{x}  ; $new_y = $self->{y}+1; }
        when(3) { $new_x = $self->{x}-1; $new_y = $self->{y}+1; }
        when(4) { $new_x = $self->{x}-1; $new_y = $self->{y}  ; }
        when(5) { $new_x = $self->{x}-1; $new_y = $self->{y}-1; }
        when(6) { $new_x = $self->{x}  ; $new_y = $self->{y}-1; }
        when(7) { $new_x = $self->{x}+1; $new_y = $self->{y}-1; }
    };
    return( $new_x, $new_y );
}

our $AUTOLOAD;

sub AUTOLOAD {
    my ( $self,   $arg )  = @_;
    my ( $prefix, $attr ) = $AUTOLOAD =~ /.*::(set|get)_(.*)/;
    if ( $prefix eq 'get' ) {
        return $self->{$attr};
    }
    else {
        $self->{$attr} = $arg;
    }
}

1;
