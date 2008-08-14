#!/usr/local/src/langs/pugs/pugs
module Bag;
my @primes = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101);
my $a_code = ord ('a');

sub char_to_factor (Str $char) returns Int {
  my $lc_char = lc ($char);

  if ($lc_char ~~ m:perl5/[^[:alpha:]]/) {
    return 1;
  }

  return @primes[ord($lc_char) - $a_code];
}


sub bag (Str $thing) returns Int {

  my $product = 1;

  for (split('', $thing)) {
    my $factor = char_to_factor ($_);
    $product *=  $factor;
  }

  return $product;
}

sub bag_empty (Int $thing) returns Bool {
  1 == $thing;
}

sub bags_equal (Int $thing1, Int $thing2) returns Bool {
  $thing1 == $thing2;
}

sub subtract_bags (Int $b1, Int $b2) returns Int {

  if (0 == ($b1 % $b2)) {

    return truncate($b1 / $b2);
  }

  # I thought i'd be neat to say "return 1 but False" here, but that
  # causes some self-test to die with

  # *** Cannot cast from VBool False to Pugs.AST.Internals.VCode (VCode)
  #   at <prelude> line 466, column 5-16
  return 0;
}


die "bag_empty 1"
  unless (bag_empty(bag("")));

die "bag_empty 2"
  if (bag_empty(bag("a")));

die "didn't ignore a space"
  unless (bags_equal(bag("a "),
                     bag("a")));

die "bags_equal 1"
  unless (bags_equal(bag("abc"),
                     bag("cba"))) ;

die "bags_equal 2"
  if (bags_equal(bag("abc"),
                 bag("bc")));

die "subtract_bags 1"
  unless (bags_equal(bag("a"),
                     subtract_bags(bag("ab"),
                                   bag("b")))) ;

die "subtract_bags 2"
  if (subtract_bags(bag("a"),
                    bag("b")));

die "subtract_bags 3"
  if (subtract_bags(bag("a"),
                    bag("aa")));

{
  my $silly_long_string = "
When first I was a wee, wee lad
Eating on my horse
I had to take a farting duck
Much to my remorse.
Oh Sally can't you hear my plea
When Roe V Wade is nigh
And candles slide the misty morn
With dimples on your tie.
";

  my $ever_so_slightly_longer_string = $silly_long_string ~ "x";
  die "subtract_bags"
    unless (bags_equal(bag("x"),
                       subtract_bags(bag($ever_so_slightly_longer_string),
                                     bag($silly_long_string))));
}

die "Unpickling"
  unless (bags_equal(bag("cat"), 2 * 5 * 71));

print "We cool!\n";
1;
