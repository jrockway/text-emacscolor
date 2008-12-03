use strict;
use warnings;
use Test::More tests => 2;

use Text::EmacsColor;

diag `emacs --version`; # for the CPAN testers

my $colorer = Text::EmacsColor->new;
ok $colorer;

my $html = $colorer->format(
    '(in-package #:foo) (define-some-random-thing :like-this)',
    'lisp',
);

like $html, qr/<span class="builtin">/;
