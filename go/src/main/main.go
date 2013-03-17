package main

import (
	"anagrams"
	"fmt"
	"log"
)

func main() {
	strings := []string{"Hooray", "cat", "My dog has fleas"}

	for _, w := range strings {
		fmt.Printf("%s:\t%d\n",
			w,
			anagrams.WordToBag(w))
	}

	dictslice, error := anagrams.SnarfDict("/usr/share/dict/words")

	if error != nil {
		log.Fatal(error)
	}

	fmt.Printf("Number of somethings in the dictionary: %v\n", len (dictslice))
	for index, entry := range dictslice {
		fmt.Printf("Entries for '%d': %v\n",
			index,
			entry)

		if index > 10 {
			break
		}
	}

	fmt.Printf("Anagrams of 'dog': %v", anagrams.Anagrams (dictslice, anagrams.WordToBag ("dog")))
}
