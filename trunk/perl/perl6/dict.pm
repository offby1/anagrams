#!/usr/local/src/langs/pugs/pugs
module dict;
use bag;

our @dict;

# I originally had `our %dict_hash', which works exactly the same
# way. But this will, supposedly in a future version of pugs, limit
# the hash keys to Ints, which might improve performance, or provide
# error-checking, or something.
our Any %dict_hash{Int};

my $dict_file_name = "/usr/share/dict/words";
#my $dict_file_name = "words";

sub acceptable (Str $word) returns Bool {
  if ($word ~~ rx:perl5{[^[:alpha:]]}) {
    return Bool::False ;
  }

  if ($word ~~ "i") {
    return Bool::True ;
  }

  if ($word ~~ "a") {
    return Bool::True ;
  }

  if ($word.chars < 2) {
    return Bool::False ;
  }

  # Testing only
  if ($word.chars > 4) {
    return Bool::False ;
  }

  if ($word ~~ rx:perl5{[aeiou]}) {
    return Bool::True ;
  }

  return Bool::False;
}

# Don't put more than this many words into our hash.  Useful only for
# debugging, since reading the whole dictionary is really really slow.
my $max_words is constant = 1000;

sub snarf_wordlist {
  my $dict = open($dict_file_name, :r)
    or die "Can't open $dict_file_name for reading 'cuz $!; stopped";

  print $*ERR: "Reading $dict_file_name ...";

  for ($dict.readline) -> $word {
                                 my $chopped = lc (chomp($word));
                                 next unless (acceptable($chopped));
                                 my $entry = %dict_hash{Bag::bag($chopped)};
                                 $entry.push($chopped);
                                 $entry = $entry.uniq;
                                 if (%dict_hash.elems == $max_words) {
                                   say "read enough words; won't read no mo'";
                                   last;
                                 }
                                };
  print $*ERR: " done\n";
  close ($dict) or die "Closing $dict: $!";

}

my $cache_file_name = "dict.cache";
if (-f $cache_file_name) {
  %dict_hash = open("dict.cache").slurp.eval(:lang<yaml>);
  say "Slurped $cache_file_name";
} else {
  say "Slurping word list ...";
  snarf_wordlist();
  {
    my $cache = open($cache_file_name, :w)
      or die "Can't open $cache_file_name for writing 'cuz $!; stopped";
    $cache.print(%dict_hash.yaml);
    say "Wrote $cache";
    close ($cache) or die "Closing $cache";
  }
}

say "Word list hath ", %dict_hash.elems, " pairs";
for (%dict_hash.keys) -> $bag {
                          my @words = %dict_hash{$bag};
                               push @dict, [$bag, @words];
                         }

1;
