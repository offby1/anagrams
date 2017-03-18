use v6;
use Test;

unit module bag;

our sub bag_from_letters($letters) is export {
  $letters.ords.Bag
}

ok(bag_from_letters('abcdeaa') eqv bag_from_letters('aaabcde'));
is-deeply(bag_from_letters('abcdeaa').kxxv.chrs, bag_from_letters('aaabcde').kxxv.chrs);
