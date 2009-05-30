#!/usr/bin/env python3.0

import collections
import string
import sys
import unittest

class bag(object):
    """
    Just like collections.defaultdict(int), except hashable.
    """
    def __init__(self, str):
        str = str.lower ()

        self.dict = collections.defaultdict(int)

        for c in str:
            if (c >= 'a') and (c <= 'z'):
                self.dict[c] += 1

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

    def subtract (self, subtrahend):
        new = self.dict.copy()
        for letter in subtrahend.dict.keys():
            if letter not in self.dict:
                return False
            new[letter] -= subtrahend.dict[letter]
            if new[letter] < 0:
                return False
            # garbage collection! :)
            elif new[letter] == 0:
                del new[letter]
        rv = bag('')
        rv.dict = new
        return rv

def bag_empty(b):
    return b.empty()
def bags_equal(b1, b2):
    return b1.equal(b2)
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
