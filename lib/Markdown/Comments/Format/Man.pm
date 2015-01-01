package Mdd::Format::Man;

use strict;
use warnings;
use parent 'Mdd::Format';

use HTML::FormatNroff;
use Text::Markdown 'markdown';

sub output {
    my ( $self ) = @_;
    my $markdown = $self->SUPER::output();
    my $html = markdown($markdown);
    return HTML::FormatNroff->format_string($html);
}

1;
