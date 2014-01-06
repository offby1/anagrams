#!/usr/bin/env python3.0

import bag
import collections
from io import StringIO
import os
import pickle
import re
from stat import *
import string
import sys

has_a_vowel_re = re.compile(r'[aeiouy]')
long_enough_re = re.compile(r'^i$|^a$|^..')
non_letter_re  = re.compile(r'[^a-zA-Z]')


def word_acceptable(w):
    if non_letter_re.search(w):
        return False
    if not long_enough_re.match(w):
        return False
    if not has_a_vowel_re.search(w):
        return False

    return True

default_dict_name = os.path.join(os.path.dirname(__file__), "../words.utf8")


def snarf_dictionary_from_IO(I):
    print("Snarfing", I, file=sys.stderr)
    hash_table = collections.defaultdict(set)
    for w in re.findall(r'.+', I.read()):
        w = w.lower()
        if not word_acceptable(w):
            continue

        key = bag.Bag(w)
        hash_table[key].add(w)

    print("done", file=sys.stderr)
    return hash_table

hash_cache = os.path.join(os.path.dirname(__file__), "hash.cache")


def snarf_dictionary(fn):
    try:
        fh = open(hash_cache, "rb")
        rv = pickle.load(fh)
        print("Reading cache", hash_cache, "instead of dictionary", fn, file=sys.stderr)
    except:
        fh = open(fn, "r", encoding='utf_8')
        rv = snarf_dictionary_from_IO(fh)
        fh.close()
        fh = open(hash_cache, "wb")
        pickle.dump(rv, fh, 2)

    fh.close()
    return rv


if __name__ == "__main__":
    import unittest

    class TestStuff(unittest.TestCase):
        def setUp(self):
            self.fake_input = "cat\ntac\nfred\n"
            self.fake_dict = snarf_dictionary_from_IO(StringIO(self.fake_input))

        def test_word_acceptable(self):
            self.assertTrue(word_acceptable("dog"))
            self.assertFalse(word_acceptable("C3PO"))
            d = snarf_dictionary(os.path.join(default_dict_name))
            self.assertEqual(66965, len(d))
            self.assertEqual(72794, sum(len(words) for words in d.values()))

        def test_this_and_that(self):
            self.assertEqual(2, len(self.fake_dict.keys()))
            cat_hits = sorted(self.fake_dict[bag.Bag("cat")])
            self.assertEqual(2, len(cat_hits))
            self.assertEqual(cat_hits[0], "cat")
            self.assertEqual(cat_hits[1], "tac")
            self.assertEqual(1, len(self.fake_dict[bag.Bag("fred")]))
            self.assertEqual(list(self.fake_dict[bag.Bag("fred")])[0], "fred")

    unittest.main()
