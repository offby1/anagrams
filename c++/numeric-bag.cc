#include <iostream>
#include <vector>
#include <sstream>
#include <gmpxx.h>

#include "numeric-bag.h"

namespace {
  std::vector<mpz_class> primes;
  void
  initialize_primes ()
  {
    std::istringstream tmp ("2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101");
    while (tmp)
      {
        std::string t;
        tmp >> t;
        if (tmp)
          primes.push_back (mpz_class (t));
      }
  }
}

bag::bag (const std::string &input)
  : _product (1)
{
  if (!primes.size ())
    initialize_primes ();

  std::string s (input);
  while (s.size ())
    {
      char c = s[0];
      if (isalpha (c))
        {
          _product *= primes[tolower (c) - 'a'];
        }
      s.erase (0, 1);
    }

#if 0
  std::cerr << "Outta here with "
            << _product.get_str ()
            << "!"
            << std::endl;
  exit (0);
#endif
}
