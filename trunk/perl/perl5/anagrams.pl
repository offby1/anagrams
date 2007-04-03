#!/usr/bin/perl

use strict;
use Data::Dumper;
use Carp qw(confess);

use dict;
use bag;

sub combine {
  my $words = shift;
  my $anagrams = shift;
  my @rv = ();

  foreach my $w (@$words) {
    push @rv, (map {[($w, @$_)]} @$anagrams);
  }

  @rv;
}

sub anagrams {
  my $bag = shift;
  my @dict = @_;
  my $rv = [];

  while (@dict) {
    my $entry = shift @dict;
    my $key   = $entry->[0];
    my $words = $entry->[1];

    my $smaller_bag = subtract_bags ($bag, $key);
    next unless (defined ($smaller_bag));

    if (bag_empty ($smaller_bag)) {
      push @$rv, map { [$_]  } @$words;
      next;
    }

    my $from_smaller_bag = anagrams ($smaller_bag,
                                     grep {defined (subtract_bags ($smaller_bag, $_->[0]));} @dict);
    next unless (@$from_smaller_bag);

    push @$rv, combine ($words, $from_smaller_bag);
  }

  return $rv;
}

{
  my $input = shift;
  die "Say something!" unless defined ($input);
  my $input_as_bag = bag ($input);
  init ($input_as_bag);

  my $result = anagrams ($input_as_bag, @dict);
  print STDERR scalar (@$result),
    " anagrams of $input:\n";
  print join (' ', map { "(" . join (' ', @$_) . ")" } @$result),
        "\n";
}
