#!/usr/bin/perl

use strict;
use warnings;

# Create a program which monitors each second a statistic of an average number of processes in a system within last 10 seconds. Also, the program should handle such signals:
#
# SIGUSR1 - print the statistic (like dd utility does);
# SIGUSR2 - print the amount of free memory;
# SIGINT - send USR1 to itself and quit the program.

### Subroutines
{
    my $counter = 0;
    sub get_count {
        $counter++;
        if ( $counter == 10 ) {
            $counter = 0;
            return 1;
        }
        return undef;
    }
}

sub print_stat {
    my $own_data = shift;
    if ( $own_data->{stat} ) {
        print "\nAverage running processes: $own_data->{stat}\n";
    }
    else {
        print "\nNo statistics yet.\nCurrent number of running processes: $own_data->{current}\n";
    }
    return undef;
}

sub print_memo {
    my $own_data = shift;
    print "\nFree memory: $own_data->{memo} MB\n";
    return undef;
}

sub quit {
    kill( 'USR1', $$ );
    exit;
}

### End of subroutines

my ( $sum, %data ) = ( 0 );

$SIG{USR1}  = sub { print_stat( \%data ); print_memo( \%data ) };
$SIG{USR2}  = sub { print_memo( \%data ) };
$SIG{INT}   = \&quit;

while (1) {
    if ( !get_count ) {
        chomp( $data{memo}    = qx( free -m | tail -2 | head -1 | awk {'print \$4'} ) );
        # -1 to exclude header of ps command
        chomp( $data{current} = ( qx( ps -A | wc -l ) - 1 ) );
        $sum += $data{current};
    }
    else {
        $data{stat} = ( $sum / 10 );
        $sum = 0;
    }
    sleep 1;
}
