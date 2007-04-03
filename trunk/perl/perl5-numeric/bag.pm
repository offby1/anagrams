#!/usr/bin/env perl

use warnings;
use strict;

package bag;

use Math::BigInt;
use Carp qw(cluck confess carp croak);
use Data::Dumper;
use Test::More qw(no_plan);

use base 'Exporter';
our @EXPORT = qw(bag bag_empty bags_equal subtract_bags $noisy);

my @primes=qw(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101);

our $noisy = 0;
sub bag {
  my $input = lc (shift);
  my $output = new Math::BigInt (1);
  foreach (grep { $_ <= ord ('z') && $_ >= ord('a')}
           (map {ord($_)} split (m(), $input))) {
    $output *= $primes[$_ - ord('a')];
  }
  warn scalar( Data::Dumper->Dump ([$input, $output], [qw(input output)]))
    if $noisy;
  $output;
}

sub bag_empty {
  1 == shift;
}

sub bags_equal {
  my ($a, $b)= @_;
  $a == $b;
}

sub subtract_bags {
  my ($top, $bottom) = @_;

  my $rv;

  if ($top % $bottom) {
    $rv = undef ;
  } else {
    $rv = $top / $bottom;
  }

  warn scalar( Data::Dumper->Dump ([$top, $bottom, $rv], [qw(top bottom rv)]))
    if $noisy;

  return $rv;
}


ok (bags_equal (bag ("HEY"),
                bag ("hey")),
    "Case insensitive");

ok (bag_empty (bag ("")), "bag_empty");

ok (!bag_empty (bag ("a")), "bag_empty");

ok (bags_equal (bag ("abc"),
                bag ("cba")),
    "bags_equal") ;

ok (!bags_equal (bag ("abc"),
                bag ("bc")),
    "bags_equal");

ok (!bags_equal (bag ("abc"),
                 bag ("a")),
    "bags_equal");


ok (bags_equal (bag ("a "),
                (bag ("a"))),
    "ignores spaces");

{
  my $oughta_be_empty = subtract_bags (bag ("a"),
                                       bag ("a"));
  ok( defined ($oughta_be_empty),  "subtract_bags");

  ok (bag_empty ($oughta_be_empty),
      "subtract_bags");
}

ok (bags_equal (bag ("a"),
                subtract_bags (bag("ab"),
                               bag ("b"))),
    "subtract_bags") ;

ok (!subtract_bags (bag ("a"),
                    bag ("b")),
    "subtract_bags");

ok (!subtract_bags (bag ("a"),
                    bag ("aa")),
    "subtract_bags");

ok (!subtract_bags (141, 123093),  "subtract_bags");

ok (bags_equal (bag ("x"),
                subtract_bags (bag ("foox"),
                               bag ("foo"))),
    "subtract_bags");
{
  my $silly_long_string = <<EOF;
When first I was a wee, wee lad
Eating on my horse
I had to take a farting duck
Much to my remorse.
Oh Sally can't you hear my plea
When Roe V Wade is nigh
And candles slide the misty morn
With dimples on your tie.
EOF

  my $ever_so_slightly_longer_string = $silly_long_string . "x";

  ok (bags_equal (bag ("x"),
                  subtract_bags (bag ($ever_so_slightly_longer_string),
                                 bag ($silly_long_string))),
      "subtract_bags");
}

1;
