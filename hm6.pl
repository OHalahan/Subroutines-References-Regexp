#!/usr/bin/perl

# Html parser on the given html page:
# suppress html tags and print ten the most frequent word from the text of this page (excluding tags!).
# print ten the most frequent tags which is used on this page
# - ignore attributes, example:<a id="id1> and <a id="id2"> are the same tags.
# - don't count close tag, example </a>
# - but don't for self closing

use strict;
use warnings;

open ( my $fh, "<", "perl.html" ) or die "Cannot open perl.html: $!\n";
my ( $plain_text, $tag, %words, %tags );

sub print_result {
    my %passed_hash = %{ $_[0] };
    my ( $word, $left, $right ) = ( $_[1], $_[2], $_[3] );
    my @top_ten = ( sort { $passed_hash{$b} <=> $passed_hash{$a} } keys %passed_hash )[0..9];
    print "\nTop ten $word:\n";
    for ( @top_ten ) {
        print "$left$_$right - $passed_hash{$_}\n";
    }
}

while ( <$fh> ) {
    chomp ( $tag = $_ );
    #disting tags (opening/closing) from plain text
    ( $plain_text = $tag ) =~ s/<[^>]*>//gs;
    #create hash: word => count
    $words{ lc ($&) }++ while ( $plain_text =~ m/\b\w+\b/igs );
    #create hash: tag => count
    $tags{$1}++ while ( $tag =~ m/<([a-z]+)>?/igs );
}

print_result ( \%words, "words", '"', '"' );
print_result ( \%tags, "tags", "<", ">" );
