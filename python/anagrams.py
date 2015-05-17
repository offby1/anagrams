#!/usr/bin/env python

from __future__ import print_function

# Local
from bag import Bag
import dict

# Core
from   optparse import OptionParser
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
    parser = OptionParser(usage="usage: %prog [options] string")
    parser.add_option("-d",
                      "--dictionary",
                      action="store",
                      type="string",
                      dest="dict_fn",
                      default=dict.default_dict_name,
                      metavar="FILE",
                      help="location of word list")

    (options, args) = parser.parse_args()

    if 0 == len(args):
        parser.print_help()
        sys.exit(0)

    dict_hash_table = dict.snarf_dictionary_from_file(options.dict_fn)

    the_phrase = Bag(args[0])
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

    print("{} anagrams of {}".format(len(result), args[0]),
          file=sys.stderr)
    for a in result:
        sys.stdout.write("(")
        for i, w in  enumerate(a):
            if i > 0:
                sys.stdout.write(" ")
            sys.stdout.write(w)
        sys.stdout.write(")")
        print()
