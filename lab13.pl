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

sub results {
    my $data = shift;
    my %own_data;
    if ($data) {
        %own_data = %{$data};
    }
    else {
        $own_data{memo} = qx( free -m | tail -2 | head -1 | awk {'print \$4'} );
        return ( \%own_data );
    }
    return undef;
}

sub print_stat {
    my $data = results;
    $data->{stat} ? last : $data->{stat} = 0;
    print "Average statistics for processes: $data->{stat}\n";
    return undef;
}

sub print_memo {
    my $data = results;
    print "Free memory: $data->{memo}\n";
    return undef;
}
### End of subroutines

my %data;
while (1) {
    if ( !get_count ) {
        $data{stat} += qx( ps -A | wc -l );

    }
    else {
        $data{stat} = ( $data{stat} / 10 );
        print "$data{stat}\n";
        results( \%data );
        $data{stat} = 0;
    }
    print_memo;
    print_stat;
    sleep 1;
}
