#!/usr/bin/perl

use strict;
use warnings;
use Fcntl qw( :flock );

my ( $pattern, @files ) = @ARGV;
my ( $output_file, @kids ) = ( './results.txt', () );
my $regexp  = qr/$pattern/;

my $usage = "Usage: ./lab14.pl REGEXP file1\nExample: ./lab14.pl" . ' "\b\w*op\w*\b" ' . "test\n";
if ( @ARGV < 2 ) { die $usage };

open( my $ofh, '>>', $output_file ) or die "Cannot create a file $output_file: $!\n";
print $ofh "\nGiven regexp: $pattern\n";

for my $file (@files) {
    my $pid = fork;

    if ($pid) {
        push @kids, $pid;
    }
    else {
        my %findings;
        open( my $fh, '<', $file ) or die "\n$file:\n\tCannot open a file $file: $!\n";
        #first, find matches.
        #No one knows how long it will take for this child
        #so no need to prevent others from writing at this step
        while ( <$fh> ) {
            chomp;
            while ( m/($regexp)/isg ) {
                if ( $findings{$.} ) { @{ $findings{$.} }[0] .= ", $1" }
                else { push @{ $findings{$.} }, "line $.: $1" }
            }
        }
        #print what was found
        flock( $ofh, LOCK_EX );
        print $ofh "\n$file:\n";
        if ( keys %findings ) {
            for my $row ( sort { $a <=> $b } ( keys %findings ) ) { print $ofh "\t@{ $findings{$row} }\n" }
        }
        else { print $ofh "\tNo matches found\n" }

        close $fh;
        exit 0;
    }
}

close $ofh;

for my $child (@kids) {
    waitpid $child, 0;
}
print "\nAll files were processed.\n";
