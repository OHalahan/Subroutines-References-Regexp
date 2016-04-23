#!/usr/bin/perl

use strict;
use warnings;
use feature "switch";

# Create a table of cells and a couple of entities, which change their position from one cell to another. 
# The positions are changed every second. During each pass the entity randomly chooses one of eight 
# neighbour cells to move toward. The entity should not change a cell if choosed cell is occupied by another 
# instance or if it is placed out of table. You should use OOP paradigm to realize the task. 
# The table and instances should be printed to STDOUT.

my @obj;
my ($global_x, $global_y, $count) = (20, 40, 40);

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

sub check {
    my $self = shift;
    my ($x, $y) = @_;

    return 1 unless (($x < $global_x) and ($x > 0) and ($y < $global_y));
    for (@obj) {
        if (($x == $_->{x}) and ($y == $_->{y})) {return 1};
    }
    return 0;
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
    unless ($self->check($new_x, $new_y)) {$self->{x} = $new_x; $self->{y} = $new_y}
}

sub move_all {
    for (@obj) {
        $_->move();
    }
}

for (1..40) {main->new;}

for (;;) {
    main::move_all();
    main::print_points_all();
    select(undef, undef, undef, 0.1);
}