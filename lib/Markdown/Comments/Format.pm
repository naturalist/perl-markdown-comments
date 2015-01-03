package Markdown::Comments::Format;

use strict;
use warnings;
use Carp;

sub new {
    my ( $class, %args ) = @_;

    if ( !$args{mc} || ref( $args{mc} ) ne 'Markdown::Comments' ) {
        croak "Markdown::Comments object needed";
    }

    # Default order parameter
    $args{default_order} ||= 100;

    return bless \%args, $class;
}

sub mc { return $_[0]->{mc} }
sub default_order { return $_[0]->{default_order} }

sub format {
    my ( $self, $grep ) = @_;
    my @nodes  = @{ $self->mc->nodes };
    my @result = $grep ? grep { $grep->($_) } @nodes : @nodes;
    return join( "\n", map { $_->text } @result );
}

sub output {
    my ( $self, %args ) = @_;

    my $match = sub {
        my $node = shift;
        for my $key ( keys %args ) {
            return 1 if ( defined $node->$key && $node->$key eq $args{$key} );
        }
        return 0;
    };

    my $grep = %args ? sub { $match->($_) } : sub { 1 };

    return $self->format($grep);
}

1;
