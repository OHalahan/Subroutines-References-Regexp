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

#local $/;
open(my $fh, "<", "perl.html");
#chomp(my @html_text = <$fh>);
my ($plain_text, $tag, @words);

while (<$fh>) {
    chomp($tag = $_);
    #disting tags (opening/closing) from plain text
    ($plain_text = $tag) =~ s/<[^>]*>//gs;
    my @row = split(' ', $plain_text);
#    print "$_\n" for @row;
    #separate words and 
    for (@row) {
        s/[[:punct:]]//g;
        push(@words, $_);
    }
} 

print "$_\n" for @words;
