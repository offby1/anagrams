#!/usr/bin/env perl

use warnings;
use strict;

package bag;

use Carp qw(cluck confess);
use Data::Dumper;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(bag bag_empty bags_equal subtract_bags);

sub bag {
  my $input = lc (shift);
  my $output = join ('',
                     sort grep { ord($_) <= ord ('z')
                                   && ord($_) >= ord('a')}
                     (split (m(), $input)));
  $output;
}

sub bag_empty {
  ! shift;
}

sub bags_equal {
  shift eq shift;
}

sub subtract_bags {
  my $b1 = shift;
  my $b2 = shift;
  my $difference = "";

  while (1) {
    my $c1 = substr ($b1, 0, 1);
    my $c2 = substr ($b2, 0, 1);

    return $difference . $b1 if (!$c2);
    return undef             if (!$c1);
    next                     if ($c1 eq $c2);

    my $comparison = ($c1 cmp $c2);
    while ($comparison < 0) {

      return undef if (!$c1);

      $difference .= $c1;

      $b1 = substr ($b1, 1);
      $c1 = substr ($b1, 0, 1);
      $comparison = ($c1 cmp $c2);
    }

    return undef if ($comparison > 0);

  } continue {
    $b1 = substr ($b1, 1);
    $b2 = substr ($b2, 1);
  }

  return $difference;
}


die "Case sensitive"
  unless (bags_equal (bag ("HEY"),
                     bag ("hey")));

die "bag_empty"
  unless (bag_empty (bag ("")));

die "bag_empty"
  if (bag_empty (bag ("a")));

die "bags_equal"
  unless (bags_equal (bag ("abc"),
                      bag ("cba"))) ;

die "bags_equal"
  if (bags_equal (bag ("abc"),
                  bag ("bc")));

die "bags_equal"
  if (bags_equal (bag ("abc"),
                  bag ("a")));

die "didn't ignore a space"
  unless (bags_equal (bag ("a "),
                     (bag ("a"))));
{
  my $oughta_be_empty = subtract_bags (bag ("a"),
                                       bag ("a"));
  die "subtract_bags"
    unless defined ($oughta_be_empty);
  die "subtract_bags"
    unless (bag_empty ($oughta_be_empty));
}

die "subtract_bags"
  unless (bags_equal (bag ("a"),
                      subtract_bags (bag("ab"),
                                     bag ("b")))) ;

die "subtract_bags"
  if (subtract_bags (bag ("a"),
                     bag ("b")));

die "subtract_bags"
  if (subtract_bags (bag ("a"),
                     bag ("aa")));

die "subtract_bags"
  if (subtract_bags (141, 123093));

die "subtract_bags"
  unless (bags_equal (bag ("x"),
                      subtract_bags (bag ("foox"),
                                     bag ("foo"))));
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
  die "subtract_bags"
    unless (bags_equal (bag ("x"),
                        subtract_bags (bag ($ever_so_slightly_longer_string),
                                       bag ($silly_long_string))));
}

print STDERR "We cool!\n";

1;
