#!/usr/bin/perl

use strict;
use warnings;

my $dictionary = '/etc/dictionaries-common/words';
my $count;

open (my $file, "<", $dictionary) or die "Cannot open a file $dictionary: $!\n";

while (<$file>) {
    chomp;
    $count++ unless (length($_) < 15);
}
