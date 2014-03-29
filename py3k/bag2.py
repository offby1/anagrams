#!/usr/bin/env python3.1

import collections
import itertools
import unittest


class Bag(collections.Counter):
    """
    Wrapper around collections.Counter that provides the API that anagrams.py expects.
    """
    def __init__(self, str):
        super(Bag, self).__init__(str.lower())
    def empty(self):
        return len(self.keys()) == 0

    # TODO -- side-effecty.  Will probably break stuff.
    def __sub__(self, other):
        self.subtract(other)
        least = self.most_common()[:-2:-1]
        if least and least[0][1] < 0:
            return None
        return +self

    def __hash__(self):
        return hash(tuple(self.items()))
