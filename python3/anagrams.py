#!/usr/bin/env python3

from    bag2 import Bag
import  dict
import  functools
from    optparse import OptionParser
import  sys


def combine(words, anagrams):

    rv = []
    for w in words:
        for a in anagrams:
            rv.append([w] + a)

    return rv


def anagrams(b, dict):

    rv = []

    for entries_processed, entry in enumerate(dict):
        key   = entry[0]
        words = entry[1]

        smaller_bag = b - key
        if smaller_bag is None:
            continue

        if smaller_bag.empty():
            for w in words:
                rv.append([w])
            continue

        from_smaller_bag = anagrams(smaller_bag,
                                    dict[entries_processed:])
        if not len(from_smaller_bag):
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

    if not len(args):
        parser.print_help()
        sys.exit(0)

    dict_hash_table = dict.snarf_dictionary(options.dict_fn)

    the_phrase = Bag(args[0])

    print("Pruning dictionary.  Before:",
          functools.reduce(lambda acc, elt: acc + len(dict_hash_table[elt]),
                           dict_hash_table,
                           0),
          "words ...",
          file=sys.stderr)

    # Now convert the hash table to a list, longest entries first.  (This
    # isn't necessary, but it makes the more interesting anagrams appear
    # first.)

    # While we're at it, prune the list, too.  That _is_ necessary for the
    # program to finish before you grow old and die.

    the_dict_list = [[k, dict_hash_table[k]]
                     for k in dict_hash_table.keys()
                     if (the_phrase - k) is not None]

    the_dict_list.sort(key=len)

    print("Pruned dictionary.  After:",
          functools.reduce(lambda acc, elt: acc + len(elt[1]),
                           the_dict_list,
                           0),
          "words.",
          file=sys.stderr)

    result = anagrams(the_phrase, the_dict_list)
    print(len(result), "anagrams of", sys.argv[1], ":", file=sys.stderr)

    with open(args[0], 'w') as outf:
        for a in result:
            outf.write("(")
            for i, w in  enumerate(a):
                if i:
                    outf.write(" ")
                outf.write(w)
            outf.write(")")
            outf.write("\n")

    print("Results written to {}".format(outf.name), file=sys.stderr)
