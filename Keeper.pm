package Keeper;

sub new {
    my $class = shift;
    my $self = { @_ };
    bless($self, $class);
    return $self;
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
