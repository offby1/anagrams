package anagrams

import (
	"log"
	"math/big"
)

func Anagrams(d DictSlice, bag *big.Int) []string {
	result := []string{}

	for _, entry := range d {
		entry_bag := big.NewInt(0)
		entry_bag.GobDecode([]byte(entry.bag_gob))

		log.Fatalf("Decoded %v into %v", entry.bag_gob, entry_bag)

		// smaller_bag, error := Subtract(entry.bag, bag)

		// try to subtract our bag from this entry's bag; save result in "smaller bag".
		// if we cannot, just skip this entry.
		// if smaller bag is empty, "listify" this entry's words, and append that list to the result.
		// otherwise, make a smaller dict by filtering out entries, then recursively call ourselves with that smaller dict and the smaller bag; make a "cross-product" of this entry's words with the results of that recursive call.
	}

	return result
}
