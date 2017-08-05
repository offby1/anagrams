use v6;
use Test;

use bag;

plan 10;

is-deeply(bag_from_letters('abcdeaa'), bag_from_letters('aaabcde'));
is-deeply(bag_from_letters('A'), bag_from_letters('a'));
is-deeply(bag_from_letters('AB!!!c'), bag_from_letters('abc'));
ok(bag_empty(bag_from_letters('')));
nok(bag_empty(bag_from_letters('whoa nellie')));
is-deeply(bag_from_letters('a '), bag_from_letters('a'));
is-deeply(bag_from_letters('abc'), bag_from_letters('cba'));

is-deeply(subtract(bag_from_letters('abcd'), bag_from_letters('ab')), bag_from_letters('cd'));
nok(subtract(bag_from_letters('ab'), bag_from_letters('abcd')));

is-deeply(bag_from_letters('abcdeaa').kxxv.chrs, bag_from_letters('aaabcde').kxxv.chrs);


