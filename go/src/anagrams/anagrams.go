package anagrams

import (
	"log"
	"math/big"
)

func filter(d DictSlice, bag Bag) DictSlice {
	result := make(DictSlice, 0)

	return result
}

func combine(words []string, list_of_lists [][]string) [][]string {
	return make([][]string, 0)
}

func Anagrams(d DictSlice, bag Bag) [][]string {
	result := make([][]string, 0)

	for index, entry := range d {
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
			// make a smaller dict by filtering out entries
			smaller_dict := filter(d[index:], smaller_bag)

			// then recursively call ourselves with that smaller dict
			// and the smaller bag;

			from_recursive_call := Anagrams(smaller_dict, smaller_bag)

			// make a "cross-product" of this entry's words with the
			// results of that recursive call.

			return combine(entry.words, from_recursive_call)
		}

	}

	return result
}
