package Modules::Matrix;

use strict;
use Exporter;

our @ISA = ("Exporter");
our @EXPORT = qw(&generate &min_max_avg &print_matrix);

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