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
my ($plain_text, $tag, %words, %tags);

while (<$fh>) {
    my @row;
    chomp($tag = $_);
    #disting tags (opening/closing) from plain text
    ($plain_text = $tag) =~ s/<[^>]*>//gs;
    #create hash: word => count
    $words{lc($&)}++ while ($plain_text =~ m/\b[a-z]+\b/igs);

    $tags{lc($&)}++ while ($tag =~ m/<[a-z]+>?/igs);
} 

my @top_ten_words = (sort {$words{$b} <=> $words{$a}} keys %words)[0..9];
print "$_ - $words{$_}\n" for @top_ten_words;

my @top_ten_tags = (sort {$tags{$b} <=> $tags{$a}} keys %tags)[0..9];
print "$_ - $tags{$_}\n" for @top_ten_tags;
