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
    print "\nPossible actions:\nl\tload <file>\na\tadd book\nd\tdelete book\ns\tsearch book <pattern>\n";
    print "\nEnter the required action and press ENTER: ";
    return;
}

sub load_database {
    my $book_db = shift;
    print "Enter path to the file: ";
    #chomp ( my $file = <STDIN> );
    my $file         = 'books.txt';
    if ( !$book_db ) {
        $book_db = Database->new();
    }
    else {
        print "\n\nWarning! Database is not empty\n\nWould you like to reload database from scratch? (Y/N)\n";
        print "Note! previous changes will be lost\n\n";
        print "Your decision: ";
        chomp( my $decision = <STDIN> );
        if ( $decision =~ 'y|Y' ) {
            $book_db = Database->new();
        }
        elsif ( $decision =~ 'n|N' ) {
            print "\nOK. New file will append to existing one\n";
        }
        else {
            print "\nChoose Y or N\n";
            load_database($book_db);
        }
    }

    $book_db->load_db($file);
    if ( $@ ) {
        print  "\n$@\n";
        return;
    } else {
        print "\nDone. Loaded " . scalar ( keys %{$book_db->get_books} ) . " books in total\n";
        return $book_db;
    }
}

sub add_book {
    my $book_db = shift;
    if ( !$book_db ) {
        $book_db = Database->new();
    }
    my ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
    print "\n\nEnter the book title: ";
    chomp ($title = <STDIN>);
    print "Enter the book's author: ";
    chomp ($author = <STDIN>);
    print "Enter a section: ";
    chomp ($section = <STDIN>);
    print "Enter a shelf: ";
    chomp ($shelf = <STDIN>);
    print "Enter name of the reader: ";
    chomp ($taken = <STDIN>);
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

sub search_book {

    my $book_db = shift;
    my ( $strategy, $pattern, @matched ) = ( '', '', () );

    print "\n\nEnter the search strategy:\n1 - by title\n2 - by author\n3 - by section\n4 - by shelf\n5 - by person\n";
    chomp ($strategy = <STDIN>);
    print "\nEnter the search pattern: ";
    chomp ($pattern = <STDIN>);
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
    } else {
        print "You have not entered the correct pattern";
        search_book($book_db);
    }

    @matched = $book_db->search_book( $strategy, $pattern );
    if ( @matched ) {
        print "Found books:\n";
        print_book( $book_db, @matched );
        return @matched;
    }
    else {
        print "No books found using pattern: $pattern\n";
        return;
    }
}

sub delete_book {
    my $book_db = shift;
    my @books_to_delete = search_book($book_db);
    if (@books_to_delete) {
        for my $book (@books_to_delete) {
            $book_db->delete_book($book);
        }
    }
    print "Matched books were deleted. " . scalar ( keys %{$book_db->get_books} ) . " books left\n";
    save_books($book_db);
}

sub save_books {
    my $book_db = shift;
    print "\nWould you like to save changes? (Y/N)\n";
    chomp( my $decision = <STDIN> );
    if ( $decision =~ 'y|Y' ) {
        print "Enter path to the file for saving: ";
        chomp ( my $file = <STDIN>);
        $book_db->save_db($file);
        if ($@) {
            print "$@\n";
            return;
        }
        else {
            print "\nBooks saved!\n\n";
            return;
        }
    }
    elsif ( $decision =~ 'n|N' ) {
        print "\nOK. Returning to main menu\n";
        return;
    }
    else {
        print "\nChoose Y or N\n";
        save_books($book_db);
    }

}

my $database_obj = undef;
for ( greeting; <STDIN>; greeting ) {
    chomp;
    if ( /^l\b/ ) {
        my $path = s/^\w+\s+//r;
        $database_obj = load_database($database_obj);
    }
    elsif ( /^a\b/ ) {
        add_book($database_obj);
    }
    elsif ( /^p\b/ ) {
        print_book($database_obj);
    }
    elsif ( /^d\b/ ) {
        delete_book($database_obj);
    }
    elsif ( /^s\b/ ) {
        search_book($database_obj);
    }
    else {
        print "\nYou have not entered correct pattern\n\n";
    }
}