package anagrams

import (
	"log"
	"math/big"
	"strings"
)

var primes = []int64{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101}

type ErrCannotSubtract string

func LetterToPrime(ch int) int64 {
	index := ch - 'a'

	if index >= len(primes) || index < 0 {
		return 1
	}
	return primes[index]
}

func WordToBag(w string) *big.Int {
	product := big.NewInt(1)

	for _, c := range strings.ToLower(w) {
		product.Mul(product, big.NewInt(LetterToPrime(int(c))))
	}

	return product
}

func (e ErrCannotSubtract) Error() string {
	return "sorry, dude"
}

var TheOnlyError ErrCannotSubtract

var zero = new(big.Int)

func Subtract(minuend, subtrahend *big.Int) (*big.Int, error) {
	q := new(big.Int)
	r := new(big.Int)
	q.QuoRem(minuend, subtrahend, r)
	if r.Cmp(zero) == 0 {
		return q, nil
	}
	return big.NewInt(1), &TheOnlyError
}
