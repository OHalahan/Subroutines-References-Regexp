#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Term::ReadKey;
use Term::ANSIColor;

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

sub make_text {
    my ( $wd, $hg, $matrix, $cpu ) = @_;

    for my $row ( 0 .. $hg - 1 ) {
        for my $elem ( 0 .. $wd - 1 ) {
            if ( $row == ( $hg - 4 ) && $elem == 5 ) {
                $matrix->[$row][$elem] = { color => 'bold yellow', text => "Current CPU Usage: " };
                $matrix->[$row][ $elem + 1 ] = { text => "$cpu" };
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

my ( $p_wchar, $p_hchar ) = ( 0, 0 );
my @cpus;


while (1) {
    my @matrix;

    my ( $wchar, $hchar ) = GetTerminalSize();
    my $cpu = get_cpu;
    push @cpus, $cpu;
    if ( @cpus > ( $wchar - 11 ) ) {
        splice @cpus, 0, ( scalar @cpus - ( $wchar - 11 ) );
    }
    if ( $wchar < 25 || $hchar < 20 ) {
        $matrix[0][0] = { color => 'bold red', text => "Terminal size is too small!" };
    }
    else {
        make_frame( $wchar, $hchar, \@matrix );
        make_text( $wchar, $hchar, \@matrix, $cpu );
        make_graph( $wchar, $hchar, \@matrix, \@cpus );
    }

    print_out( \@matrix );

    ( $p_wchar, $p_hchar ) = ( $wchar, $hchar );
    select(undef, undef, undef, 0.5);
}
