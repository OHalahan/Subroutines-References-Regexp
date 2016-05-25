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
    print "\nPossible actions:\nl\tload\na\tadd book\nd\tdelete book\ns\tsearch book\n";
    print "\nEnter the required action and press ENTER:\n";
}

sub load_database {
    print "Enter the path to the file: ";
    my $database     = Database->new();
    #chomp ( my $file = <STDIN> );
    my $file         = 'books.txt';
    $database->load_db($file);
    if ( $@ ) {
        print  "\n$@\n";
        return;
    } else {
        print "\nDone. Loaded ". @{ $database->{books} } ." books in total\n";
        return $database;
    }
}

sub add_book {
    my ( $title, $author, $section, $shelf, $taken, $book_db ) = ( '', '', '', '', '', @_ );
    print "\n\nEnter the book title: ";
    chomp ($title = <STDIN>);
    print "Enter the book's author: ";
    chomp ($author = <STDIN>);
    print "Enter a section: ";
    chomp ($section = <STDIN>);
    print "Enter a shelf: ";
    chomp ($shelf = <STDIN>);
    print "Enter name of the person whom this book was given to: ";
    chomp ($taken = <STDIN>);
    $book_db->add_book( title => $title, author => $author, section => $section, shelf => $shelf, taken => $taken );
    print "Book has been added to the database\n".  @{ $book_db->{books} } ." books in total\n";
}

sub print_book {
    my ( $book_db ) = @_;
    for my $id ( 0 .. @{ $book_db->{books} } ) {
        my $book = @{ $book_db->{books} }[$id];
        print "\n";
        print "$book\n";
        print "ID: $id\n";
        print "Title: ${$book}{title}\n";
        print "Author: ${$book}{author}\n";
        print "Section: ${$book}{section}\n";
        print "Shelf: ${$book}{shelf}\n";
        print "On Hands: ${$book}{taken}\n";
        print "\n";
    }
}

sub search_book {

}

my $database_obj;
for ( greeting; <STDIN>; greeting ) {
    chomp;
    $database_obj = load_database();
    #add_book( $database_obj );
    print_book( $database_obj );
}
