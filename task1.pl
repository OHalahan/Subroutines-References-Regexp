#!/usr/bin/perl

use strict;
use warnings;

my $dictionary = '/etc/dictionaries-common/words';
my $count      = 0;

open ( my $file, "<", $dictionary ) or die "Cannot open a file $dictionary: $!\n";

while (<$file>) {
    chomp;
    if ( length($_) >= 15 ) {
        $count++;
    }
}
print "$count\n";