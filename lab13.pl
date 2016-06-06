#!/usr/bin/perl

use strict;
use warnings;

# Create a program which monitors each second a statistic of an average number of processes in a system within last 10 seconds. Also, the program should handle such signals:
#
# SIGUSR1 - print the statistic (like dd utility does);
# SIGUSR2 - print the amount of free memory;
# SIGINT - send USR1 to itself and quit the program.

{
    my $counter = 0;
    sub get_count {
        $counter++;
        if ( $counter == 10 ) {
            $counter = 0;
            return undef;
        }
        return 1;
    }
}

sub results {
    my $data = shift;
    my %own_hash = undef;
    %own_hash = %{$data};
}

my %data = undef;

while (1) {
    if (get_count) {
        $data{stat} = qx( ps -A | wc -l );
        $data{memo} = qx( free -m | tail -2 | head -1 | awk {'print $4'} );
    }
    else {
        results( \%data );
        $data{stat} = 0;
        $data{memo} = 0;
    }

    sleep 1;
}
