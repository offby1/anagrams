#!/usr/bin/env perl

use warnings;
use strict;

package dict;
use Carp qw(cluck carp);
use Data::Dumper;
use bag;
use Math::BigInt;
use base 'Exporter';

our @EXPORT = qw(@dict init);

our @dict;
our $dict_hash;
my $cache_file_name = "dict-cache";

sub init {
  my $bag = shift;

  unless (-r $cache_file_name) {
    foreach my $dict_file_name (qw(/usr/share/dict/words /usr/share/dict/american-english)) {
      next unless (open (DICT, "<", $dict_file_name));

      print STDERR "Reading $dict_file_name ... ";

      while (<DICT>) {
        chomp;
        ($_ = $_) =~ s<\015$><>;
        ($_ = $_) =~ s< +$><>;
        next unless $_;

        $_ = lc ($_);

        my $b = bag ($_);

        next if (m([^[:alpha:]]));
        next if (m([^[:ascii:]]));
        next unless ((m(^i$))
                     ||
                     (m(^a$))
                     ||
                     (m(^..)));
        next unless (m([aeiou]));

        my $entry = $dict_hash->{"$b"};

        if (defined ($entry)) {
          my $duplicate;
          foreach my $existing_entry (@$entry) {
            if ($_ eq $existing_entry) {
              $duplicate = 1;
              last;
            }
          }

          next if ($duplicate);
        }

        #die "entering $_; dict is now " . Data::Dumper->Dump ([$dict], [qw(dict)]) if ($. > 10);
        push @{$dict_hash->{"$b"}}, $_;
      }
      close (DICT)
        or die "Can't close filehandle: $!; stopped";

      if (open (DICT_CACHE, ">", $cache_file_name)) {
        print DICT_CACHE Data::Dumper->Dump ([$dict_hash], [qw(dict_hash)]);
        close (DICT_CACHE);
        warn "Wrote $cache_file_name";
      }
      warn " done.";
      last;
    }
  }
  print STDERR "Snarfing pre-processed dictionary $cache_file_name ... ";

  do $cache_file_name or die "$cache_file_name doesn't exist";

  {
    my $words_seen = 0;
    local $noisy = 1;
    while ((my $k, my $v) = (each %$dict_hash)) {
      $words_seen += scalar (@$v);
      my $makeable = subtract_bags ($bag, Math::BigInt->new ($k));
      #cluck "$bag minus $k is $makeable";
      if (defined ($makeable)) {
        push @dict, [($k, [sort (@$v)])];
      }
    }
    print STDERR "($words_seen words) ... ";
  }
  # just for fun, let's sort the dictionary.  Biggest words first.
  @dict = (sort {length ($b->[0])
                   <=>
                     length ($a->[0])} @dict);

  my @flattened = map {@{$_->[1]}} @dict;
  print STDERR "After pruning and sorting: "
    . scalar (@flattened)
      . " words.\n";
}
1;
