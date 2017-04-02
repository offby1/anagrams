from io import StringIO
import os

from pytest import fixture

from bag import Bag
from dict import (
    default_dict_name,
    snarf_dictionary,
    snarf_dictionary_from_IO,
    word_acceptable,
)


@fixture
def fake_dict():
    fake_input = "cat\ntac\nfred\n"
    return snarf_dictionary_from_IO(StringIO(fake_input))


def test_word_acceptable():
    assert (word_acceptable("dog"))
    assert not (word_acceptable("C3PO"))

    d = snarf_dictionary(os.path.join(default_dict_name))
    assert (66965 == len(d))
    assert (72794 == sum(len(words) for words in d.values()))


def test_this_and_that(fake_dict):
    assert (2 == len(fake_dict.keys()))
    cat_hits = sorted(fake_dict[Bag("cat")])
    assert (2 == len(cat_hits))
    assert (cat_hits[0] == "cat")
    assert (cat_hits[1] == "tac")
    assert (1 == len(fake_dict[Bag("fred")]))
    assert (list(fake_dict[Bag("fred")])[0] == "fred")
