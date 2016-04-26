#!/usr/bin/perl

use strict;
use warnings;

my $dictionary = '/etc/dictionaries-common/words';
my $count      = 0;

open ( my $file, "<", $dictionary ) or die "Cannot open a file $dictionary: $!\n";

while (<$file>) {
    chomp;
    my $word = lc;
    if ( $word eq reverse($word) ) {
        $count++;
    }
}

if ($count) {
    print "The number of polyndroms in $dictionary:\n$count\n";    
} else {
    print "No matches found\n";
}
