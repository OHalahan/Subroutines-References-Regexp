package Modules::Dot;

# module for generating the DOT ang its direction

use strict;
use warnings;
use feature "switch";

sub get_x {
    my $self = shift;
    return $self->{x};
}

sub get_y {
    my $self = shift;
    return $self->{y};
}

sub set_x {
    my $self = shift;
    $self->{x} = shift;
}

sub set_y {
    my $self = shift;
    $self->{y} = shift;
}

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);
    $self->init(@_);
    return $self;
}

sub init {
    my $self = shift;
    my ($gl_x, $gl_y) = @_;
    $self->{x} = int rand $gl_x;
    $self->{y} = int rand $gl_y;
}

sub move {
    my $self = shift;
    my $dir = int rand 8;
    my ($new_x, $new_y);
    given ($dir) {
        when(0) {$new_x = $self->{x}+1; $new_y = $self->{y}  ;}
        when(1) {$new_x = $self->{x}+1; $new_y = $self->{y}+1;}
        when(2) {$new_x = $self->{x}  ; $new_y = $self->{y}+1;}
        when(3) {$new_x = $self->{x}-1; $new_y = $self->{y}+1;}
        when(4) {$new_x = $self->{x}-1; $new_y = $self->{y}  ;}
        when(5) {$new_x = $self->{x}-1; $new_y = $self->{y}-1;}
        when(6) {$new_x = $self->{x}  ; $new_y = $self->{y}-1;}
        when(7) {$new_x = $self->{x}+1; $new_y = $self->{y}-1;}
    };
    return($new_x, $new_y);
}

1;