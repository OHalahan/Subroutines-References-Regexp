#!/usr/bin/perl

use strict;
use warnings;
use Database;

# A small library's database is stored in a file books.txt .
#
# Write a console application which manages the database.
# It prints on a terminal all possible actions and waits for a user input.
#
# load <file>        - loads the database file;
# search [<pattern>] - searches for books by a given pattern. If a patten is not specified,
# the program prints all possible search srategies and waits until a user types a number of the strategy:
# - by name
# - by author
# - ..
#
# After choosing the strategy, the program prompts "Type a criteria" then waits for a user input.
#
# add book - push a user through a dialog which prints prompts "Type book name", "Type author", etc.
# After that saves a new book to the database;
#
# delete book <pattern> - deletes books; command find books by pattern, prints all found books.
# Then prints each found book and asks delete conformation. user types action yY - delete book
# nN - skip book A - detete all books remained in a list.
#
# PATTERN examples: name=Java* author='Randal Schwartz' reader='Jimmy Fox' shelf=1 tag=XML|Python
#
# NOTES:
# Use closures for implementing iterators of found books. Use "event driven" paradigm while implementing this application.
# You may implement other action, which your program could support.

sub greeting {
    print "\nPossible actions:\nl\tload <file>\na\tadd book\nd\tdelete book <pattern>\nf\tfind book <pattern>\np\tprint books\ns\tsave books\nh\thelp\n";
    print "\nType a required action and press ENTER: ";
    return;
}

sub print_help {
    print "\n============\n";
    print "\nExamples of search patterns:\nname=Java* \nauthor='Randal Schwartz'\nreader='Jimmy Fox'\nshelf=1\nsection=XML|Python\n";
    print "\nIf a pattern is not specified, you will be prompted to choose a search strategy\n";
    print "\n============\n";
    return;
}

sub remind {
    print "You have to load database first\n";
    return;
}

sub load_database {
    my ( $book_db, $file ) = @_;
    if ( !$file ) {
        print "Enter path to the file: ";
        #chomp ( $file = <STDIN> );
        $file = 'books.txt';
    }

    if ( !$book_db ) {
        $book_db = Database->new();
    }
    else {
        print "\n\nWarning! Database is not empty.\n\nWould you like to reload database from scratch?\n";
        print "Note! previous changes will be lost\n\n";
        print "Your decision (Y/N): ";
        chomp( my $decision = <STDIN> );
        while ( $decision !~  '^(y|Y|n|N)\$' ) {
            print "\nChoose Y or N: ";
            chomp( $decision = <STDIN> );
        }
        if ( $decision =~ 'y|Y' ) {
            $book_db = Database->new();
        }
        elsif ( $decision =~ 'n|N' ) {
            print "\nOK. New file will append to the existing database\n";
        }
    }

    $book_db->load_db($file);
    if ($@) {
        print  "\n$@\n";
    } else {
        print "\nDone. Loaded " . scalar ( keys %{$book_db->get_books} ) . " books in total\n";
        return $book_db;
    }
    return;
}

sub add_book {
    my $book_db = shift;
    if ( !$book_db ) {
        $book_db = Database->new();
    }
    my ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
    print "\n\nEnter the book title: ";
    chomp( $title = <STDIN> );
    print "Enter the book's author: ";
    chomp( $author = <STDIN> );
    print "Enter a section: ";
    chomp( $section = <STDIN> );
    print "Enter a shelf: ";
    chomp( $shelf = <STDIN> );
    print "Enter name of the reader: ";
    chomp( $taken = <STDIN> );
    $book_db->add_book( title => $title, author => $author, section => $section, shelf => $shelf, taken => $taken );
    print "Book has been added to the database\n".  scalar ( keys %{$book_db->get_books} ) ." books in total\n";
    save_books($book_db);
    return;
}

sub print_book {
    my ( $book_db, @books ) = @_;
    if ( !@books ) {
        @books = keys %{ $book_db->get_books };
    }
    for my $book ( sort { $a <=> $b } @books ) {
        print "\n";
        print "ID: $book\n";
        print "Title: " . $book_db->get_books->{$book}->get_title . "\n";
        print "Author: " . $book_db->get_books->{$book}->get_author . "\n";
        print "Section: " . $book_db->get_books->{$book}->get_section . "\n";
        print "Shelf: " . $book_db->get_books->{$book}->get_shelf . "\n";
        print "On Hands: " . $book_db->get_books->{$book}->get_taken . "\n";
        print "\n";
    }
    return;
}

sub parse_pattern {
    my $pattern = shift;

}

sub search_book {
    my ( $book_db, $pattern )  = @_;
    my ( $strategy, @matched ) = ( '', () );
    if ( !$pattern ) {
        print "\n\nEnter a search strategy:\n1 - by title\n2 - by author\n3 - by section\n4 - by shelf\n5 - by person\n";
        chomp( $strategy = <STDIN> );
        while ( $strategy !~  '^(1|2|3|4|5)\$' ) {
            print "\nChoose between 1-5: ";
            chomp( $strategy = <STDIN> );
        }
        print "\nEnter a search pattern: ";
        chomp( $pattern = <STDIN> );
        if ( $strategy == 1 ) {
            $strategy = 'title';
        }
        elsif ( $strategy == 2 ) {
            $strategy = 'author';
        }
        elsif ( $strategy == 3 ) {
            $strategy = 'section';
        }
        elsif ( $strategy == 4 ) {
            $strategy = 'shelf';
        }
        elsif ( $strategy == 5 ) {
            $strategy = 'taken';
        }
    }
    else {

    }

    @matched = $book_db->search_book( $strategy, $pattern );
    if ( @matched ) {
        print "Found books:\n";
        print_book( $book_db, @matched );
        return @matched;
    }
    else {
        print "No books found using pattern: $pattern\n";
    }
    return;
}

sub delete_book {
    my $book_db = shift;
    my @books_to_delete = search_book($book_db);
    if (@books_to_delete) {
        for my $book (@books_to_delete) {
            $book_db->delete_book($book);
        }
        print "Matched books were processed. " . scalar ( keys %{$book_db->get_books} ) . " books left\n";
        save_books($book_db);
    }
    else {

    }
}

sub save_books {
    my $book_db = shift;
    print "\nWould you like to save changes? (Y/N): ";
    chomp( my $decision = <STDIN> );
    while ( $decision !~  '^(y|Y|n|N)\$' ) {
        print "\nChoose Y or N: ";
        chomp( $decision = <STDIN> );
    }
    if ( $decision =~ 'y|Y' ) {
        print "Enter path to the file for saving: ";
        chomp ( my $file = <STDIN>);
        $book_db->save_db($file);
        if ($@) {
            print "$@\n";
        }
        else {
            print "\nBooks saved!\n\n";
        }
    }
    elsif ( $decision =~ 'n|N' ) {
        print "\nOK. Returning to main menu\n";
    }
    return;
}

my $database_obj;
for ( greeting; <STDIN>; greeting ) {
    chomp;
    if ( /^l\b/ ) {
        s/^l\s*//;
        my $path = s/^\w+\s+//r;
        print "$path\n";
        $database_obj = load_database( $database_obj, $path );
    }
    elsif ( /^a\b/ ) {
        add_book($database_obj);
    }
    elsif ( /^p\b/ ) {
        !$database_obj ? remind : print_book($database_obj);
    }
    elsif ( /^d\b/ ) {
        s/^d\s*//;
        my $pattern = s/^\w+\s+//r;
        !$database_obj ? remind : delete_book( $database_obj, $pattern );
    }
    elsif ( /^f\b/ ) {
        s/^f\s*//;
        my $pattern = s/^\w+\s+//r;
        !$database_obj ? remind : search_book( $database_obj, $pattern );
    }
    elsif ( /^s\b/ ) {
        !$database_obj ? remind : save_books($database_obj);
    }
    elsif ( /^h\b/ ) {
        print_help;
    }
    else {
        print "\nYou have not entered correct pattern\nTry again...\n\n";
    }
}
