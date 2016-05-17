#!/usr/bin/perl

use strict;
use warnings;

use v5.10;

# ============ DBConnection ==============

package DBService;

use DBI;

{
    my $dbh;

    sub initConnection {
        $dbh = DBI->connect("dbi:SQLite:dbname=DBSample/Chinook_Sqlite.sqlite", "","");
    }

    sub getHanler {
        retrun $dbh;
    }

    sub fetchall {
        my ($class, $statement, $args) = @_;

        my $sth = $dbh->prepare($statement);

        my $rv  = $sth->execute(@$args);

        my $list = [];

        while ( my $row = $sth->fetchrow_hashref ) {
            push @$list, $row;
        }

        return $list;
    }
}

# ============ Track ==============

package Track;

use Moose;

has 'TrackId'      => ( is => 'rw', isa => 'Int');
has 'Name'         => ( is => 'rw', isa => 'Str');
has 'AlbumId'      => ( is => 'rw', isa => 'Int');
has 'MediaTypeId'  => ( is => 'rw', isa => 'Int');
has 'GenreId'      => ( is => 'rw', isa => 'Int');
has 'Composer'     => ( is => 'rw', isa => 'Str');
has 'Milliseconds' => ( is => 'rw', isa => 'Int');
has 'Bytes'        => ( is => 'rw', isa => 'Int');
has 'UnitPrice'    => ( is => 'rw', isa => 'Num');

# ============ Playlist ==============

package Playlist;

use Moose;

has 'PlaylistId' => ( is => 'rw', isa => 'Int');
has 'Name'       => ( is => 'rw', isa => 'Str');
has 'tracks'     => ( is => 'rw', isa => 'ArrayRef[Track]', default => sub { [] });

sub fetchTracks {
    my ($self) = @_;

    my $tracks = DBService->fetchall("select t.* from track t
   join playlisttrack plt on t.TrackId = plt.TrackId
   where plt.PlaylistId = ?", [$self->PlaylistId]);

    for my $trackRawData ( @$tracks ) {
        my $track = Track->new($trackRawData);
        $self->addTrack($track);
    }
}

sub addTrack {
    my ($self, $track) = @_;

    push @{$self->tracks}, $track;
}

package main;

use Data::Dumper;

DBService->initConnection();

my $pl = Playlist->new({
        PlaylistId => 18,
        name => 'PL name'
    });

$pl->fetchTracks();

say Dumper($pl->tracks);
