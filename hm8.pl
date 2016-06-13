#!/usr/bin/perl

use strict;
use warnings;
use Term::ReadKey;

# Create a program which monitors a CPU usage on a remote host(s).
# Use /proc/stat to calculate the total CPU usage (it should be an aggregated value among all cores).
# A client on the remote host should gather an information and send it to a local server.
# Your local server should print it on a terminal as an interactive graph (like nload utility does).
# An initial size of this graph should depend on the terminal size. Somewhere near the graph an exact value of CPU usage should be printed.
#
# Optional server features:
# an ability to process the information from several clients simultaneously and to switch between graphs;
# colorized graphs;
# a usage of unicode characters to make graph pretty.
#
# Tips:
#
# Create a program that monitors your local CPU usage. After you are satisfied with results, spread a functionality among client and server;
# These modules may be useful: Term::ANSIColor, Term::ReadKey.
# http://matrixspace.me/technology/tweaking-cpu-usage-java-linux-part-2/
# http://stackoverflow.com/questions/23367857/accurate-calculation-of-cpu-usage-given-in-percentage-in-linux

{

}
my $cpu = qx(cat /proc/stat | head -1 | awk {'print \$2, \$3, \$4, \$5, \$6, \$7, \$8, \$9'});
( $user, $nice, $system, $idle, $iowait, $irq, $srq, $steal ) = ( split /\s/, $cpu );

$p_f_idle = $p_idle + $p_iowait;
$f_idle   = $idle + $iowait;

$p_non_idle = $p_user + $p_nice + $p_system + $p_irq + $p_srq + $p_steal;
$non_idle   = $user + $nice + $system + $irq + $srq + $steal;

$p_total = $p_f_idle + $p_non_idle;
$total   = $f_idle + $non_idle;

# differentiate: actual value minus the previous one
$totald = $total - $p_total;
$idled  = $f_idle - $p_f_idle;

$cpu_percent = ($totald - $idled) / $totald;



print "percent: $cpu_percent\n";
