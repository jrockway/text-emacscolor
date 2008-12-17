package Text::EmacsColor::Result;
use Mouse;
use List::Util qw(first);

# See below for lazily-loaded dependencies

use overload (
    q{""} => sub {
        my $self = shift;
        return $self->full_html;
    },
    fallback => 'that would be good',
);

has 'full_html' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'html_dom' => (
    is         => 'ro',
    isa        => 'XML::LibXML::Document',
    lazy_build => 1,
);

has 'css' => (
    is         => 'ro',
    isa        => 'CSS::Tiny',
    lazy_build => 1,
);

sub _build_html_dom {
    my $self = shift;
    eval { require XML::LibXML } or
      confess 'To get the DOM, you must install XML::LibXML';
    my $dom = XML::LibXML->new->parse_html_string( $self->full_html );
    return $dom;
}

sub _extract_style {
    my $self = shift;
    my $doc = $self->html_dom;
    my $style = eval {
        my $html = $doc->documentElement;
        my $head = first { $_->nodeName eq 'head' } $html->childNodes;
        my $s = first { $_->nodeName eq 'style' } $head->childNodes;
        return $s->textContent;
    };
}

sub _build_css {
    my $self = shift;
    eval { require CSS::Tiny } or
      confess 'To get the CSS, you must install CSS::Tiny';
    return CSS::Tiny->read_string( $self->_extract_style );
}

1;
