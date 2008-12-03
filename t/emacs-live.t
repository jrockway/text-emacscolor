use strict;
use warnings;
use Test::More;

BEGIN {
    my $emacses = `pidof emacs`;
    plan skip_all => 'You need a running emacs to run these tests.'
      if !$emacses;

    plan tests => 2;
}

use Text::EmacsColor;

my $colorer = Text::EmacsColor->new;
ok $colorer;

my $html = $colorer->format(
    '(in-package #:foo) (define-some-random-thing :like-this)',
    'lisp',
);

like $html, qr/<span class="builtin">/;
