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

sub anagrams (Bag $bag, @dict) {
  my @rv = ();

  # I originally had ``while (@dict) { ... @dict.shift} '' but that
  # modified the input.  Grr.
  my @pruned = @dict.grep({subtract($bag, $_.key) > 0}) ;

  loop (;
       @pruned;
       @pruned.shift) {
    my $first = @pruned[0];
    my @rest = @pruned[1..*];
    my Bag $key   = $first.key;
    my $words = $first[1];

    dd $bag, $key, @pruned;

    my $smaller_bag = subtract($bag, $key);
    dd $smaller_bag;
    die "internal error" unless ($smaller_bag > 0);
    die "Uh oh: $smaller_bag isn't < $bag" unless $smaller_bag < $bag;
    my @combined;
    if (bag_empty ($smaller_bag)) {
      @combined = map { [$_]  }, @$words;
    } else {
      my @from_smaller_bag = anagrams($smaller_bag,
                                      @rest);
      next unless (@from_smaller_bag);
      @combined = combine($words, @from_smaller_bag);
    }
    push @rv, @combined;
  }

  return @rv;
}

sub test (Str $s) {
  say ($s => anagrams(bag_from_letters($s), @dict::dict).perl);
}
for (
    # "dog noraa",
    "dogdog",
    # "noraa dog",
    # "noraa dogx"
) -> $s { test ($s); }
