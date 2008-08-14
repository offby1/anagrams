#ifndef NUMERIC_BAG_H
#define NUMERIC_BAG_H

#include <gmpxx.h>
#include <string>
#include <ostream>

class bag {
 private:
  mpz_class _product;
 public:
  bag (const mpz_class &p) : _product (p) {}
  bag (const std::string &s);

  bool is_empty () const { return (_product == 1); };
  bool operator == (const bag &other) const {return this->_product == other._product;}
  bool operator < (const bag &other) const {return (this->_product < other._product);}

  // returns 0 if b2 cannot be subtracted from b1
  bag*  subtract_bag (const bag &b2) const
    {
      if (0 == (this->_product % b2._product))
        return new bag (this->_product / b2._product);
      return 0;
    }

  operator const std::string () const { return _product.get_str (); }
  const char * c_str () const { return (static_cast<const std::string>(*this)).c_str (); }

  inline friend std::ostream &
    operator <<(std::ostream &o, const bag &b)
    {
      o << static_cast<std::string>(b);
      return o;
    }
};


#endif
