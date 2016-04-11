#!/usr/bin/perl

use strict;
use warnings;

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