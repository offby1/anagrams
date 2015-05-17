#!/usr/bin/env python

from __future__ import print_function

# Local
from bag import Bag
import dict

# Core
import argparse
import cProfile
import pstats
import sys


def combine(words, anagrams):
    rv = []
    for w in words:
        for a in anagrams:
            rv.append([w] + a)

    return rv


def anagrams(bag, dictionary):

    rv = []

    for index, entry in enumerate(dictionary):
        key, words = entry

        smaller_bag = bag.subtract(key)
        if not smaller_bag:
            continue

        if smaller_bag.empty():
            for w in words:
                rv.append([w])
            continue

        from_smaller_bag = anagrams(smaller_bag,
                                    dictionary[index:])
        if not from_smaller_bag:
            continue

        rv.extend(combine(words, from_smaller_bag))

    return rv


if __name__ == "__main__":
    parser = parser = argparse.ArgumentParser()
    parser.add_argument('words',
                        nargs='+')
    parser.add_argument('--dictionary',
                        default=dict.default_dict_name,
                        help="location of word list")

    args = parser.parse_args()

    dict_hash_table = dict.snarf_dictionary_from_file(args.dictionary)

    the_phrase = Bag(''.join(args.words))
    print("Pruning dictionary.  Before: {} bags ...".format(len(dict_hash_table.keys())),
          file=sys.stderr, end='')

    # Now convert the hash table to a list, longest entries first.  (This
    # isn't necessary, but it makes the more interesting anagrams appear
    # first.)

    # While we're at it, prune the list, too.  That _is_ necessary for the
    # program to finish before you grow old and die.

    the_dict_list = sorted([[k, dict_hash_table[k]]
                     for k in dict_hash_table.keys()
                     if the_phrase.subtract(k)],
                           key=len)

    print(" After: {} bags.".format(len(the_dict_list)),
          file=sys.stderr)

    pr = cProfile.Profile()
    pr.enable()
    result = anagrams(the_phrase, the_dict_list)
    pr.disable()

    ps = pstats.Stats(pr, stream=sys.stderr).sort_stats('cumulative')
    ps.print_stats()

    print("{} anagrams of {}".format(len(result), ' '.join(args.words)),
          file=sys.stderr)
    for a in result:
        sys.stdout.write("(")
        for i, w in  enumerate(a):
            if i > 0:
                sys.stdout.write(" ")
            sys.stdout.write(w)
        sys.stdout.write(")")
        print()
