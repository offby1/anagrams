#!/usr/bin/env python3.1

import collections
import itertools
import unittest


class Bag(collections.Counter):
    """
    Wrapper around collections.Counter that provides the API that anagrams.py expects.
    """
    def __init__(self, wozzit):
        if hasattr(wozzit, 'lower'):
            wozzit = wozzit.lower()
        super(Bag, self).__init__(wozzit)

    def empty(self):
        return len(self.keys()) == 0

    def __sub__(self, other):
        result = Bag(self)
        result.subtract(other)
        least = result.most_common()[:-2:-1]
        if least and least[0][1] < 0:
            return None

        return Bag(+result)

    def __hash__(self):
        return hash(tuple(sorted(self.items())))

    def __str__(self):
        return "".join([k * v for k, v in sorted(self.items())])
