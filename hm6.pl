#!/usr/bin/perl

use strict;
use warnings;

# Html parser of the given html page:
# suppress html tags and print ten the most frequent words from a text of this page (excluding tags!).
# print ten the most frequent tags which are used on this page
# Consider tags like  <a some_parameters> and <a some_other_parameters> as equivalent. Do not count close tags like </a>. This condition does not affect self closing tags.
#
# Test your script on http://en.wikipedia.org/wiki/Perl
#
# Note: you can process a previously saved on a disk html page.

open(my $fh, "<", "perl.html");
my ($plain_text, $tag, %words);

while (<$fh>) {
    chomp($tag = $_);
    #disting tags (opening/closing) from plain text
    ($plain_text = $tag) =~ s/<[^>]*>//gs;
    my @row = split(' ', $plain_text);
    #remove punctuation; create hash: word => count
    for (@row) {
        s/[[:punct:]]//g;
        $words{$_}++ unless ($_ eq "");
    }

} 

my @top_ten = (sort {$words{$b} <=> $words{$a}} keys %words)[0..9];

#for (keys %words) {
#    print "$_ - $words{$_}\n";
#}

print "$_ - $words{$_}\n" for @top_ten;