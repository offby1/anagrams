#!/usr/local/src/langs/pugs/pugs
use v6;
use dict;
use bag;

sub combine (@words, @anagrams) {
  my @rv = ();

  for (@words) -> $w {
    push @rv, map { [$w, @$_] }, @anagrams;
  }

  @rv;
}

sub anagrams (Int $bag, Int $l, @dict) {
  my @rv = ();

  # I originally had ``while (@dict) { ... @dict.shift} '' but that
  # modified the input.  Grr.
  my @pruned = grep {
    Bag::subtract_bags($bag, $_[0])> 0;
  }, @dict;

  loop (;
       @pruned;
       @pruned.shift) {
    my $first = @pruned[0];
    my @rest = @pruned[1..*];
    my Int $key   = $first[0];
    my $words = $first[1];

    my $smaller_bag = Bag::subtract_bags($bag, $key);
    die "internal error" unless ($smaller_bag > 0);
    die "Uh oh: $smaller_bag isn't < $bag" unless $smaller_bag < $bag;
    my @combined;
    if (Bag::bag_empty ($smaller_bag)) {
      @combined = map { [$_]  }, @$words;
    } else {
      my @from_smaller_bag = anagrams($smaller_bag,
                                      $l + 1,
                                      @rest);
      next unless (@from_smaller_bag);
      @combined = combine($words, @from_smaller_bag);
    }
    push @rv, @combined;
  }

  return @rv;
}

sub test (Str $s) {
  say ($s => anagrams(Bag::bag($s), 0, @dict::dict).perl);
}
for (<<dog noraa>>, "noraa dog", "noraa dogx") -> $s { test ($s); }
