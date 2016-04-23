package Modules::Creator2;

# module for printing out the passed objects and moving them around
# rely on the rule: the object is blessed and its class has getter, setter and the "move" action

use strict;
use warnings;
use parent ("Modules::Creator");

sub move_all {
    shift;
    my $objects = shift;
    for (@{$objects}) {
        my ($new_x, $new_y) = ($_->move());
        unless (Modules::Creator::check($new_x, $new_y, $objects, @_)) {
            $_->set_x($new_x); 
            $_->set_y($new_y);
        } else {
            $_->set_dir;
        }
    }
}

sub print_out {
    shift;
    my ($objects, $global_x, $global_y, $obstacles, $matrix) = @_;
    for my $row (0..$global_x) {
        for my $elem (0..$global_y) {
            $matrix->[$row][$elem] = " ";
        }
    }

    for (@{$objects}) {
        $matrix->[$_->get_x][$_->get_y] = "o";
    }

    for (@{$obstacles}) {
        $matrix->[$_->get_x][$_->get_y] = "*";
    }

    print "\033[2J";
    for (@{$matrix}) {
        for (@$_) {
            print "$_";
        }
        print "\n";
    }
}

1;