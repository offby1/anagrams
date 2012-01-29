use v6;
use Test;

use dict;

plan 2;

ok(acceptable('frotz'), 'frotz is fine');
ok(!acceptable('!!!' ), '!!! bad');
