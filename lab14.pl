#!/usr/bin/perl

use strict;
use warnings;
use Fcntl qw( :flock );

# Write a program which searches for all matches of a given pattern in a list of files. It should use a separate process for each file, i.e. to process all files simultaneously. The result should be written to a single file ./results.txt. An example:
#
# > finder.pl REGEXP file1 file2 file3 file4
#
# ./results.txt:
# Given regexp: REGEXP
# file1:
#    line  5: MATCH1, MATCH2
#    line 19: MATCH
#    ...
# file2:
#    line  9: MATCH1
# ...
#
# File order in the results may be arbitrary. Use file locking to prevent a mess in the file.

my ( $pattern, @files ) = @ARGV;
my ( $output_file, @kids ) = ( './results.txt', () );
my $regexp  = qr/$pattern/;

open( my $ofh, '>>', $output_file ) or die "Cannot create a file $output_file: $!\n";
print $ofh "\nGiven regexp: $pattern\n";

for my $file (@files) {
    my $pid = fork;

    if ($pid) {
        push @kids, $pid;
    }
    else {
        my @findings = ();
        open( my $fh, '<', $file ) or die "Cannot open a file $file: $!\n";
        #first, find matches.
        #No one knows how long it will take for this child
        #so no need to prevent others from writing at this step
        while ( <$fh> ) {
            chomp;
            while ( m/(\b\w*$regexp\w*\b)/isg ) {
                push @findings, "line $.: $1";
            }
        }
        #print what was found
        flock( $ofh, LOCK_EX );
        print $ofh "\n$file:\n";
        if (@findings) {
            for my $row (@findings) {
                print $ofh "\t$row\n";
            }
        }
        else {
            print $ofh "\tNo matches found\n";
        }

        close $fh;
        exit 0;
    }
}

close $ofh;

for my $child (@kids) {
    waitpid $child, 0;
}
print "\nAll files were processed.\n";
