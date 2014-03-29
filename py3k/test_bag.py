import unittest
from bag2 import Bag

class WhatchaMaDingy(unittest.TestCase):
    def testAlWholeLottaStuff(self):
        self.assertTrue(Bag("").empty())
        self.assertFalse(Bag("a").empty())
        self.assertEqual(Bag("abc"), Bag("cba"))
        self.assertNotEqual(Bag("abc"), Bag("bc"))
        self.assertEqual(Bag("a"), Bag("ab") - Bag("b"))
        self.assertFalse(Bag("a") - Bag("b"))
        self.assertFalse(Bag("a") - Bag("aa"))

        silly_long_string = """When first I was a wee, wee lad
        Eating on my horse
        I had to take a farting duck
        Much to my remorse.
        Oh Sally can't you hear my plea
        When Roe V Wade is nigh
        And candles slide the misty morn
        With dimples on your tie."""

        ever_so_slightly_longer_string = silly_long_string + "x"
        self.assertEqual(Bag("x"),
                         Bag(ever_so_slightly_longer_string) - Bag(silly_long_string))

        self.assertEqual(Bag("abc"), Bag("ABC"))

        d = {Bag("fred"):'ted'}
        self.assertEqual(d[Bag("fred")], 'ted')

if __name__ == "__main__":
    exit(unittest.main())
