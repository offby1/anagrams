#!/usr/bin/env python

from __future__ import print_function

import collections
import functools
import unittest


@functools.total_ordering
class Bag(object):
    def __init__(self, str):
        self.c = collections.Counter([c.lower() for c in str])

    def empty(self):
        return len(self.c) == 0

    def __eq__(self, other):
        return self.c == other.c

    def __lt__(self, other):
        return self.c < other.c

    def subtract(self, other):
        top = collections.Counter(self.c)
        top.subtract(other.c)
        if any([x < 0 for x in top.values()]):
            return False
        return Bag(top.elements())

    def __hash__(self):
        return str(self).__hash__()

    def __str__(self):
        return ''.join(self.c.elements())


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
