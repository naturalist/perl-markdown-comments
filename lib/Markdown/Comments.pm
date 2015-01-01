package Markdown::Comments;

use strict;
use warnings;
use Markdown::Comments::Node;

my $sigil_re   = qr{(\s*)\!mdd\s*(.*)};
my $comment_re = qr{^\s*\#};

sub new {
    my ( $class, %args ) = @_;
    return bless { nodes => (defined $args{nodes} ? $args{nodes} : []) }, $class;
}

sub nodes {
    return $_[0]->{nodes};
}

sub parse {
    my ( $class, $text ) = @_;
    my $nodes = [];

    if ( defined $text ) {

        my @lines = split( /\n/, $text );
        my $i     = 0;
        my @text  = ();

        my $flush = sub {
            if (@text) {
                push @$nodes,
                  Markdown::Comments::Node->new( text => join( "\n", @text ) );
                @text = ();
            }
        };

        while ( $i < @lines ) {

            # Is this a comment line?
            if ( $lines[$i] =~ $comment_re ) {
                my ( $is_mdd, $spaces, %params );

                # Go over the entire comment block
                while ( $i < @lines && $lines[$i] =~ $comment_re ) {

                    if ( !$is_mdd ) {
                        if ( $is_mdd = $lines[$i] =~ $sigil_re ) {
                            $flush->();
                            $spaces = length($1);
                            %params = $2 ? _parse_sigil($2) : ();
                            $i++;
                            next;
                        }
                    }

                    if ($is_mdd) {
                        $lines[$i] =~ s/$comment_re//;
                        $lines[$i] =~ s/^\s// for ( 1 .. $spaces );
                    }

                    push @text, $lines[ $i++ ];
                }

                if ( $is_mdd && @text ) {
                    push @$nodes,
                      Markdown::Comments::Node->new(
                        is_markdown => 1,
                        params      => \%params,
                        text        => join( "\n", @text )
                      );
                    @text = ();
                }

            }

            if ( $i < @lines ) {
                push @text, $lines[ $i++ ];
            }
        }

        $flush->();
    }

    return $class->new( nodes => $nodes );
}

sub _parse_sigil {
    my $text = shift;
    my %result;
    my @groups = split( /\s*\,\s*/, $text );
    for my $g (@groups) {
        my ( $key, $value ) = split( /\s*\=\s*/, $g );
        $result{$key} = defined $value ? $value : 1;
    }
    return %result;
}

1;
