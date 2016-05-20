#!/usr/bin/perl

use strict;
use warnings;

open(my $fh, "<", 'data.csv') or die "$!\n";
open(my $fh2, "<", 'import.csv') or die "$!\n";

my @existing_data = <$fh>;
my @uploading_data = <$fh2>;
my (%uploading_hash, %existing_hash);

shift @uploading_data;
chomp(@existing_data);
chomp(@uploading_data);

$existing_hash{$_} = "0" for @existing_data;

# form hash of anonymous hashes from import.csv
for (@uploading_data) {
    my @line = split(',', $_);
    my $code = $line[1];
    my $prefix = $line[2];
    my $country = $line[4];
    next unless ($code and $prefix);
    $uploading_hash{$prefix}{$code} = $country;
}

# print out if there is no such prefix in DB
for my $prefixes ( keys %uploading_hash ) {
    if ( defined ($existing_hash{$prefixes})) {
        next;
    } else {
        print "\n$prefixes: \n";
        for ( keys %{ $uploading_hash{$prefixes} } ) {
            print "$_ = $uploading_hash{$prefixes}{$_} \n";
        }
    }
}

# summarize
print "\n=====Summary=====";
for my $prefixes ( keys %uploading_hash ) {
    if ( defined ($existing_hash{$prefixes})) {
        next;
    } else {
        print "\nPrefix: $prefixes\n";
        print ("Total: ". scalar(keys $uploading_hash{$prefixes}) ."\n");
    }
}
