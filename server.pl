#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Term::ReadKey;
use Term::ANSIColor;
use Socket;

binmode(STDOUT, ":utf8");

sub make_text {
    my ( $wd, $hg, $matrix, $cpu, $its_a, $its_p ) = @_;

    for my $row ( 0 .. $hg - 1 ) {
        for my $elem ( 0 .. $wd - 1 ) {
            if ( $row == ( $hg - 4 ) && $elem == 5 ) {
                $matrix->[$row][$elem] = { color => 'bold yellow', text => "Current CPU Usage: " };
                $matrix->[$row][ $elem + 1 ] = { text => "$cpu" };
            }
            if ( $row == 4 && $elem == 5 ) {
                $matrix->[$row][$elem] = { color => 'bold blue', text => "Client "};
                $matrix->[$row][ $elem + 1 ] = { text => "$its_a:$its_p " };
            }
            elsif ( $row == ( int ( ( $hg ) / 2 ) ) && $elem == 5 ) {
                $matrix->[$row][ $elem - 4 ] = { color => 'blue', text => "5" };
                $matrix->[$row][ $elem - 3 ] = { color => 'blue', text => "0" };
                $matrix->[$row][ $elem - 2 ] = { color => 'blue', text => "%" };
            }
        }
    }

    return 1;
}

sub make_frame {
    my ( $wd, $hg, $matrix ) = @_;
    @{$matrix} = ();
    for my $row ( 0 .. $hg - 1 ) {
        for my $elem ( 0 .. $wd - 1 ) {
            # 50%
            if ( $row == (int ( $hg / 2) ) && ( $elem > 5 && $elem < ( $wd - 5 ) ) ) {
                $matrix->[$row][$elem] = { color => 'blue', text => "-" };
            }
            # 50%
            elsif ( $row == ( int ( $hg / 2 ) ) && $elem == 5 ) {
                $matrix->[$row][$elem] = { text => "\x{252B}" };
            }
            elsif (   ( $elem == 5 && ( $row > 5  && $row < ( $hg - 5 ) ) )
                || ( $elem == ( $wd - 5 ) && ( $row > 5 && $row < ( $hg - 5 ) ) ) )
            {
                $matrix->[$row][$elem] = { text => "\x{2503}" };
            }
            elsif (( $row == 5 && ( $elem > 5 && $elem < ( $wd - 5 ) ) )
                || ( $row == ( $hg - 5 ) && ( $elem > 5 && $elem < ( $wd - 5 ) ) ) )
            {
                $matrix->[$row][$elem] = { text => "\x{2501}" };
            }
            elsif ( $row == 5 && $elem == 5 ) {
                $matrix->[$row][$elem] = { text => "\x{250F}" };
            }
            elsif ( $row == ( $hg - 5 ) && $elem == ( $wd - 5 ) ) {
                $matrix->[$row][$elem] = { text => "\x{251B}" };
            }
            elsif ( $row == ( $hg - 5 ) && $elem == 5 ) {
                $matrix->[$row][$elem] = { text => "\x{2517}" };
            }
            elsif ( $row == 5 && $elem == ( $wd - 5 ) ) {
                $matrix->[$row][$elem] = { text => "\x{2513}" };
            }
            else {
                $matrix->[$row][$elem] = { text => " " };
            }
        }
    }
    return 1;
}

sub make_graph {
    my ( $wd, $hg, $matrix, $cpus ) = @_;
    my @all_rows = ( 0 ) x ($wd - 11 - @{$cpus} );
    push @all_rows, @{$cpus};

    my $relative_r = 0;
    my $relative_y = ( int ( ( ( $hg ) * 40 ) / 100 ) );
    my $relative_g = ( int ( ( ( $hg ) * 50 ) / 100 ) );

    for my $elem ( 6 .. ( $wd - 6 ) ) {
        if ( $all_rows[ $elem - 6 ] ) {
            my $value = $all_rows[ $elem - 6 ];
            my $relative =  ( int ( ( ( $hg - 12 ) * $value ) / 100 ) );
            my $color;

            for my $row ( ( ( $hg - 6 ) - $relative ) .. ( $hg - 6 ) ) {
                if ( $row >= $relative_g ) { $color = 'green' }
                elsif ( $row >= $relative_y && $row < $relative_g ) { $color = 'yellow' }
                elsif ( $row >= $relative_r && $row < $relative_y ) { $color = 'red' }
                $matrix->[ $row ][ $elem ] = { color => $color, text => "\x{2588}" };
            }
        }
    }

}


sub print_out {
    my ( $matrix ) = @_;
    print "\033[2J";
    for ( @{$matrix} ) {
        for my $obj (@$_) {
            if ( $obj->{color} ) {
                print colored ( "$obj->{text}", $obj->{color} );
            }
            else {
                print "$obj->{text}";
            }
        }
        print "\n";
    }

}

####Server###
my $server_port = '212121';
# make the socket
socket(my $host, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
# so we can restart our server quickly
setsockopt($host, SOL_SOCKET, SO_REUSEADDR, 1);
# build up my socket address
my $my_addr = sockaddr_in($server_port, INADDR_ANY);
bind($host, $my_addr) or die "Couldn't bind to port $server_port : $!\n";
# establish a queue for incoming connections
listen($host, SOMAXCONN) or die "Couldn't listen on port $server_port : $!\n";

my ( $p_wchar, $p_hchar ) = ( 0, 0 );
my @cpus;
# accept and process connections
while ( my $conn_client = accept( my $client, $host ) ) {
    my ( $its_p, $its_a ) = sockaddr_in($conn_client);
    $its_a = inet_ntoa($its_a);
    while (<$client>) {
        chomp;
        my @matrix;
        my ( $wchar, $hchar ) = GetTerminalSize();
        my $cpu = $_;
        push @cpus, $cpu;
        if ( @cpus > ( $wchar - 11 ) ) {
            splice @cpus, 0, ( scalar @cpus - ( $wchar - 11 ) );
        }
        $matrix[0][0] = { color => 'bold red', text => "$_" };
        if ( $wchar < 25 || $hchar < 20 ) {
            $matrix[0][0] = { color => 'bold red', text => "Terminal size is too small!" };
        }
        else {
            make_frame( $wchar, $hchar, \@matrix );
            make_text( $wchar, $hchar, \@matrix, $cpu, $its_a, $its_p );
            make_graph( $wchar, $hchar, \@matrix, \@cpus );
        }

        print_out( \@matrix );
    }

    print colored ( "Lost connection, waiting for client...\n", 'bold red' );
}

close($host);
