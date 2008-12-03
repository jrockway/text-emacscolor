package Text::EmacsColor;
use Mouse;
use File::Temp;
use Path::Class;
use File::ShareDir;

sub dist_file(@) {
    return File::ShareDir::dist_file('Text-EmacsColor', file(@_)->stringify);
}

use namespace::clean -except => 'meta';

has 'emacs_command' => (
    is         => 'ro',
    isa        => 'Str',
    required   => 1,
    default    => sub {
        'emacs --batch --eval',
          # or 'emacsclient --eval',
    },
);

sub format {
    my ($self, $code, $mode) = @_;

    my $fh = File::Temp->new();
    my $filename  = $fh->filename;
    print {$fh} $code;

    $mode = $mode ? qq{"$mode"} : 'NIL';

    my $cmd = $self->emacs_command;
    my $htmlize = dist_file 'lisp', 'htmlize.el';
    my $driver  = dist_file 'lisp', 'driver.el';

    my $html =
      qx "$cmd '(progn
                  (load-file \"\Q$htmlize\E\")
                  (load-file \"\Q$driver\E\")
                  (print
                    (Text::EmacsColor-htmlize \"\Q$filename\E\" $mode)))' 2>/dev/null";

    $html =~ s/(^"|"$)//g;
    my %fixes = (
        n   => "\n",
        '"' => '"',
    );
    $html =~ s/\\(.)/$fixes{$1}/g;
    return $html;
}

1;

__END__

=head1 NAME

Text::EmacsColor -

=cut
