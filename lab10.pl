#!/usr/bin/perl

use strict;
use warnings;

my $usage = "Usage: Enter three parameters to build matrix: X Y P\nOtherwise, three default values will be used instead: X = 5; Y = 5; P = 20\n";
my ($x, $y, $p);
my $ready;

die $usage if (@ARGV > 3);
for (@ARGV) {
    die $usage if ($_ !~ /\d/);
}

# $x and $y are counted from "0" in loops
$ARGV[0] ? ($x = $ARGV[0] - 1) : ($x = 4);
$ARGV[1] ? ($y = $ARGV[1] - 1) : ($y = 4);
$ARGV[2] ? ($p = $ARGV[2]) : ($p = 20);
print "X = ".($x+1)."; Y = ".($y+1)."; P = $p\n";

sub generate ($$$) {
    my $matrix;
    for my $i ( 0 .. $_[1] ) {
        for my $j ( 0 .. $_[0] ) {
            $matrix->[$i][$j] = rand($_[2]);
        }
    }
    return $matrix;
}

sub min_max_avg ($) {
    my @sorted;
    my $sum = 0;
    for (@{$_[0]}) {
        for (@{$_}) {
            push (@sorted, $_);
            $sum += $_;
        }
    }
    @sorted = sort { $a <=> $b } @sorted;
    my $avg = ($sum/@sorted);
    my $min = shift @sorted;
    my $max = pop @sorted;
    return ($min, $max, $avg);
}

sub print_matrix ($@) {
    print "@$_\n" for @{$_[0]};
    print "\nminimum value is: $_[1]\n";
    print "maximum value is: $_[2]\n";
    print "average value is: $_[3]\n";
}

$ready = generate($x, $y, $p);
print_matrix($ready, min_max_avg($ready));