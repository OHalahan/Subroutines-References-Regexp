package Modules::Dots2;

# module with enhanced "init" action

use strict;
use warnings;
use feature "switch";
use parent ("Modules::Dots");

sub check {
    my ($x, $y, $objects, $global_x, $global_y, $obstacles) = @_;
    return 1 unless (($x < $global_x) and ($x > 0) and ($y < $global_y) and ($y > 0) );
    for (@{$objects}) {
        if (($x == $_->get_x) and ($y == $_->get_y)) {return 1};
    }
    for (@{$obstacles}) {
        if (($x == $_->get_x) and ($y == $_->get_y)) {return 1};
    }
    return 0;
}

sub move_all {
    my $objects = shift;
    for (@{$objects}) {
        my ($new_x, $new_y) = ($_->move());
        unless (check($new_x, $new_y, $objects, @_)) {
            $_->set_x($new_x); 
            $_->set_y($new_y);
        } else {
            $_->set_dir;
        }
    }
}

sub print_out {
    my ($objects, $global_x, $global_y, $obstacles, $matrix) = @_;
    for my $row (0..$global_x) {
        for my $elem (0..$global_y) {
            $matrix->[$row][$elem] = " ";
        }
    }

    for (@{$obstacles}) {
        $matrix->[$_->get_x][$_->get_y] = "*";
    }

    for (@{$objects}) {
        if ($matrix->[$_->get_x][$_->get_y] eq " ") {
            $matrix->[$_->get_x][$_->get_y] = "X";    
        }         
    }

    print "\033[2J";
    for (@{$matrix}) {
        for (@$_) {
            print "$_";
        }
        print "\n";
    }
}

sub set_dir {
    my $self = shift;
    if (($self->{dir}) < 4) {
        $self->{dir} = int rand 8;
    } else {
        $self->{dir} = 1;
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