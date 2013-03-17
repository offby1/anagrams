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

	data, error := anagrams.SnarfDict("/usr/share/dict/words")

	if error != nil {
		log.Fatal(error)
	} else {
		fmt.Printf("Number of somethings in the dictionary: %v\n", len (data))
		for index, entry := range data {
			fmt.Printf("Entries for '%d': %v\n",
				index,
				entry)

			if index > 10 {
				break
			}
		}
	}
}
