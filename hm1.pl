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
<<<<<<< HEAD
=======

e
>>>>>>> b92b1fba294e0c89ace5906c7175fdd9a7b4c3d0
