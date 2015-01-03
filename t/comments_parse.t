use strict;
use warnings;

use Test::More;
use Markdown::Comments;

my $p = Markdown::Comments->new;
ok $p;

$p->parse("1\n#!mdd\n#2\n3");
is_deeply( _flat($p), [ hs( '1', 0 ), hs('2'), hs( '3', 0 ) ] );

$p->parse("1\n2\n#3\n#4\n#!mdd\n#5\n6");
is_deeply( _flat($p), [ hs( "1\n2\n#3\n#4", 0 ), hs('5'), hs( '6', 0 ) ] );

$p->parse("#1\n2\n#3\n4");
is_deeply( _flat($p), [ hs( "#1\n2\n#3\n4", 0 ) ] );

$p->parse("#!mdd\n1\n#2");
is_deeply( _flat($p), [ hs( "1\n#2", 0 ) ] );

$p->parse("#!mdd\n#!mdd\n#!mdd");
is_deeply( _flat($p), [ hs("!mdd\n!mdd") ] );

$p->parse("#!mdd\n#1\n#2");
is_deeply( _flat($p), [ hs("1\n2") ] );

$p->parse("# !mdd \n # 1\n # 2");
is_deeply( _flat($p), [ hs("1\n2") ] );

$p->parse("#  !mdd \n # 1\n # 2");
is_deeply( _flat($p), [ hs("1\n2") ] );

$p->parse("#  !mdd \n #   1\n #   2");
is_deeply( _flat($p), [ hs(" 1\n 2") ] );

$p->parse("#!mdd a,b,c\n#1");
is_deeply( _flat($p), [ hs( "1", 1, { a => 1, b => 1, c => 1 } ) ] );

$p->parse("#!mdd a=bar,b=foo,c=baz\n#1");
is_deeply( _flat($p), [ hs( "1", 1, { a => 'bar', b => 'foo', c => 'baz' } ) ] );

done_testing;

sub hs {
    my ( $out, $is_markdown, $params ) = @_;
    $is_markdown = 1 if !defined $is_markdown;
    $params ||= {};

    return {
        text        => $out,
        is_markdown => $is_markdown,
        params      => $params
    };
}

sub _to_hash {
    my $n = shift;
    my %h = map { $_ => $n->{$_} } keys %$n;
    return \%h;
}

sub _flat {
    my $p = shift;
    my @a = map { _to_hash($_) } @{ $p->nodes };
    return \@a;
}
