
use strict;
use warnings;

use Test::More;
use Markdown::Comments;
use Markdown::Comments::Format;

is hs("#!mdd a\n#1\n\n#!mdd b\n#2", a => 1), "1";
is hs("#!mdd a\n#1\n\n#!mdd b\n#2", b => 1), "2";
is hs("#!mdd a\n#1\n\n#!mdd b\n#2", a => 1, b => 1), "1\n2";

done_testing;


sub hs {
    my ( $in, %args ) = @_;
    my $mc = Markdown::Comments->parse($in);
    my $f = Markdown::Comments::Format->new( mc => $mc );
    return $f->output(%args);
}
