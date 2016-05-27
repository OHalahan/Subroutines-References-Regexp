package Database;
use Keeper;

sub new {
    my $class = shift;
    my $self  = { books => {}, file => undef, last_id => 0 };
    bless($self, $class);
    return $self;
}

sub load_db {
    my $book_db = shift;
    my ($file)  = @_;
    my $id      = ( $book_db->get_last_id );
    eval {
        open( my $database, '<', $file ) or die "Cannot open a file $file: $!\n";
        $book_db->set_file($file);
        my ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
        while ( <$database> ) {
            chomp;
            if ( /^Title/ ) {
                $title = s/^Title:\s//r;
            }
            elsif ( /^Author/ ) {
                $author = s/^Author:\s//r;
            }
            elsif ( /^Section/ ) {
                $section = s/^Section:\s//r;
            }
            elsif ( /^Shelf/ ) {
                $shelf = s/^Shelf:\s//r;
            }
            elsif ( /^On Hands/ ) {
                $taken = s/^On Hands:\s//r;
            }
            elsif ( /^$/ && $title && $author ) {
                $id++;
                $book_db->set_last_id($id);
                $book_db->{books}{$id} = Keeper->new( title => $title, author => $author, section => $section, shelf => $shelf, taken => $taken );
                ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
            }
        }
        close $database;
    };
    $@ ? return $@ : return $book_db;
}

sub add_book {
    my $book_db = shift;
    my $id      = ( $book_db->get_last_id ) + 1;
    $book_db->set_last_id($id);
    $book_db->{books}{$id} = Keeper->new(@_);
    return;
}

sub search_book {
    my ( $book_db, $strategy, $pattern, @matched ) = ( @_, () );
    my $expression = qr/$pattern/;
    if ( $strategy eq 'id' ) {
        if ( $book_db->{books}{$pattern} ) {
            push @matched, $pattern;
        }
    }
    else {
        for my $book ( keys %{ $book_db->{books} } ) {
            my $method   = 'get_' . $strategy;
            my $matching = $book_db->{books}{$book}->$method;
            if ( $matching =~ $expression ) {
                push @matched, $book;
            }
        }
    }
    return @matched;
}

sub delete_book {
    my $book_db = shift;
    my $book    = @_;
    if ( $book_db->{books}{$book} ) {
        delete $book_db->{books}{$book};
        return;
    }
    else {
        return "No book with ID $book\n";
    }
}

our $AUTOLOAD;
sub AUTOLOAD {
    my ($self, $arg) = @_;
    my ($prefix, $attr) = $AUTOLOAD =~ /.*::(set|get)_(.*)/;
    if ( $prefix eq 'get' ) {
        return $self->{$attr};
    }
    else {
        $self->{$attr} = $arg;
    }
}

1;
