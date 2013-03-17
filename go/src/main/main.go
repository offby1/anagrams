package main

import (
	"anagrams"
	"fmt"
	"log"
)

func main() {
	dictslice, error := anagrams.SnarfDict("/usr/share/dict/words")

	if error != nil {
		log.Fatal(error)
	}

	fmt.Printf("Number of somethings in the dictionary: %v\n", len (dictslice))

	fmt.Printf("Anagrams of 'dog': %v", anagrams.Anagrams (dictslice, anagrams.WordToBag ("dog")))
}
