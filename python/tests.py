#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import print_function
from __future__ import unicode_literals

import os
import unittest

from bag import Bag
from dict import (
    default_dict_name,
    snarf_dictionary_from_file,
    word_acceptable
)


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


class TestStuff(unittest.TestCase):
    def setUp(self):
        self.fake_input = "cat\ntac\nfred\n"
        self.fake_dict = {Bag('cat'): set(['cat', 'tac']), Bag('fred'): set(['fred'])}

    def test_word_acceptable(self):
        self.assert_(word_acceptable("dog"))
        self.assertFalse(word_acceptable("C3PO"))
        d = snarf_dictionary_from_file(os.path.join(default_dict_name))
        self.assertEqual(66965, len(d))
        self.assertEqual(72794, sum(len(words) for words in d.values()))

    def test_this_and_that(self):
        self.assert_(2 == len(self.fake_dict.keys()))
        cat_hits = self.fake_dict[Bag("cat")]
        self.assert_(2 == len(cat_hits))
        self.assert_(cat_hits == set(["cat", "tac"]))
        self.assert_(1 == len(self.fake_dict[Bag("fred")]))
        self.assert_(self.fake_dict[Bag("fred")] == set(["fred"]))

if __name__ == "__main__":
    exit(unittest.main())
