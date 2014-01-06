#!/usr/bin/env python3

import unittest


class Bag(object):
    _primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]

    __slots__ = 'num'

    def __init__(self, str):
        num = 1

        for c in str.lower():
            if (c >= 'a') and (c <= 'z'):
                num *= self._primes[ord(c) - ord('a')]

        self.num = num

    def empty(self):
        return self.num == 1

    def __repr__(self):
        return repr(self.num)

    def __eq__(self, other):
        return self.num == other.num

    def __hash__(self):
        return self.num.__hash__()

    def __sub__(self, other):
        remainder = self.num % other.num
        if (0 == remainder):
            rv = Bag("")
            rv.num = self.num // other.num
            return rv
        else:
            return 0


class WhatchaMaDingy(unittest.TestCase):
    def testAlWholeLottaStuff(self):
        self.assertTrue(Bag("").empty())
        self.assertFalse(Bag("a").empty())
        self.assertEqual(Bag("abc"), Bag("cba"))
        self.assertNotEqual(Bag("abc"), Bag("bc"))
        self.assertEqual(Bag("a"), Bag("ab") - Bag("b"))
        self.assertFalse(Bag("a") - Bag("b"))
        self.assertFalse(Bag("a") - Bag("aa"))

        silly_long_string = """When first I was a wee, wee lad
        Eating on my horse
        I had to take a farting duck
        Much to my remorse.
        Oh Sally can't you hear my plea
        When Roe V Wade is nigh
        And candles slide the misty morn
        With dimples on your tie."""

        ever_so_slightly_longer_string = silly_long_string + "x"
        self.assertEqual(Bag("x"),
                         Bag(ever_so_slightly_longer_string) - Bag(silly_long_string))

        self.assertEqual(Bag("abc"), Bag("ABC"))

if __name__ == "__main__":
    exit(unittest.main())
