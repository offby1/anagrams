#!/usr/bin/env python

from __future__ import print_function

# Core
import StringIO
import cPickle
import collections
import os
import re
import sys
import unittest

# Local
from bag import Bag

has_a_vowel_re = re.compile(r'[aeiouy]')
long_enough_re = re.compile(r'^i$|^a$|^..')
non_letter_re = re.compile(r'[^a-z]')


def word_acceptable(w):
    if non_letter_re.search(w):
        return False
    if (not long_enough_re.match(w)):
        return False
    if (not has_a_vowel_re.search(w)):
        return False

    return True

default_dict_name = os.path.join(os.path.dirname(__file__), "../words.utf8")


def snarf_dictionary(inf):
    print("Snarfing {}".format(inf.name), file=sys.stderr)
    hash_table = collections.defaultdict(set)
    for w in inf:
        w = w.lower().rstrip()

        if not word_acceptable(w):
            continue

        key = Bag(w)
        hash_table[key].add(w)

    print("done", file=sys.stderr)
    return hash_table

hash_cache = os.path.join(os.path.dirname(__file__), "hash.cache")


def snarf_dictionary_from_file(fn):
    try:
        with open(hash_cache, "rb") as inf:
            rv = cPickle.load(inf)
            print("Reading cache {} instead of dictionary {}".format(hash_cache, fn), file=sys.stderr)
            return rv
    except IOError:
        pass

    with open(fn) as inf:
        rv = snarf_dictionary(inf)

    with open(hash_cache, "wb") as outf:
        cPickle.dump(rv, outf, 2)

    return rv


if __name__ == "__main__":
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

    unittest.main()
