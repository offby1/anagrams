package anagrams

import (
	"log"
)

func Filter(d DictSlice, bag Bag) DictSlice {
	result := make(DictSlice, 0)

	for _, entry := range d {
		_, error := bag.Subtract(entry.bag)
		// seems a shame to throw away the difference.
		if error == nil {
			result = append(result, entry)
		}
	}

	log.Printf("Filtering %v-long dict by %v leaves %v: %v", len(d), bag, len(result), result)
	return result
}

func combine(ws []string, ans [][]string) [][]string {

	rv := make([][]string, 0)

	for _, a := range ans {
		for _, w := range ws {
			bigger_anagram := make([]string, len(ws))
			copy(bigger_anagram, a)
			bigger_anagram = append(bigger_anagram, w)
			rv = append(rv, bigger_anagram)
		}
	}

	return rv
}

func Anagrams(d DictSlice, bag Bag) [][]string {
	d = Filter(d, bag)

	result := make([][]string, 0)

	for index, entry := range d {
		// try to subtract our bag from this entry's bag; save result in "smaller bag".

		smaller_bag, error := bag.Subtract(entry.bag)
		switch {
		// if we cannot, just skip this entry.
		case error != nil:
			break

			// if smaller bag is empty, "listify" this entry's words,
			// and append that list to the result.
		case smaller_bag.Empty():
			for _, w := range entry.words {
				new_list := make([]string, 1)
				new_list[0] = w
				result = append(result, new_list)
			}

			// otherwise
		default:
			// recursively call ourselves with the smaller dict and
			// the smaller bag

			from_recursive_call := Anagrams(d[index:], smaller_bag)

			// make a "cross-product" of this entry's words with the
			// results of that recursive call.

			for _, more := range combine(entry.words, from_recursive_call) {
				result = append(result, more)
			}
		}
	}

	return result
}
