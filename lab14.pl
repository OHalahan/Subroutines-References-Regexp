#!/usr/bin/perl

use strict;
use warnings;

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
