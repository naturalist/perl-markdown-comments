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
    my ( $self, $grep, $sort ) = @_;
    my @nodes  = @{ $self->mc->nodes };
    my @result = $grep ? grep { $grep->($_) } @nodes : @nodes;
    my @sorted = $sort ? sort { $sort->( $a, $b ) } @result : @result;
    return join( "\n", map { $_->text } @sorted );
}

sub output {
    my $self = shift;
    my $grep = sub { $_[0]->is_markdown };
    my $sort = sub {
        my ( $node_a, $node_b ) = @_;
        my $order_a =
          defined $node_a->order ? $node_a->order : $self->default_order;
        my $order_b =
          defined $node_b->order ? $node_b->order : $self->default_order;
        return $order_a <=> $order_b;
    };
    return $self->format( $grep, $sort );
}

1;
