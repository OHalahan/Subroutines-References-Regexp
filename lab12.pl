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
my ($global_x, $global_y, $count) = (30, 60, 10);

sub gen_obst {
    my ($gl_x, $gl_y, $row_u, $row_d, $elem_l, $elem_r, $my_obst) = @_;
    for my $row (0..$gl_x) {
        for my $elem (0..$gl_y) {
            # set border in any case
            push @{$my_obst}, Modules::Dot2->new_obstacle($row, $elem) if ($elem == 0 or $row == 0 or $elem == $gl_y or $row == $gl_x);
            if (($elem > $elem_l and $elem < $elem_r) and ($row > $row_u and $row < $row_d) ) {
                push @{$my_obst}, Modules::Dot2->new_obstacle($row, $elem);  
            }
        }
    }
}

# form an array of obstacles and objects on the border
gen_obst($global_x, $global_y, 2, (4+(int rand 10)), 5, (6+(int rand 5)), \@obst);
gen_obst($global_x, $global_y, 2, 7, 9, (1+(int rand 14)), \@obst);
gen_obst($global_x, $global_y, 0, 20, 20, 23, \@obst);

#form an array of objects
for (1..$count) {
    push @obj, Modules::Dot2->new($global_x, $global_y, \@obj, \@obst);
}

for (;;) {
    Modules::Creator2::move_all(\@obj, $global_x, $global_y, \@obst);
    Modules::Creator2::print_out(\@obj, $global_x, $global_y, \@obst);
    select(undef, undef, undef, 0.06);
}