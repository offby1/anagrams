import mpz;
import std.string;
import std.ctype;

int primes[] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101];

class bag
{
  mpz product;

  bool opEquals (int i) { return (this.product == i ? true : false);}

  int opCmp(Object p)
  {
    bag rhs = cast(bag)p;
    mpz diff = product - rhs.product;
    return (diff > 0 ? 1 : (diff < 0 ? -1 : 0));
  }
  uint toHash()
  {
    uint rv = product % 0x7fffffff;
    return rv;
  }

  bool is_empty ()
  {
    return (1 == product ? true : false);
  }

  this () { this.product = new mpz (1); }
  this (mpz i) { this.product = i; }
  this (char[] s)
  {
    product = new mpz (1);

    while (s.length)
      {
        char c = s[0];
        if (isalpha (c))
          {
            product *= primes[std.ctype.tolower (c) - 'a'];
          }
        s = s[1 .. s.length];
      }
  }

  char []toString ()
  {
    return this.product.toString ();
  }
  
  void subtract (in bag other, out bag difference, out bool ok)
  {
    mpz remainder = this.product % other.product;
    ok = (0 == remainder ? true : false);
    if (ok)
      {
        difference = new bag (this.product / other.product);
      }
  }

  unittest
  {
    assert (2 == new bag ("a"));
    assert (6 == new bag ("ab"));
    assert (6 == new bag ("ba"));
    assert ((new bag ("")).is_empty ());

    bag aa = new bag ("aa");
    bag a  = new bag ("a");

    bag New_Diff;
    bool ok;
    aa.subtract (a, New_Diff, ok);
    assert (ok && (2 == New_Diff));
    a.subtract (aa, New_Diff, ok);
    assert (!ok);

    printf ("Bag unit tests passed.\n");
  }
}
