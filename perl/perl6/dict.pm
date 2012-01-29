#!/usr/local/src/langs/pugs/pugs
module dict;
use bag;

our @dict;

# TODO -- figure out how to use FindBin, so as to make this work
# regardless of the current directory.
my $dict_file_name = '../../words.utf8';
#my $dict_file_name = "words";

sub acceptable (Str $word) returns Bool {
  if $word ~~ m{<-alpha>} {
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

  if ($word ~~ m{<[aeiouy]>}) {
    return Bool::True ;
  }

  return Bool::False;
}

sub snarf_wordlist {
  my $dict = open($dict_file_name, :r)
    or die "Can't open $dict_file_name for reading 'cuz $!; stopped";

  warn "Reading $dict_file_name ...";

  my %dict_hash;

  for ($dict.lines) -> $word {
                                 my $chopped = lc (chomp($word));
                                 next unless (acceptable($chopped));
                                 my $bag = Bag::bag($chopped);
                                 %dict_hash{$bag}.push($chopped)
                                 unless $chopped eq any @(%dict_hash{$bag});
                                };
  warn " done; dict_hash has %dict_hash.elems() elements\n";
  close ($dict) or die "Closing $dict: $!";
  %dict_hash;
}

my $cache_file_name = "dict.cache";
if ($cache_file_name.IO ~~ :f) {
  @dict = open("dict.cache").slurp.eval(:lang<yaml>);
  say "Slurped $cache_file_name";
} else {
  say "Slurping word list ...";

  for (snarf_wordlist().pairs) -> $p {
                                      my $bag = $p[0];
                                      my @words=$p[1];
                                      push @dict, [$bag, @words];
                                     }


  {
    my $cache = open($cache_file_name, :w)
      or die "Can't open $cache_file_name for writing 'cuz $!; stopped";
    $cache.print(@dict.yaml);
    say "Wrote @dict.elems() elements to $cache_file_name";
    close ($cache) or die "Closing $cache";
  }
}

1;
