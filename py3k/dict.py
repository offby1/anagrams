#!/usr/bin/env python3.0

from io import StringIO
import string
import pickle
import re
import sys
import os
from stat import *
import bag

has_a_vowel_re = re.compile (r'[aeiouy]')
long_enough_re = re.compile (r'^i$|^a$|^..')
non_letter_re = re.compile (r'[^a-zA-Z]')

def snarf_dictionary_from_IO (I):
    print ("Snarfing", I, file=sys.stderr)
    hash_table = {}
    for w in re.findall (r'.+', I.read ()):
        w = w.lower ()
        if non_letter_re.search (w):
            continue
        if (not long_enough_re.match (w)):
            continue
        if (not has_a_vowel_re.search (w)):
            continue

        key = bag.bag(w)
        if key in hash_table:
            if (0 == hash_table[key].count (w)): # avoid duplicates
                hash_table[key].append (w)
        else:
            hash_table[key] = [w]

    print ("done", file=sys.stderr)
    return hash_table

hash_cache = os.path.join(os.path.dirname(__file__), "hash.cache")

def snarf_dictionary (fn):
    try:
        fh = open (hash_cache, "rb")
        rv= pickle.load (fh)
        print ("Reading cache", hash_cache, "instead of dictionary", fn, file=sys.stderr)
    except:
        fh = open (fn, "r", encoding='utf_8')
        rv = snarf_dictionary_from_IO (fh)
        fh.close ()
        fh = open (hash_cache, "wb")
        pickle.dump (rv, fh, 2)

    fh.close ()
    return rv


fake_input = "cat\ntac\nfred\n"
fake_dict = snarf_dictionary_from_IO (StringIO (fake_input))

assert (2 == len (fake_dict.keys ()))
cat_hits = fake_dict[bag.bag ("cat")]
assert (2 == len (cat_hits))
assert (cat_hits[0] == "cat")
assert (cat_hits[1] == "tac")
assert (1 == len (fake_dict[bag.bag ("fred")]))
assert (fake_dict[bag.bag ("fred")][0] == "fred")

print (__name__, "tests passed.", file=sys.stderr)
