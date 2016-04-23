package Modules::Dot2;

# module with enhanced "init" action

use strict;
use warnings;
use feature "switch";
use parent ("Modules::Dot");

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

sub init {
    my $self = shift;
    my ($gl_x, $gl_y) = @_;
    $self->{x} = int rand $gl_x;
    $self->{y} = int rand $gl_y;
    $self->{dir} = int rand 8;
}

sub set_dir {
    my $self = shift;
    $self->{dir} = int rand 8;
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
    my ($gl_x, $gl_y) = @_;
    $self->{x} = $gl_x;
    $self->{y} = $gl_y;
    $self->{dir} = int rand 8;
}

1;