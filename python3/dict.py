#!/usr/bin/env python3.0

from bag import Bag
import collections
import os
import re

has_a_vowel_re = re.compile(r'[aeiouy]')
long_enough_re = re.compile(r'^i$|^a$|^..')
non_letter_re = re.compile(r'[^a-zA-Z]')


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
    hash_table = collections.defaultdict(set)
    for w in re.findall(r'.+', I.read()):
        w = w.lower()
        if not word_acceptable(w):
            continue

        hash_table[Bag(w)].add(w)

    return hash_table


def snarf_dictionary(fn):
    with open(fn, "r", encoding='utf_8') as fh:
        return snarf_dictionary_from_IO(fh)
