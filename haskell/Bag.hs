-- -*-haskell-*-

module Bag (make_bag, subtract_bags, empty, bags_equal) where
import Char

-- represents an unordered multi-set of characters.  

-- The most important operation is "subtracting" bags.  Imagine you've
-- got one bag of scrabble tiles -- containing, say, two "d"s, an "o",
-- and an "x", and you want to know if you can make the word "dog"
-- from that.  You'd look first at the "d" in "dog", and note that the
-- bag contains a "d", so you'd keep looking ... the bag also contains
-- an "o" ... ah, but the bag contains no "g", so you'd determine that
-- the subtraction "failed".  On the other hand, if you'd wanted to
-- make the word "ox", the subtraction would succeed, and you'd have
-- two "d"s left over.

-- So that's subtraction.  (Actually, despite the above example, we
-- don't subtract a _string_ from a bag; instead we subtract another
-- bag.  But that's a detail.)
                           
-- The implementation is intended to make subtraction fast, although
-- to be sure I haven't tested alternate techniques in Haskell.  Each
-- bag is just a large integer, made of the product of letter codes --
-- each letter's code is a small prime.  This makes subtracting bags
-- very easy: to subtract bag b from bag a, we first compute the
-- remainder from a/b, and if it's non-zero, then the subtraction
-- "fails".  But if it's zero, the subtraction succeeds, and the
-- quotient represents what's left over.  I don't know where I got
-- this idea, or even if it's original.

-- to make a bag from a string, just multiply the primes corresponding
-- to each letter.
make_bag :: String -> Integer
make_bag []     = 1
make_bag (c:cs) = char_prime (c) * make_bag cs

-- thanks to "Cale" (Cale Gibbard
-- (i=foobar@London-HSE-ppp3543475.sympatico.ca)) for "primes"
primes = sieve [2..]; sieve (x:xs) = x : sieve [y | y <- xs, y `mod` x /= 0]

-- return the prime for this character.  If it's not a letter, just
-- return 1, which effectively ignores the character.
char_prime :: Char -> Integer
char_prime c | (lc >= 'a') && (lc <= 'z') = primes !! (ord (lc) - ord('a'))
             | True = 1
             where lc = toLower (c)

-- here's the meat.  It's mighty simple; this simplicity is probably
-- the main reason I didn't implement bags as maps from chars to
-- integers, or as unordered strings -- those implementations would
-- require a bit more work in this function.
-- We indicate failure by returning 0.
subtract_bags :: Integer -> Integer -> Integer
subtract_bags top bot = let r = rem top bot in
                            if (r == 0) then quot top bot else 0

-- to test this, start ghci, and type
-- :load Bag.hs
--  print "Hello, world "
--  print (make_bag ("Hello, world"))

-- that last should print 828806486967613

-- subtract_bags (make_bag ("ola")) (make_bag ("lo")) => 2

empty b = (b == 1)
bags_equal b1 b2 = (b1 == b2)
