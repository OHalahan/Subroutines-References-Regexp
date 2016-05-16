#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my $usage = "Usage: ./hm5.pl --find pattern | --tree | --size <path>\nAllowed combinations: --tree --size; --find pattern --size\n";
my ( $deep, $total, $pattern, $tree, $size ) = ( 0, 0 );

if ( !@ARGV ) {
    die $usage;
}
GetOptions ( "find=s" => \$pattern, "tree" => \$tree, "size" => \$size ) or die $usage;

if ( ( !$pattern || !$tree || !$size ) && ( @ARGV > 1 )  ) {
    die $usage;
}

if ( ( $tree && $pattern && $size ) || ( $tree && $pattern ) ) {
    die $usage;
}

# $path can be specified as an argument or it will be current working directory
my $path = ( $ARGV[0] || $ENV{PWD} );
if ( !opendir my $try, $path ) {
    die "Couldn’t open directory $path: $!\n\n$usage";
}

# subroutine walks through the tree and calls passed subroutine ($code) for each file ($top)
sub dir_walk {
    # $dir is undef
    my ( $top, $code, $dir ) = @_;
    # run subroutine for a file/directory; $deep is needed for "tree" sub
    $code->( $top, $deep );
    # recursively run for directory
    if ( -d $top ) {
        # we now in the directory, increase deep
        $deep++;
        my $file;
        if ( !opendir $dir, $top ) {
            warn "Couldn’t open directory $top: $!; skipping.\n";
            return;
        }
        while ( $file = readdir $dir ) {
            # skip current/previous directories
            if ( $file eq '.' || $file eq '..' ) {
                next;
            }
            dir_walk( "$top/$file", $code );
        }
        # recursive call over, decrease $deep back
        $deep--;
    }
}
# subroutine for printing tree
sub my_tree {
    # $current_size is empty string, $item is undef
    my ( $deepness, $current_size, $item ) = ($_[1], '');
    # if this is a root then set full path
    ( $deepness == 0 ) ? ( $item = $_[0] ) : ( $item = ( split '/', $_[0] )[-1] );
    # calculate size of the file or directory if $size is requested
    if ( $size ) {
        my @result = &size_combine ( $_[0] );
        $current_size = $result[0];
    }
    for ( 1..$deepness ) {
        print "\t";
    }
    # "|-" for directories, "--" for files
    ( -d $_[0] ) ? ( print "|-$item $current_size\n" ) : ( print "--$item $current_size\n" );
}

# subroutine for matching pattern
sub my_find {
    my ( $full_path, $current_size ) = ( $_[0], '' );
    # calculate the size of the file or directory if $size is requested
    if ( $size ) {
        my @result = &size_combine ( $_[0] );
        $current_size = $result[0];
    }
    # return if it's not a file
    if ( -d $full_path ) {
        return;
    }
    # convert full path to the relative one
    $full_path =~ s/$path/./;
    my $result_file = ( split '/', $full_path )[-1];
    if ( $result_file =~ $pattern ) {
        print "Matched: $result_file $current_size\npath: $full_path\n\n";
    }
}

# subroutine for calculating size
sub my_total {
    if ( -s $_[0] ) {
        $total += -s $_[0];
    }
}

# subroutine for combining tree + size; find + size
sub size_combine {
    $total = 0;
    # if directory then calculate total size recursively
    if ( -d $_[0] ) {
        dir_walk ( $_[0], \&my_total );
        my $current_size = $total;
        return "(".$current_size.")";
    } else {
        my $current_size = -s $_[0];
        if ( defined ( -s $_[0] ) ) {
            return "(".$current_size.")";
        }
    }
}

## calling subroutines
if ( ( ( $tree && $size ) || $tree ) && !$pattern ) {
    dir_walk ( $path, \&my_tree );
} elsif ( ( ( $pattern && $size ) || $pattern ) && !$tree ) {
    dir_walk ( $path, \&my_find );
} elsif ( $size && !$tree && !$pattern ) {
    dir_walk ( $path, \&my_total );
    print "Total size is $total.\n";
}
