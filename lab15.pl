#!/usr/bin/perl

use strict;
use warnings;
use Fcntl qw( :flock );

my ( $pattern, @files ) = @ARGV;
my ( $reader, $writer, @kids, $pid, $row, %read );
my $regexp  = qr/$pattern/;
pipe( $reader, $writer );

my $usage = "Usage: ./lab15.pl REGEXP file1\nExample: ./lab15.pl" . ' "\b\w*op\w*\b" ' . "test\n";

if ( @ARGV < 2 ) { die $usage };

for my $file (@files) {

    my $pid = fork;
    if ($pid) { push @kids, $pid }
    else {
        close $reader;
        my %findings;
        open( my $fh, '<', $file ) or die "\n$file:\n\tCannot open a file $file: $!\n";

        while ( <$fh> ) {
            chomp;
            while ( m/($regexp)/isg ) {
                if ( $findings{$.} ) { @{ $findings{$.} }[0] .= ", $1" }
                else { push @{ $findings{$.} }, "line $.: $1" }
            }
        }
        #print what was found and identical markers
        print $writer "\n$$ $file:\n";
        if ( keys %findings ) {
            for my $row ( sort { $a <=> $b } ( keys %findings ) ) { print $writer "$$ \t@{ $findings{$row} }\n" }
        }
        else { print $writer "$$ \tNo matches found\n" }
        close $fh;
        exit 0;
    }
}

close $writer;


#form hash of anonymous arrays where key is a PID of a child;
while (<$reader>) {
    $pid = $_;
    ( $row = $pid ) =~ s/^\d+\s//gs;
    $pid =~ /(^\d+)\s/;
    if ($1) { push @{ $read{$1} }, $row; }
}

print "\nGiven regexp: $pattern\n\n";
for my $child (@kids) {
    if ( $read{$child} ) { print "@{ $read{$child} }" }
    waitpid $child, 0;
}

close $reader;
print "\nAll files were processed.\n";
