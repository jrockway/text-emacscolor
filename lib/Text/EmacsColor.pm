package Text::EmacsColor;
use Mouse;
use File::Temp;
use Path::Class::File;
use namespace::clean -except => 'meta';

has 'emacs_command' => (
    is         => 'ro',
    isa        => 'ArrayRef',
    required   => 1,
    auto_deref => 1,
    default    => sub {
        ['emacsclient', '--eval'],
    },
);

sub format {
    my ($self, $code, $mode) = @_;

    my $fh = File::Temp->new();
    my $filename  = $fh->filename;

    print {$fh} $code;

    $mode = $mode ? qq{"$mode"} : 'NIL';
    my @cmd = $self->emacs_command;
    my $html =
      qx "@cmd '(Text::EmacsColor-htmlize \"\Q$filename\E\" $mode)'";

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
