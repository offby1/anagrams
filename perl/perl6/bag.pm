use v6;
use Test;

unit module bag;

class Bag {
  method empty { self.letters.empty }
    has $.letters;
};

multi sub infix:<eqv>(Bag $a, Bag $b)
  {
    say "hey $a $b";
    $a.letters eqv $b.letters;
  }
;

sub bag_from_letters($letters) is export {
  my %bag;
  for $letters.split('') -> $l {
                                my $lc = $l.lc;
                                %bag{$lc}++ if $lc ~~ 'a' .. 'z';
                               }
    Bag.new(letters => %bag);
}

ok(bag_from_letters('abcdeaa') eqv bag_from_letters('aaabcde'));
is-deeply(bag_from_letters('abcdeaa').letters, bag_from_letters('aaabcde').letters);
