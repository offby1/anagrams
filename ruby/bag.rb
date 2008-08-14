class Bag
  Primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]

  def initialize (str)
    @product = 1
    str.downcase().each_byte {
      |b|
      if (b >= ?a and b <= ?z)
        @product *= Primes[b - ?a]
      end
    }
  end

  def hash
    @product.hash
  end
  
  def empty
    1 == @product
  end

  def ==(other)
    @product == other.product
  end

  def eql?(other)
    @product == other.product
  end

  def -(other)
    if(@product % other.product != 0)
      nil
    else
      p = Bag.new("")
      p.product = @product / other.product
      p
    end
  end

  def product
    @product
  end

  protected

  def product=(x)
    @product = x
  end
end
