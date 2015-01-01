
use strict;
use warnings;

use Test::More;
use Markdown::Comments;

is_deeply p('a'), { a => 1 };
is_deeply p('a,b'), { a => 1, b => 1 };
is_deeply p('a=b'), { a => 'b' };
is_deeply p('a=b,c=d'), { a => 'b', c => 'd' };
is_deeply p('a = b , c = d'), { a => 'b', c => 'd' };

done_testing;

sub p {
    return  { Markdown::Comments::_parse_sigil(@_) };
}
