#!/usr/bin/env python

from __future__ import print_function

import collections
import unittest

class Bag(object):
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]

    @classmethod
    def from_number(cls, n):
        r = cls('')
        r.number = n
        return r

    def __init__(self, str):
        self.number = 1

        for c in str.lower():
            if (c >= 'a') and (c <= 'z'):
                self.number *= self.primes [ord (c) - ord ('a')]

    def empty(self):
        return self.number == 1

    def __eq__(self, other):
        return self.number == other.number

    def subtract(self, other):
        # To my surprise, using divmod here is slower.
        remainder = self.number % other.number
        if (0 == remainder):
            return self.from_number(self.number / other.number)
        else:
            return False

    def __hash__(self):
        return hash(self.number)


class WhatchaMaDingy(unittest.TestCase):
    def __init__(self, methodName='runTest'):
        self.done = False
        unittest.TestCase.__init__(self, methodName)

    def testAlWholeLottaStuff(self):
        self.assert_(Bag("").empty())

        self.assert_(not(Bag("a").empty()))

        self.assert_(Bag("abc") == Bag("cba"))

        self.assert_(Bag("abc") != Bag("bc"))

        self.assert_(Bag("a") == Bag("ab").subtract(Bag("b")))

        self.assert_(not(Bag("a").subtract(Bag("b"))))

        self.assert_(not(Bag("a").subtract(Bag("aa"))))

        silly_long_string = "When first I was a wee, wee lad\n\
        Eating on my horse\n\
        I had to take a farting duck\n\
        Much to my remorse.\n\
        Oh Sally can't you hear my plea\n\
        When Roe V Wade is nigh\n\
        And candles slide the misty morn\n\
        With dimples on your tie."

        ever_so_slightly_longer_string = silly_long_string + "x"
        self.assert_(Bag("x") == Bag(ever_so_slightly_longer_string).subtract(Bag(silly_long_string)))

        self.assert_(Bag("abc") == Bag("ABC"))

        self.done = True


class Hashable(unittest.TestCase):
    def testIt(self):
        h = {}
        h[Bag('hello')] = 3
        self.assert_(Bag('hello') in h)
        self.assert_(h[Bag('hello')] == 3)

if __name__ == "__main__":
    exit(unittest.main())
