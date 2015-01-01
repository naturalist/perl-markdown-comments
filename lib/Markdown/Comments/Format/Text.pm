package Markdown::Comments::Format::Text;

use strict;
use warnings;
use parent 'Markdown::Comments::Format';

use HTML::FormatText;
use Text::Markdown 'markdown';

sub output {
    my ( $self ) = @_;
    my $markdown = $self->SUPER::output();
    my $html = markdown($markdown);
    return HTML::FormatText->format_string($html);
}

1;
