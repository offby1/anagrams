use v6;
use Test;

use bag;

plan 8;

is_deeply(bag_from_letters('abcdeaa'), bag_from_letters('aaabcde'));
is_deeply(bag_from_letters('AB!!!c'), bag_from_letters('abc'));
ok(bag_empty(bag_from_letters('')));
nok(bag_empty(bag_from_letters('whoa nellie')));
is_deeply(bag_from_letters('a '), bag_from_letters('a'));
is_deeply(bag_from_letters('abc'), bag_from_letters('cba'));

is_deeply(subtract(bag_from_letters('abcd'), bag_from_letters('ab')), bag_from_letters('cd'));
nok(subtract(bag_from_letters('ab'), bag_from_letters('abcd')));

done;
