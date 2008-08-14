require 'test/unit'
require 'bag'

class TestBag < Test::Unit::TestCase
  def test_joe_bob
    assert(Bag.new("").empty(), "initially empty")
    assert((not (Bag.new("a").empty())), "not always empty")
    assert_equal(Bag.new("abc"), Bag.new("cba"))
    assert((not(Bag.new("abc") == Bag.new("bc"))))
    assert_equal(Bag.new("a"),
                 Bag.new("ab") - Bag.new("b"))
    assert_equal(Bag.new("b"),
                 Bag.new("ab") - Bag.new("a"))
    assert((not( Bag.new("a") - Bag.new("b"))))
    assert((not( Bag.new("a") - Bag.new("aa"))))
    silly_long_string = "When first I was a wee, wee lad\n\
Eating on my horse\n\
I had to take a farting duck\n\
Much to my remorse.\n\
Oh Sally can't you hear my plea\n\
When Roe V Wade is nigh\n\
And candles slide the misty morn\n\
With dimples on your tie."

    ever_so_slightly_longer_string = silly_long_string + "x"
    assert_equal(Bag.new("x"),
                 Bag.new(ever_so_slightly_longer_string) - Bag.new(silly_long_string))
    
    assert_equal(Bag.new("abc"),
                 Bag.new("ABC"), "properly insensitive to case")
    
  end
end

puts "Ayup, them tests done run"
