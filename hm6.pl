#!/usr/bin/perl

use strict;
use warnings;

# Html parser of the given html page:
# suppress html tags and print ten the most frequent words from a text of this page (excluding tags!).
# print ten the most frequent tags which are used on this page
# Consider tags like  <a some_parameters> and <a some_other_parameters> as equivalent. 
# Do not count close tags like </a>. This condition does not affect self closing tags.
#
# Test your script on http://en.wikipedia.org/wiki/Perl
#
# Note: you can process a previously saved on a disk html page.

open(my $fh, "<", "perl.html") or die "Cannot open perl.html: $!\n";
my ($plain_text, $tag, %words, %tags);

sub print_result {
    my %passed_hash = %{$_[0]};
    my ($word, $left, $right) = ($_[1], $_[2], $_[3]);
    my @top_ten = (sort {$passed_hash{$b} <=> $passed_hash{$a}} keys %passed_hash)[0..9];
    print "\nTop ten $word:\n";
    print "$left$_$right - $passed_hash{$_}\n" for @top_ten;
}

while (<$fh>) {
    my @row;
    chomp($tag = $_);
    #disting tags (opening/closing) from plain text
    ($plain_text = $tag) =~ s/<[^>]*>//gs;
    #create hash: word => count
    $words{lc($&)}++ while ($plain_text =~ m/\b\w+\b/igs);
    #create hash: tag => count
    my @tags_durty;
    push(@tags_durty, $&) while ($tag =~ m/<[a-z]+>?/igs);
    for (@tags_durty) {
        $tags{$&}++ while ($_ =~ m/[a-z]+/igs);
    }
} 

print_result(\%words, "words", '"', '"');
print_result(\%tags, "tags", "<", ">");