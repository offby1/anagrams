#!/usr/bin/env python

import StringIO
import string
import re
import sys
import cPickle
import os
from stat import *
from bag import bag, bag_empty, bags_equal, subtract_bags

has_a_vowel_re = re.compile (r'[aeiou]')
long_enough_re = re.compile (r'^i$|^a$|^..')
non_letter_re = re.compile (r'[^a-zA-Z]')

def snarf_dictionary_from_IO (I):
    print >> sys.stderr, "Snarfing", I
    hash_table = {}
    for w in re.findall (r'.+', I.read ()):
        w = string.lower (w)
        if non_letter_re.search (w):
            continue
        if (not long_enough_re.match (w)):
            continue
        if (not has_a_vowel_re.search (w)):
            continue

        key = bag(w)
        if hash_table.has_key (key):
            if (0 == hash_table[key].count (w)): # avoid duplicates
                hash_table[key].append (w)
        else:
            hash_table[key] = [w]

    print >> sys.stderr, "done"
    return hash_table

hash_cache = "hash.cache"

def snarf_dictionary (fn):
    try:
        fh = open (hash_cache, "rb")
        rv= cPickle.load (fh)
        print >> sys.stderr, "Reading cache", hash_cache, "instead of dictionary", fn
    except:
        fh = open (fn, "r")
        rv = snarf_dictionary_from_IO (fh)
        fh.close ()
        fh = open (hash_cache, "wb")
        cPickle.dump (rv, fh, 2)

    fh.close ()
    return rv


fake_input = "cat\ntac\nfred\n"
fake_dict = snarf_dictionary_from_IO (StringIO.StringIO (fake_input))

assert (2 == len (fake_dict.keys ()))
cat_hits = fake_dict[bag ("cat")]
assert (2 == len (cat_hits))
assert (cat_hits[0] == "cat")
assert (cat_hits[1] == "tac")
assert (1 == len (fake_dict[bag ("fred")]))
assert (fake_dict[bag ("fred")][0] == "fred")

print >> sys.stderr, __name__, "tests passed."
