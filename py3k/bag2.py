#!/usr/bin/env python3.1

import collections
import itertools
import string
import sys
import unittest

class bag(object):
    """
    Just like collections.defaultdict(int), except hashable.
    """
    def __init__(self, input):
        if isinstance(input, str):
            self.dict = collections.Counter([c for c in input.lower() if c.isalpha()])
        elif isinstance(input, collections.Counter):
            self.dict = input

    def __str__(self):
        return str(self.dict)

    def empty (self):
        return len(self.dict) == 0

    def __hash__(self):
        # Probably grossly inefficient
        return self.__str__().__hash__()
    def __eq__ (self, other):
        rv = (self.dict == other.dict)
        return rv

    def equal(self, other):
        return self.__eq__(other)

    def subtract (self, subtrahend):
        new = collections.Counter()
        #print("{0} minus {1} ... ".format(self, subtrahend), end='')
        for letter in set(itertools.chain(self.dict.keys(),subtrahend.dict.keys())):
            diff = self.dict[letter] - subtrahend.dict[letter]
            if diff < 0:
                #print("bzzt")
                return False
            elif diff > 0:
                new[letter] = diff

        rv = bag(new)
        #print(rv)
        return rv

def bag_empty(b):
    return b.empty()
def bags_equal(b1, b2):
    #print("{0} == {1} => ".format(b1, b2), end='')
    rv = b1.equal(b2)
    #print(rv)
    return rv
def subtract_bags(b1, b2):
    return b1.subtract(b2)

class WhatchaMaDingy (unittest.TestCase):
    def __init__ (self, methodName='runTest'):
        self.done = False
        unittest.TestCase.__init__ (self, methodName)

    def testAlWholeLottaStuff (self):
        self.assert_ (bag_empty (bag ("")))

        self.assert_ (not (bag_empty (bag ("a"))))

        self.assert_ (bags_equal (bag ("abc"),
                                  bag ("cba")))

        self.assert_ (not (bags_equal (bag ("abc"),
                                       bag ("bc"))))

        self.assert_ (bags_equal (bag ("a"),
                                  subtract_bags (bag("ab"),
                                                 bag ("b"))))
        self.assert_ (not (subtract_bags (bag ("a"),
                                          bag ("b"))))

        self.assert_ (not (subtract_bags (bag ("a"),
                                          bag ("aa"))))

        silly_long_string = "When first I was a wee, wee lad\n\
        Eating on my horse\n\
        I had to take a farting duck\n\
        Much to my remorse.\n\
        Oh Sally can't you hear my plea\n\
        When Roe V Wade is nigh\n\
        And candles slide the misty morn\n\
        With dimples on your tie."

        ever_so_slightly_longer_string = silly_long_string + "x"
        self.assert_ (bags_equal (bag ("x"),
                                  subtract_bags (bag (ever_so_slightly_longer_string),
                                                 bag (silly_long_string))))

        self.assert_ (bags_equal (bag ("abc"),
                                  bag ("ABC")))

        self.done = True;

if __name__ == "__main__":
    exit(unittest.main ())
