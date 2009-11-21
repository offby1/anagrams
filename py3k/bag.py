#!/usr/bin/env python3.0

import string
import sys
import unittest

class Bag(object):
    @classmethod
    def fromstring(cls, str):
        str = str.lower ()
        primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]
        num = 1

        for c in str:
            if (c >= 'a') and (c <= 'z'):
                num *= primes [ord (c) - ord ('a')]

        return Bag(num)

    def __init__(self, num):
        if not isinstance(num, int):
            raise Exception("{0} {1} is not an int".format(type(num), num))

        self.num = num

    def empty(self):
        return self.num == 1

    def __eq__(self, other):
        return self.num == other.num

    def __sub__(self, other):
        quotient  = self.num // other.num
        remainder = self.num % other.num
        if (0 == remainder):
            return Bag(quotient)
        else:
            return 0
    def __hash__(self):
        return self.num.__hash__()

class WhatchaMaDingy(unittest.TestCase):
    def testAlWholeLottaStuff(self):
        self.assert_(Bag.fromstring("").empty())
        self.assertFalse(Bag.fromstring("a").empty())
        self.assertEqual(Bag.fromstring("abc"),Bag.fromstring("cba"))
        self.assertNotEqual(Bag.fromstring("abc"), Bag.fromstring("bc"))
        self.assertEqual(Bag.fromstring("a"), Bag.fromstring("ab") - Bag.fromstring("b"))
        self.assertFalse(Bag.fromstring("a") - Bag.fromstring("b"))
        self.assertFalse(Bag.fromstring("a") - Bag.fromstring("aa"))

        silly_long_string = """When first I was a wee, wee lad
        Eating on my horse
        I had to take a farting duck
        Much to my remorse.
        Oh Sally can't you hear my plea
        When Roe V Wade is nigh
        And candles slide the misty morn
        With dimples on your tie."""

        ever_so_slightly_longer_string = silly_long_string + "x"
        self.assertEqual(Bag.fromstring("x"),
                         Bag.fromstring(ever_so_slightly_longer_string) - Bag.fromstring(silly_long_string))

        self.assertEqual(Bag.fromstring("abc"), Bag.fromstring("ABC"))

if __name__ == "__main__":
    exit(unittest.main())
