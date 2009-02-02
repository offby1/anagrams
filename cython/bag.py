#!/usr/bin/env python

import string
import sys
import unittest

def bag_empty (b):
    return b == 1

max_ulong_long = 2L**64 - 1

def bag (str):
    str = string.lower (str)
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]
    rv = 1

    for c in str:
        if (c >= 'a') and (c <= 'z'):
            rv *= primes [ord (c) - ord ('a')]

    if rv > max_ulong_long:
        raise Exception("Uh oh -- %s turns into %d, which is bigger than %d" %
                        (str, rv, max_ulong_long))
    return rv

def bags_equal (s1, s2):
    return s1 == s2

def subtract_bags (b1, b2):
    quotient  = b1 / b2
    remainder = b1 % b2
    if (0 == remainder):
        return quotient
    else:
        return 0

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
