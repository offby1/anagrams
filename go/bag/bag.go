package bag

import "strings"
import "math/big"

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
	product := int64(1)

	for _, c := range strings.ToLower(w) {
		product *= LetterToPrime(int(c))
	}
	return big.NewInt(product)
}

func (e ErrCannotSubtract) Error() string {
	return "sorry, dude"
}

var TheOnlyError ErrCannotSubtract

var zero = new(big.Int)

func Subtract(minuend, subtrahend *big.Int) (*big.Int, error) {
	z := new(big.Int)
	r := new(big.Int)
	z.QuoRem(minuend, subtrahend, r)
	if r.Cmp(zero) == 0 {
		return z, nil
	}
	return big.NewInt(1), &TheOnlyError
}
