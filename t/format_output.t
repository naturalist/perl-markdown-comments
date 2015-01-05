
use strict;
use warnings;

use Test::More;
use Markdown::Comments;
use Markdown::Comments::Format;

{
    my $t = "#!mdd a\n#1\n\n#!mdd b\n#2";
    is fm($t, a => 1), "1";
    is fm($t, b => 1), "2";
    is fm($t, a => 1, b => 1), "1\n2";
    is fm($t), "1\n2";
}

{
    my $t = "#!mdd a\n#1\n2\n#!mdd b\n#3";
    is fm($t, a => 1), "1";
    is fm($t, b => 1), "3";
    is fm($t, a => 1, b => 1), "1\n3";
    is fm($t), "1\n3";
}

done_testing;

sub fm {
    my ( $in, %args ) = @_;
    my $mc = Markdown::Comments->parse($in);
    my $f = Markdown::Comments::Format->new( mc => $mc );
    return $f->output(%args);
}
