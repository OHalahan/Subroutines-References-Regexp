package Modules::Dot2;

# module with enhanced "init" action

use strict;
use warnings;
use feature "switch";
use parent ("Modules::Dot");

sub set_dir {
    my $self = shift;
    if (($self->{dir}) < 4) {
        $self->{dir} = int rand 8;
    } else {
        $self->{dir} = 1;
    }
}

sub check {
    
}

sub init {
    my $self = shift;
    my ($gl_x, $gl_y, $objects, $obstacles) = @_;
    $self->{x} = int rand $gl_x until ($self->{x} != 0);
    $self->{y} = int rand $gl_y until ($self->{y} != 0);
    $self->{dir} = int rand 8;
    for (@{$objects}) {
        if (($self->{x} == $_->get_x) and ($self->{y} == $_->get_y)) {$self->init};
    }
    for (@{$obstacles}) {
        if (($self->{x} == $_->get_x) and ($self->{y} == $_->get_y)) {$self->init};
    }    
}

sub new_obstacle {
    my $class = shift;
    my $self = {};
    bless($self, $class);
    $self->init_obstacle(@_);
    return $self;
}

sub init_obstacle {
    my $self = shift;
    my ($set_x, $set_y) = @_;
    $self->{x} = $set_x;
    $self->{y} = $set_y;
}

sub move {
    my $self = shift;
    my $dir = $self->{dir};
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