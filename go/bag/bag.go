package bag

import "strings"

var primes = []int{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101}

type Bag int

func LetterToPrime(ch int) int {
	index := ch - 'a'

	if index >= len(primes) || index < 0 {
		return 1
	}
	return primes[index]
}

func WordToBag(w string) Bag {
	product := 1

	for _, c := range strings.ToLower(w) {
		product *= LetterToPrime(int(c))
	}
	return Bag(product)
}
