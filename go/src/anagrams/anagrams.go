package anagrams

import (
	"log"
	"math/big"
)

func Anagrams(d DictSlice, bag Bag) []string {
	result := []string{}

	for _, entry := range d {
		entry_bigint := big.NewInt(0)
		entry_bigint.GobDecode([]byte(entry.bag_gob))
		entry_bag := Bag{entry_bigint}

		// try to subtract our bag from this entry's bag; save result in "smaller bag".

		smaller_bag, error := entry_bag.Subtract(bag)
		switch {
		// if we cannot, just skip this entry.
		case error != nil:
			continue

			// if smaller bag is empty, "listify" this entry's words,
			// and append that list to the result.
		case smaller_bag.Empty():
			log.Printf("mumble listify yadda yadda")

		// otherwise
		default:
			// make a smaller dict by filtering out entries, then recursively call ourselves with that smaller dict and the smaller bag; make a "cross-product" of this entry's words with the results of that recursive call.
			log.Printf("Smaller dict, filter, etc etc")

		}

	}

	return result
}
