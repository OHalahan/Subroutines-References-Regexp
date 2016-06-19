#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Term::ReadKey;
use Term::ANSIColor;
use Socket;

binmode(STDOUT, ":utf8");

{
    my ( $user, $nice, $system, $idle, $iowait, $irq, $srq, $steal ) = ( 0, 0, 0, 0, 0, 0, 0, 0 );
    my ( $p_user, $p_nice, $p_system, $p_idle, $p_iowait, $p_irq, $p_srq, $p_steal ) = ( 0, 0, 0, 0, 0, 0, 0, 0 );
    my ( $p_f_idle, $f_idle, $non_idle, $p_non_idle, $p_total, $total, $totald, $idled, $cpu_percent ) = ( 0, 0, 0, 0, 0, 0, 0, 0, 0 );

    sub get_cpu {
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

        $cpu_percent = int( ( ($totald - $idled) / $totald ) * 100 );

        ###assigning p_*values:
        ( $p_user, $p_nice, $p_system, $p_idle, $p_iowait, $p_irq, $p_srq, $p_steal ) = ( $user, $nice, $system, $idle, $iowait, $irq, $srq, $steal ) ;

        return $cpu_percent;
    }
} ### end of work with CPU percents

my $host = shift @ARGV || '127.0.0.1';
my $port = shift @ARGV || '212121';
my $internet_addr = inet_aton($host) or die "Couldn't convert $host into an Internet address: $!\n";
my $paddr = sockaddr_in( $port, $internet_addr );


# create a socket
socket( my $to_server, PF_INET, SOCK_STREAM, getprotobyname( 'tcp' ) );

# connect
connect($to_server, $paddr) or die "Couldn't connect to $host:$port : $!\n";

while (1) {
    my $cpu = get_cpu;
    print $to_server "$cpu\n";
    select(undef, undef, undef, 0.5);
}
