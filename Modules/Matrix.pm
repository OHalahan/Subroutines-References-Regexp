package Modules::Matrix;

use strict;
use Exporter;

our @ISA = ("Exporter");
our @EXPORT = qw(&generate &min_max_avg &print_matrix);

sub generate ( $$$ ) {
    my ( $y, $x, $p ) = @_;
    my $matrix;
    for my $i ( 0 .. $y ) {
        for my $j ( 0 .. $x ) {
            $matrix->[$i][$j] = rand($p);
        }
    }
    return $matrix;
}

sub min_max_avg ($) {
    my $array = shift;
    my ( $sum, @sorted ) = ( 0, () );
    for my $elem ( @{$array} ) {
        for my $val ( @{$elem} ) {
            push( @sorted, $val );
            $sum += $val;
        }
    }
    @sorted = sort { $a <=> $b } @sorted;
    my $avg = ($sum/@sorted);
    my $min = shift @sorted;
    my $max = pop @sorted;
    return ($min, $max, $avg);
}

sub print_matrix ($@) {
    my ( $reference, $min, $max, $avg ) = @_;
    for my $array (@{$reference}) {
        print "@{$array}\n";
    }
    print "\nminimum value is: $min\n";
    print "maximum value is: $max\n";
    print "average value is: $avg\n";
}
