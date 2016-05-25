package Database;
use Keeper;

sub new {
    my $class = shift;
    my $self = { books => [],
                 file => undef
                };
    bless($self, $class);
    return $self;
}

sub load_db {
    my $book_db = shift;
    my ($file)  = @_;
    eval {
        open ( my $database, '<', $file ) or die "Cannot open a file $file: $!\n";
        $book_db->{file} = $file;
        my ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
        while ( <$database> ) {
            chomp;
            if ( /^Title/ ) {
                $title = s/^Title:\s//r;
            } elsif ( /^Author/ ) {
                $author = s/^Author:\s//r;
            } elsif ( /^Section/ ) {
                $section = s/^Section:\s//r;
            } elsif ( /^Shelf/ ) {
                $shelf = s/^Shelf:\s//r;
            } elsif ( /^On Hands/ ) {
                $taken = s/^On Hands:\s//r;
            } elsif ( /^$/ && $title && $author ) {
                push @{ $book_db->{books} }, Keeper->new( title => $title, author => $author, section => $section, shelf => $shelf, taken => $taken );
                ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
            }
        }
        close $database;
    };
    $@ ? return $@ : return $book_db;
}

sub add_book {
    my $book_db = shift;
    push @{ $book_db->{books} }, Keeper->new( @_ );
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
