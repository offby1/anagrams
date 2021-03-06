class Bag
  Primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]

  include Comparable
  def <=>(anOther)
    product  <=> anOther.product
  end

  attr_reader :product

  def initialize(str)
    @product = 1
    str.downcase().each_byte do |b|
      if (b >= ?a.ord and b <= ?z.ord)
        @product *= Primes[b - ?a.ord]
      end
    end
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
    q, r = @product.divmod(other.product)
    return nil if r > 0

    p = Bag.new("")
    p.product = q

    p
  end

  protected

  def product=(x)
    @product = x
  end
end
