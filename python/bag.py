#!/usr/bin/env python

from __future__ import print_function


class Bag(object):
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]

    @classmethod
    def from_number(cls, n):
        r = cls('')
        r.number = n
        return r

    def __init__(self, str):
        self.number = 1

        for c in str.lower():
            if (c >= 'a') and (c <= 'z'):
                self.number *= self.primes [ord (c) - ord ('a')]

    def empty(self):
        return self.number == 1

    def __eq__(self, other):
        return self.number == other.number

    def subtract(self, other):
        # To my surprise, using divmod here is slower.
        remainder = self.number % other.number
        if (0 == remainder):
            return self.from_number(self.number / other.number)
        else:
            return False

    def __hash__(self):
        return hash(self.number)
