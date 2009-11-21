#!/usr/bin/env python3.0

import string
import sys
import unittest

def bag_empty (b):
    return b == 1

def bag (str):
    str = str.lower ()
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]
    rv = 1

    for c in str:
        if (c >= 'a') and (c <= 'z'):
            rv *= primes [ord (c) - ord ('a')]

    return rv

def bags_equal (s1, s2):
    return s1 == s2

def subtract_bags (b1, b2):
    quotient  = b1 // b2
    remainder = b1 % b2
    if (0 == remainder):
        return quotient
    else:
        return 0

class WhatchaMaDingy(unittest.TestCase):
    def testAlWholeLottaStuff(self):
        self.assert_(bag("").empty())
        self.assertFalse(bag("a").empty())
        self.assertEqual(bag("abc"),bag("cba"))
        self.assertNotEqual(bag("abc"), bag("bc"))
        self.assertEqual(bag("a"), bag("ab") - bag("b"))
        self.assertFalse(bag("a") - bag("b"))
        self.assertFalse(bag("a") - bag("aa"))

        silly_long_string = """When first I was a wee, wee lad
        Eating on my horse
        I had to take a farting duck
        Much to my remorse.
        Oh Sally can't you hear my plea
        When Roe V Wade is nigh
        And candles slide the misty morn
        With dimples on your tie."""

        ever_so_slightly_longer_string = silly_long_string + "x"
        self.assertEqual(bag("x"),
                         bag(ever_so_slightly_longer_string) - bag(silly_long_string))

        self.assertEqual(bag("abc"), bag("ABC"))

if __name__ == "__main__":
    exit(unittest.main())
