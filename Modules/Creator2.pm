package Modules::Creator2;

# module for printing out the passed objects and moving them around
# rely on the rule: the object is blessed and its class has getter, setter and the "move" action

use strict;
use warnings;
use parent ("Modules::Creator");

sub check {
    my ($x, $y, $objects, $global_x, $global_y, $obstacles) = @_;
    return 1 unless (($x < $global_x) and ($x > 0) and ($y < $global_y) and ($y > 0));
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
        } else {
            $matrix->[$_->get_x][$_->get_y] = "Y";
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

1;