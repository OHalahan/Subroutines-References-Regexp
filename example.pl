#!/usr/bin/perl

#============ About =================
#
# A simple book tracking program.
#
#====================================

use strict;
use warnings;
use feature "switch";

{
    my $counter = 0;
    sub gen_id { return $counter++; }
}


sub prompt () {
    print "\n\nChoose an action:\n\t> (l)oad <file>\n\t> (s)earch [<pattern>]\n\t> (a)dd a book\n\t> (d)elete a book <pattern>\n\t> (p)rint database entries\n\t> (S)ave database <filename>\n\t> (e)xit\n";
}


sub find_in_hash {
    my $args = shift;
    my @res_uids;
    for my $uid ( sort { $a <=> $b } keys( %{$args->{store}} ) ) {
        if ( $args->{store}{$uid}{$args->{strategy}} =~ $args->{pattern} ) {
            &print_db_entry( { 'store' => $args->{store}, 'uid' => $uid } );;
            push(@res_uids, $uid);
        }
    }
    return @res_uids;
}


sub search () {
    my $args = shift;
    if ( ! $args->{pattern} ) {
        print "A pattern has not been specified...\nChoose a search strategy:\n> (1) by Title\n> (2) by Author\n> (3) by Section\n> (4) by shelf number\n> (5) by holder\n";
        given (<STDIN>) {
            print "Enter a pattern: ";
            my $pattern = <STDIN>;
            chomp $pattern;
            when (/1/) { &find_in_hash( { 'store' => $args->{store}, 'strategy' => 'title', 'pattern' => $pattern } ); }
            when (/2/) { &find_in_hash( { 'store' => $args->{store}, 'strategy' => 'author', 'pattern' => $pattern } ); }
            when (/3/) { &find_in_hash( { 'store' => $args->{store}, 'strategy' => 'section', 'pattern' => $pattern } ); }
            when (/4/) { &find_in_hash( { 'store' => $args->{store}, 'strategy' => 'shelf', 'pattern' => $pattern } ); }
            when (/5/) { &find_in_hash( { 'store' => $args->{store}, 'strategy' => 'holder', 'pattern' => $pattern } ); }
        }
    }
    else {
        my @uids;
        for my $strategy ( 'title', 'author', 'section', 'shelf', 'holder') {
            print "\n= = = = = = = = =\tBy $strategy\t= = = = = = = = =\n";
            my @res = &find_in_hash( { 'store' => $args->{store}, 'strategy' => $strategy, 'pattern' => $args->{pattern} } );
            if ( scalar( @res ) ) {
                @uids = ( @uids, @res );
            }
            else {
                print "\nNothing...\n";
            }
        }
        my %seen;
        my @unique_uids = grep { ! $seen{$_}++ } @uids;
        print "\nTotal: " . scalar( @unique_uids ) . " items matched\n";
    }
}


sub add_book () {
    my ( $args ) = @_;
    print "\nEnter a book name: "; my $title = <STDIN>; chomp $title;
    print "\nEnter an author name:"; my $author = <STDIN>; chomp $author;
    print "\nEnter a section: "; my $section = <STDIN>; chomp $section;
    print "\nEnter a shelf number: "; my $shelf = <STDIN>; chomp $shelf;
    print "\nWhom this book was given to: "; my $holder = <STDIN>; chomp $holder;
    $args->{&gen_id} = {'title' => $title, 'author' => $author, 'section' => $section, 'shelf' => $shelf, 'holder' => $holder};
}


sub delete_book () {
    my $args = shift;
    my @uids_to_delete;
    for my $strategy ( 'title', 'author', 'section', 'shelf', 'holder') {
        my @res = &find_in_hash( { 'store' => $args->{store}, 'strategy' => $strategy, 'pattern' => $args->{pattern} } );
        @uids_to_delete = ( @uids_to_delete, @res ) if scalar( @res );
    }
    print "\n" . scalar( @uids_to_delete ) . " items to delete\n\n";
    for my $uid ( @uids_to_delete ) {
        print "Delete a book with UID $uid? (y)es/(n)o: ";
        my $decision = <STDIN>;
        chomp $decision;
        if ( $decision =~ 'y|Y' ) {
            delete $args->{store}{$uid};
            print "\tDone\n";
        }
        else {
            print "\tSkipped\n";
        }
    }
}


sub load_db {
    my ( $args ) = @_;
    if ( ! open (my $fh, '<', $args->{fname} ) ) {
        print "Can not open " . $args->{fname} . "\n";
    }
    else {
        my ( $title, $author, $section, $shelf, $holder );
        while (<$fh>) {
            chomp;
            if ( /^Title/ ) { s/^Title:\s//; $title = $_; }
            elsif ( /^Author/ ) { s/^Author:\s//; $author = $_; }
            elsif ( /^Section/ ) { s/^Section:\s//; $section = $_; }
            elsif ( /^Shelf/ ) { s/^Shelf:\s//; $shelf = $_; }
            elsif ( /^On\sHands/ ) { s/^On\sHands:\s//; $holder = $_; }
            elsif ( /^$/ and ($title or $author)) {
                $args->{store}{&gen_id} = {'title' => $title, 'author' => $author, 'section' => $section, 'shelf' => $shelf, 'holder' => $holder};
                ( $title, $author, $section, $shelf, $holder ) = ('','','','','');
            }
        }
        print "\nDone.\n\n";
    }
}


sub print_db_entry {
    my $args = shift;
    print "\nUID: $args->{uid}"
        . "\n\tTitle: " . $args->{store}{$args->{uid}}{title}
        . "\n\tAuthor " . $args->{store}{$args->{uid}}{author}
        . "\n\tSection " . $args->{store}{$args->{uid}}{section}
        . "\n\tShelf " . $args->{store}{$args->{uid}}{shelf}
        . "\n\tOn hands: " . $args->{store}{$args->{uid}}{holder} . "\n";
}


sub print_db {
    my $args = shift;
    my @uids = keys (%$args);
    for my $uid ( sort {$a <=> $b} @uids ) {
        &print_db_entry( { 'store' => $args, 'uid' => $uid } );
    }
    print "\nTotal: " . scalar( @uids ) . " items\n";
}


sub save_db {
    my $args = shift;
    if ( ! $args->{fname} ) {
        print "A file name has not been specified...\n";
    }
    elsif ( -e $args->{fname} ) {
        print "File $args->{fname} exists!\n";
    }
    elsif ( open( my $fh, ">", $args->{fname} ) ) {        
        for my $uid ( keys (%{$args->{store}}) ) {
            print $fh ("\nTitle: " . $args->{store}{$uid}{title}
                . "\nAuthor: " . $args->{store}{$uid}{author}
                . "\nSection: " . $args->{store}{$uid}{section}
                . "\nShelf: " . $args->{store}{$uid}{shelf}
                . "\nOn hands: " . $args->{store}{$uid}{holder} . "\n\n");
        }
        print "\nDone!\n\n";
        close $fh;
    }
    else {
        print "Can not open a file $args->{fname}\n";
    }

}


my %book_db;
for (&prompt;<STDIN>;&prompt) {
    chomp;
    given ($_) {
        when (/^e|^exit/) { print "Bye!\n\n"; exit; }
        when (/^l\b|^load\b/) {
            print "Loading database...\n";
            s/^\w+?\s//;
            load_db( { 'store' => \%book_db, 'fname' => $_ } );
        }
        when (/^a|^add/) { &add_book( \%book_db ); }
        when (/^d|^delete/) {
            if (/^d\s|^delete\s/) { s/^\w+?\s//; } else { s/^\w+?//; };
            &delete_book( { 'store' => \%book_db, 'pattern' => $_ } );
        }
        when (/^s|^search/) {
            if (/^s\s|^search\s/) { s/^\w+?\s//; } else { s/^\w+?//; };
            &search( { 'store' => \%book_db, 'pattern' => $_ } );
        }
        when (/^p|^print/) { &print_db( \%book_db ); }
        when (/^S|^Save/) {
            if (/^S\s|^Save\s/) { s/^\w+?\s//; } else { s/^\w+?//; };
            &save_db( { 'store' => \%book_db, 'fname' => $_ } );
        }
    }
}
