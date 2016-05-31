#!/usr/bin/perl

use strict;
use warnings;
use Modules::Matrix;

my $usage = "Usage: Enter three parameters to build matrix: X Y P\nOtherwise, three default values will be used instead: X = 5; Y = 5; P = 20\n";
my ($x, $y, $p);
my $ready;

die $usage if (@ARGV > 3);
for (@ARGV) {
    die $usage if ($_ !~ /\d/);
}

# $x and $y are counted from "0" in loops
$ARGV[0] ? ( $x = $ARGV[0] - 1 ) : ( $x = 4 );
$ARGV[1] ? ( $y = $ARGV[1] - 1 ) : ( $y = 4 );
$ARGV[2] ? ( $p = $ARGV[2] ) : ( $p = 20 );
print "X = " . ( $x+1 ) . "; Y = ".( $y+1 )."; P = $p\n";

$ready = generate( $y, $x, $p );
print_matrix( $ready, min_max_avg($ready) );
