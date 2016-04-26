#!/usr/bin/perl

use strict;
use warnings;

my $dict = '/etc/dictionaries-common/words';
open( my $fh, "<", $dict ) or die "Cannot open a file $dict: $!\n";

print "Enter the word for search:\nNote: the search is case insensitive\n\n";
while (<>) {
    chomp;
    my ( $word, $found, $count ) = (lc);
    seek ($fh, 0, 0);

    while (<$fh>) {
        chomp;
        $count++;
        if ( lc eq $word ) {
            print "Found $_ at line $count\n";    
            $found++;
            last;
        }
    }
    if (!$found) {
        print "No matches found!\n";    
    }
    print "\nTry again:\n";
} 