#!/usr/bin/perl

use strict;
use warnings;

# Create a program which monitors each second a statistic of an average number of processes in a system within last 10 seconds. Also, the program should handle such signals:
#
# SIGUSR1 - print the statistic (like dd utility does);
# SIGUSR2 - print the amount of free memory;
# SIGINT - send USR1 to itself and quit the program.

### Subroutines

sub average {
    my @summary = @_;
    my $sum     = 0;
    for (@summary) {
        $sum += $_;
    }
    return int ( $sum / @summary );
}

sub print_stat {
    my $own_data = shift;
        print "\nAverage running processes: $own_data->{stat}\n";
    return undef;
}

sub print_memo {
    my $own_data = shift;
    print "\nFree memory: $own_data->{memo} MB\n";
    return undef;
}

sub quit {
    kill( 'USR1', $$ );
    exit 0;
}

### End of subroutines

my ( $sum, @ten_sec ) = ( 0, () );
my %data;

$SIG{USR1}  = sub { print_stat( \%data ); print_memo( \%data ) };
$SIG{USR2}  = sub { print_memo( \%data ) };
$SIG{INT}   = \&quit;

while (1) {
    # -1 to exclude header of ps command
    chomp( my $current_value = ( qx( ps -A | wc -l ) - 1 ) );
    push @ten_sec, $current_value;
    if ( @ten_sec > 10 ) {
        shift @ten_sec;
    }

    $data{stat} = average(@ten_sec);
    chomp( $data{memo} = qx( free -m | tail -2 | head -1 | awk {'print \$4'} ) );

    sleep 1;
}
