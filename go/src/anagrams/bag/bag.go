package bag

import (
	"fmt"
	"math/big"
	"strings"
)

// Exports:
// the type Bag
// func Subtract
// func FromString
// func FromBigInt

var primes = []int64{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101}

type ErrCannotSubtract string

func (e ErrCannotSubtract) Error() string { return "sorry, dude" }

type Bag struct{ z *big.Int }

func (b Bag) GobEncode() ([]byte, error) { return b.z.GobEncode() }

func (b Bag) Format(f fmt.State, c rune) { fmt.Fprintf(f, "%v", b.z.String()) }

func lettertoprime(ch int) int64 {
	index := ch - 'a'

	if index >= len(primes) || index < 0 {
		return 1
	}
	return primes[index]
}

func FromString(w string) Bag {
	product := big.NewInt(1)

	for _, c := range strings.ToLower(w) {
		product.Mul(product, big.NewInt(lettertoprime(int(c))))
	}

	return Bag{product}
}

func FromBigInt (z *big.Int) Bag {
	return Bag{z}
}

func (this Bag) SameAsInt(i int64) bool {
	return this.Same(Bag{big.NewInt(i)})
}

func (this Bag) Same(other Bag) bool {
	return this.z.Cmp(other.z) == 0
}

var zero = new(big.Int)
var one = big.NewInt(1)

func (this Bag) Empty() bool {
	return this.z.Cmp(one) == 0
}

var error_cannot_subtract ErrCannotSubtract

func (minuend Bag) Subtract(subtrahend Bag) (Bag, error) {
	diff, error := subtract(minuend.z, subtrahend.z)
	return Bag{diff}, error
}

func subtract(minuend, subtrahend *big.Int) (*big.Int, error) {
	q := new(big.Int)
	r := new(big.Int)
	q.QuoRem(minuend, subtrahend, r)
	if r.Cmp(zero) == 0 {
		return q, nil
	}
	return big.NewInt(1), &error_cannot_subtract
}
