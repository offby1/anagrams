package bag

import (
	"fmt"
	"math/big"
	"sort"
	"strings"
)

// Exports:
// the type Bag
// func Subtract
// func FromString
// func FromBigInt
// func GobEncode
// func Format
// func Empty

var primes = []int64{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101}

type Bag struct {
	z       *big.Int
	letters []byte
}

func (b Bag) GobEncode() ([]byte, error) { return b.z.GobEncode() }
func (b *Bag) GobDecode(bytes []byte) error {
	z := new(big.Int)
	e := z.GobDecode(bytes)
	if e == nil {
		b.z = z
	}

	return e
}
func (b Bag) Format(f fmt.State, c rune) {
	fmt.Fprintf(f, "%v (%v)",
		b.z.String(),
		b.letters)
}

func lettertoprime(ch int) int64 {
	index := ch - 'a'

	if index >= len(primes) || index < 0 {
		return 1
	}
	return primes[index]
}

type SortableString []byte

func (s SortableString) Len() int {
	return len(s)
}
func (s SortableString) Less(i, j int) bool {
	return s[i] < s[j]
}
func (s SortableString) Swap(i, j int) {
	tmp := s[i]
	s[i] = s[j]
	s[j] = tmp
}

func FromString(w string) Bag {
	product := big.NewInt(1)

	for _, c := range strings.ToLower(w) {
		product.Mul(product, big.NewInt(lettertoprime(int(c))))
	}

	sort_me := make(SortableString, len(w))
	copy(sort_me, w)
	sort.Sort(sort_me)
	return Bag{product, sort_me}
}

func FromBigInt(z *big.Int) Bag {
	return Bag{z, []byte("?")}
}

func (this Bag) same_as_int(i int64) bool {
	return this.same(Bag{big.NewInt(i), []byte("?")})
}

func (this Bag) same(other Bag) bool {
	return this.z.Cmp(other.z) == 0
}

var zero = new(big.Int)
var one = big.NewInt(1)

func (this Bag) Empty() bool {
	return this.z.Cmp(one) == 0
}

func (minuend Bag) Subtract(subtrahend Bag) (Bag, bool) {
	diff, ok := subtract(minuend.z, subtrahend.z)
	return Bag{diff, []byte("?")}, ok
}

func subtract(minuend, subtrahend *big.Int) (*big.Int, bool) {
	q := new(big.Int)
	r := new(big.Int)
	q.QuoRem(minuend, subtrahend, r)
	if r.Cmp(zero) == 0 {
		return q, true
	}
	return big.NewInt(1), false
}
