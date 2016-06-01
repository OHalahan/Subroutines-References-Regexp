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
            $matrix->[$i][$j] = sprintf( "%.3f", rand($p) );
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
    my $avg = sprintf( "%.3f", ($sum/@sorted) );
    my $min = sprintf( "%.3f", shift @sorted );
    my $max = sprintf( "%.3f", pop @sorted );

    return ($min, $max, $avg);
}

sub print_matrix ($@) {
    my ( $reference, $min, $max, $avg ) = @_;
    for my $array ( @{$reference} ) {
        for ( @{$array} ) {
            print pack '(A10)*', split '-->', $_;
        }
        print "\n";
    }
    print "\nminimum value is: $min\n";
    print "maximum value is: $max\n";
    print "average value is: $avg\n";
}
