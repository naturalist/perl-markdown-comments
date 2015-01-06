package Markdown::Comments::Format;

use strict;
use warnings;

sub new {
    my ( $class, %args ) = @_;

    if ( !$args{mc} || ref( $args{mc} ) ne 'Markdown::Comments' ) {
        die "Markdown::Comments object needed";
    }

    return bless \%args, $class;
}

sub mc { return $_[0]->{mc} }

sub format {
    my ( $self, $grep ) = @_;
    my @nodes  = @{ $self->mc->nodes };
    my @result = $grep ? grep { $grep->($_) } @nodes : @nodes;
    return join( "\n", map { $_->text } @result );
}

sub to_markdown {
    my ( $self, %args ) = @_;

    my $grep = sub {
        my $node = shift;
        return 0 unless $node->is_markdown;
        return 1 unless %args;
        for my $key ( keys %args ) {
            return 1 if ( defined $node->$key && $node->$key eq $args{$key} );
        }
        return 0;
    };

    return $self->format($grep);
}

sub output {
    my ( $self, %args ) = @_;
    return $self->to_markdown(%args);
}

1;
