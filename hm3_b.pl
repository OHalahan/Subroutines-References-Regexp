#!/usr/bin/perl

use strict;
use warnings;

my $dict = "/etc/dictionaries-common/words";
my %full_dict;
my $count = 1;

open (my $fh, "<", $dict) or die "Cannot open a file $dict\n";
while (<$fh>) {
    chomp;
    $full_dict{$_} = $count++;
}

while (<>) {
    chomp;
    $full_dict{$_} ? ( print "Found $_ at $full_dict{$_}\n" ) : ( print "No matches found for $_\n" );
} 