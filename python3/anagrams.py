#!/usr/bin/env python3

import argparse
from bag import Bag
import dict
import functools
import sys


def _p(*args):
    print(*args, file=sys.stderr)


def combine(words, anagrams):

    rv = []
    for w in words:
        for a in anagrams:
            rv.append([w] + a)

    return rv


def anagrams(b, dict_as_list):

    rv = []

    while dict_as_list:
        (key, words) = dict_as_list[0]
        smaller_bag = b - key

        if smaller_bag is not None:
            if smaller_bag.empty():
                for w in words:
                    rv.append([w])
            else:
                from_smaller_bag = anagrams(smaller_bag, dict_as_list)
                if from_smaller_bag:
                    rv.extend(combine(words, from_smaller_bag))

        dict_as_list = dict_as_list[1:]

    return rv


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-d", "--dictionary",
                        default=dict.default_dict_name,
                        metavar="FILE",
                        help="location of word list")
    parser.add_argument('input', nargs='+')

    args = parser.parse_args()

    dict_hash_table = dict.snarf_dictionary(args.dictionary)

    the_phrase = ' '.join(args.input)
    the_input_bag = Bag(the_phrase)

    _p("Pruning dictionary.  Before:",
       functools.reduce(lambda acc, elt: acc + len(dict_hash_table[elt]),
                        dict_hash_table,
                        0),
       "words ...")

    # Now convert the hash table to a list, longest entries first.  (This
    # isn't necessary, but it makes the more interesting anagrams appear
    # first.)

    # While we're at it, prune the list, too.  That _is_ necessary for the
    # program to finish before you grow old and die.

    the_dict_list = [pair for pair in dict_hash_table.items()
                     if (the_input_bag - pair[0]) is not None]

    the_dict_list.sort(key=len)

    _p("Pruned dictionary.  After: {} words.".format(
        sum((len(words) for bag, words in the_dict_list))))

    result = anagrams(the_input_bag, the_dict_list)
    _p("{} anagrams of {!r}".format(len(result), the_phrase))

    with open(the_phrase, 'w') as outf:
        for a in result:
            outf.write("(")
            for i, w in enumerate(a):
                if i:
                    outf.write(" ")
                outf.write(w)
            outf.write(")")
            outf.write("\n")

    _p("Results written to {!r}".format(outf.name))
