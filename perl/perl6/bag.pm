use v6;
use Test;

unit module bag;

our sub bag_from_letters($letters) is export {
  $letters.lc.ords.grep({ 'a'.ord <= $_ <= 'z'.ord}).Bag
}

our sub bag_empty(Bag $b) is export {
    $b ~~ 0
}

our sub subtract (Bag $top, Bag $bottom) is export {
    ($bottom (<=) $top) and $top (-) $bottom
}
