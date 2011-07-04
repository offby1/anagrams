use v6;
use Test;

class Bag {
    method empty { self.letters.empty }
    has $.letters;
};

our multi sub infix:<eqv>(Bag $a, Bag $b)
{
    say "hey $a $b";
    $a.letters eqv $b.letters;
};

sub bag_from_letters($letters) {
    my %bag;
    for $letters.split('') -> $l {
        my $lc = $l.lc;
        %bag{$lc}++ if $lc ~~ 'a' .. 'z';
    }
    Bag.new(letters => %bag);
}

ok(bag_from_letters('abcdeaa') eqv bag_from_letters('aaabcde'));
is_deeply(bag_from_letters('abcdeaa'), bag_from_letters('aaabcde'));
