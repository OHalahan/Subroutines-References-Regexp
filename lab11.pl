#!/usr/bin/perl

use strict;
use warnings;
use Modules::Dot;
use Modules::Creator;

# Create a table of cells and a couple of entities, which change their position from one cell to another. 
# The positions are changed every second. During each pass the entity randomly chooses one of eight 
# neighbour cells to move toward. The entity should not change a cell if choosed cell is occupied by another 
# instance or if it is placed out of table. You should use OOP paradigm to realize the task. 
# The table and instances should be printed to STDOUT.

my @obj;
my ($global_x, $global_y, $count) = (20, 40, 10);

for (1..$count) {
    push @obj, Modules::Dot->new($global_x, $global_y);
}

for (;;) {
    Modules::Creator::move_all(\@obj, $global_x, $global_y);
    Modules::Creator::print_out(\@obj, $global_x, $global_y);
    select(undef, undef, undef, 0.1);
}