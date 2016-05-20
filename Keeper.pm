package Keeper;

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);
    $self->init(@_);
    return $self;
}

sub init {
    my $self = shift;
    my ( $title, $author, $section, $shelf, $taken ) = @_;
    print "debug $author\n";
    $self->{title} = $title;
    $self->{author} = $author;
    $self->{section} = $section;
    $self->{shelf} = $shelf;
    $self->{taken} = $taken;
}

1;
