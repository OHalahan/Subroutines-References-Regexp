#!/usr/bin/perl

use strict;
use warnings;
use Fcntl qw( :flock );

my ( $pattern, @files ) = @ARGV;
my ( $reader, $writer, @kids ) = ( undef, undef, () );
my $regexp  = qr/$pattern/;

pipe( $reader, $writer );

for my $file (@files) {
    my $pid = fork;

    if ($pid) {
        push @kids, $pid;
    }
    else {
        close $reader;
        my @findings = ();
        open( my $fh, '<', $file ) or die "\n$file:\n\tCannot open a file $file: $!\n";

        while ( <$fh> ) {
            chomp;
            while ( m/($regexp)/isg ) {
                push @findings, "line $.: $1";
            }
        }
        #print what was found and identical markers
        print $writer "\n$$ $file:\n";
        if (@findings) {
            for my $row (@findings) {
                print $writer "$$ \t$row\n";
            }
        }
        else {
            print $writer "$$ \tNo matches found\n";
        }
        close $fh;
        exit 0;
    }
}

close $writer;

my @input = <$reader>;
close $reader;

print "\nGiven regexp: $pattern\n";
for (@input) {
    print;
}

push @{ $HoA{"flintstones"} }, "wilma", "betty";

for my $child (@kids) {
    waitpid $child, 0;
}
print "\nAll files were processed.\n";
