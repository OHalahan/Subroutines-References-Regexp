#!/usr/bin/perl

use strict;
use warnings;

# Create a table of cells and a couple of entities, which change their position from one cell to another. 
# The positions are changed every second. During each pass the entity randomly chooses one of eight 
# neighbour cells to move toward. The entity should not change a cell if choosed cell is occupied by another 
# instance or if it is placed out of table. You should use OOP paradigm to realize the task. 
# The table and instances should be printed to STDOUT.

my @obj;
my ($global_x, $global_y, $count) = (20, 20, 20);

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);
    $self->init();
    push @obj, $self;
    return $self;
}

sub init {
    my $self = shift;
    $self->{x} = int rand $global_x;
    $self->{y} = int rand $global_y;
}

sub print_coord {
    my $self = shift;
    print "$self->{x} - $self->{y}\n";
}

sub print_coord_all {
    for (@obj) {
        $_->print_coord();
    }
}

sub print_points_all {
    my $matrix;
    for my $rows (0..$global_x) {
        for my $elem (0..$global_y) {
            $matrix->[$rows][$elem] = ".";
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

sub check {
    my $self = $shift;
    for (@obj) {
        if ((abs($self->{x} - $_->{x}) > 1) and (abs($self->{y} - $_->{y}) > 1)) {return 0;}
        elsif ($self eq $_ ) {return 0;}
        else {return 1;}
    }
}



#for (1..$count) { main->new };
#main::print_points_all();