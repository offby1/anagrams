from bag_collections import Bag


def test_a_whole_lotta_stuff():
    assert Bag("").empty()
    assert not Bag("a").empty()
    assert Bag("abc") == Bag("cba")
    assert Bag("abc") != Bag("bc")
    assert Bag("a") == Bag("ab") - Bag("b")
    assert Bag("a") - Bag("b") is None
    assert not (Bag("a") - Bag("aa"))

    silly_long_string = """When first I was a wee, wee lad
    Eating on my horse
    I had to take a farting duck
    Much to my remorse.
    Oh Sally can't you hear my plea
    When Roe V Wade is nigh
    And candles slide the misty morn
    With dimples on your tie."""

    ever_so_slightly_longer_string = silly_long_string + "x"
    assert Bag("x") == Bag(ever_so_slightly_longer_string) - Bag(silly_long_string)

    assert Bag("abc") == Bag("ABC")

    d = {Bag("fred"): 'ted'}
    assert d[Bag("fred")] == 'ted'

    assert ((Bag("x") - Bag("x")).empty())
