package Markdown::Comments::Node;

use strict;
use warnings;

sub new {
    my ( $class, %args ) = @_;
    $args{is_markdown} //= 0;
    $args{text}        //= '';
    $args{params}      //= {};
    bless \%args, $class;
}

sub params {
    $_[0]->{params} = $_[1] if defined $_[1];
    $_[0]->{params};
}

sub is_markdown {
    $_[0]->{is_markdown} = $_[1] if defined $_[1];
    $_[0]->{is_markdown};
}

sub text {
    $_[0]->{text} = $_[1] if defined $_[1];
    $_[0]->{text};
}

sub AUTOLOAD {
    my $self = shift;
    our $AUTOLOAD;
    my $sub = $AUTOLOAD =~ /::(\w+)$/ ? $1 : return;
    $self->params->{$sub} = shift if @_;
    return $self->params->{$sub};
}

sub DESTROY {

}

1;
