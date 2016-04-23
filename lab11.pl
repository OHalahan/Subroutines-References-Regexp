#!/usr/bin/perl

use strict;
use warnings;
use Modules::Dot;

# Create a table of cells and a couple of entities, which change their position from one cell to another. 
# The positions are changed every second. During each pass the entity randomly chooses one of eight 
# neighbour cells to move toward. The entity should not change a cell if choosed cell is occupied by another 
# instance or if it is placed out of table. You should use OOP paradigm to realize the task. 
# The table and instances should be printed to STDOUT.

my @obj;
my ($global_x, $global_y, $count) = (20, 40, 10);

sub check {
    my ($x, $y) = @_;

    return 1 unless (($x < $global_x) and ($x > 0) and ($y < $global_y) and ($y > 0));
    for (@obj) {
        if (($x == $_->{x}) and ($y == $_->{y})) {return 1};
    }
    return 0;
}

sub print_points_all {
    my $matrix;
    for my $row (0..$global_x) {
        for my $elem (0..$global_y) {
            $matrix->[$row][$elem] = " ";
        }
    }
    for (@obj) {
        $matrix->[$_->{x}][$_->{y}] = "x";
    }
    print "\033[2J";
    for (@$matrix) {
        for (@$_) {
            print "$_";
        }
        print "\n";
    }
}

sub move_all {
    for (@obj) {
        my ($new_x, $new_y) = ($_->move());
        unless (check($new_x, $new_y)) {$_->{x} = $new_x; $_->{y} = $new_y};
    }
}

for (1..$count) {
    push @obj, Modules::Dot->new;
}

for (;;) {
    main::move_all();
    main::print_points_all();
    select(undef, undef, undef, 0.1);
}