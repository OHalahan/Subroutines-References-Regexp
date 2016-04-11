#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my $usage = "Usage: ./hm5.pl --find pattern | --tree | --size <path>\nAllowed combinations: --tree --size; --find pattern --size\n";
my ($deep, $total, $pattern, $tree, $size) = (0, 0);
GetOptions ("find=s" => \$pattern,
            "tree"   => \$tree,
            "size"  => \$size)
or die $usage;
die $usage unless (($pattern or $tree or $size) and (@ARGV <= 1));
die $usage if (($tree and $pattern and $size) or ($tree and $pattern));

# $path can be specified as an argument or it will be current working directory
my $path = ($ARGV[0] or $ENV{PWD});
die "Couldn’t open directory $path: $!\n\n$usage" unless (opendir my $try, $path);

# subroutine walks through the tree and calls passed subroutine ($code) for each file ($top)
sub dir_walk {
    # $dir is undef
    my ($top, $code, $dir) = @_;
    # run subroutine for a file/directory; $deep is needed for "tree" sub
    $code->($top, $deep);
    # recursively run for directory 
    if (-d $top) { 
        # we now in the directory, increase deep
        $deep++;
        my $file;
        unless (opendir $dir, $top) {
            warn "Couldn’t open directory $top: $!; skipping.\n";
            return;
        }
        while ($file = readdir $dir) {
            # skip current/previous directories
            next if $file eq '.' || $file eq '..';
            dir_walk("$top/$file", $code);
        }
        # recursive call over, decrease $deep back     
        $deep--;
    }
}
# subroutine for printing tree
sub my_tree {
    # $current_size is empty string, $item is undef
    my ($deepness, $current_size, $item) = ($_[1], '');
    # if this is a root then set full path
    ($deepness == 0) ? ($item = $_[0]) : ($item = (split '/', $_[0])[-1]);    
    # calculate size of the file or directory if $size is requested
    if ($size) {
        my @result = &size_combine($_[0]);
        $current_size = $result[0];
    }
    print "\t" for (1..$deepness);
    # "|-" for directories, "--" for files
    (-d $_[0]) ? (print "|-$item $current_size\n") : (print "--$item $current_size\n");
}
# subroutine for matching pattern
sub my_find {
    my ($full_path, $current_size) = ($_[0], '');
    # calculate the size of the file or directory if $size is requested
    if ($size) {
        my @result = &size_combine($_[0]);
        $current_size = $result[0];
    }
    # return if it's not a file
    return if (-d $full_path);
    # convert full path to the relative one 
    $full_path =~ s/$path/./;
    my $result_file = (split '/', $full_path)[-1];
    print "Matched: $result_file $current_size\npath: $full_path\n\n" if ($result_file =~ $pattern);
}
# subroutine for calculating size 
sub my_total {
    $total += -s $_[0] if (-s $_[0]);
}
# subroutine for combining tree + size; find + size
sub size_combine {
    $total = 0;
    # if directory then calculate total size recursively
    if (-d $_[0]) {
        dir_walk($_[0], \&my_total);
        my $current_size = $total;
        return "(".$current_size.")";
    } else {
        my $current_size = -s $_[0];
        return "(".$current_size.")" if defined (-s $_[0]);
    }
}
## calling subroutines
dir_walk($path, \&my_tree) if ((($tree and $size) or $tree) and !$pattern);
dir_walk($path, \&my_find) if ((($pattern and $size) or $pattern) and !$tree);
if ($size and !$tree and !$pattern) {
    dir_walk($path, \&my_total);
    print "Total size is $total.\n";
}