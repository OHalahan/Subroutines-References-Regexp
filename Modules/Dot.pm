package Modules::Dot;

use strict;
use warnings;
use feature "switch";

my ($global_x, $global_y, $count) = (20, 40, 10);

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);
    $self->init();
    return $self;
}

sub init {
    my $self = shift;
    $self->{x} = int rand $global_x;
    $self->{y} = int rand $global_y;
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