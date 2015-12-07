#!/usr/bin/env python

from __future__ import print_function

# Core
import collections
import os
import re
import sys

# Local
from bag import Bag

has_a_vowel_re = re.compile(r'[aeiouy]')
long_enough_re = re.compile(r'^i$|^a$|^..')
non_letter_re = re.compile(r'[^a-z]')

default_dict_name = os.path.join(os.path.dirname(__file__), "../words.utf8")


def snarf_dictionary_from_file(fn):
    print("Snarfing {}".format(fn), file=sys.stderr)

    with open(fn) as inf:
        hash_table = collections.defaultdict(set)
        for w in inf:
            w = w.lower().rstrip()

            if non_letter_re.search(w):
                continue
            if (not long_enough_re.match(w)):
                continue
            if (not has_a_vowel_re.search(w)):
                continue

            key = Bag(w)
            hash_table[key].add(w)

    print("done", file=sys.stderr)
    return hash_table
