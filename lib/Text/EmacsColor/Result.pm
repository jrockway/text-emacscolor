package Text::EmacsColor::Result;
use Mouse;

has 'full_html' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'html_dom' => (
    is         => 'ro',
    isa        => 'HTML::TreeBuilder',
    lazy_build => 1,
);

has 'css' => (
    is         => 'ro',
    isa        => 'CSS::Tiny',
    lazy_build => 1,
);

has 'html_body' => (
    is         => 'ro',
    isa        => 'HTML::TreeBuilder',
    lazy_build => 1,
);

sub _build_html_dom {
    my $self = shift;

    my $t = HTML::TreeBuilder->new;
    $t->parse($self->full_html);
    $t->eof;
    return $t;
}

sub _build_css {
    my $self = shift;
}

sub DEMOLISH {
    my $self = shift;
    if($self->has_html_dom){
        # hi.  i'm HTML::TreeBuilder, and I'm retarded!
        $self->html_dom->delete;
    }
}

1;
