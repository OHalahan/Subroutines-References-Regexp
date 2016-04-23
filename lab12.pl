#!/usr/bin/perl

use strict;
use warnings;
use Modules::Dot2;
use Modules::Creator2;

# Modify a program from the previous task by changing a way it prints a table of cells: 
# it should be printed with a border and each empty cell should be marked with "." 
# Add a simple obstacle(s) for entities (like a wall with a hole, etc) and mark it so that it can be visible.
# You may also modify a rule of entity movement. 
# To realize the task you should create separate modules with parent (old) class and inherited (new) class descriptions.

my (@obj, @obst);
my ($global_x, $global_y, $count) = (20, 40, 10);

#form an array of objects
for (1..$count) {
    push @obj, Modules::Dot2->new($global_x, $global_y);
}

# form an array of objects on the border
for my $row (0..$global_x) {
    for my $elem (0..$global_y) {
        push @obst, Modules::Dot2->new_obstacle($row, $elem) if ($elem == 0 or $row == 0 or $elem == $global_y or $row == $global_x);
    }
}




for (;;) {
    Modules::Creator2->move_all(\@obj, $global_x, $global_y);
    Modules::Creator2->print_out(\@obj, $global_x, $global_y, \@obst);
    select(undef, undef, undef, 0.1);
}