package main

import (
	"anagrams"
	"fmt"
	"log"
	"os"
)

func main() {
	dictslice, error := anagrams.SnarfDict("/usr/share/dict/words")

	if error != nil {
		log.Fatal(error)
	}

	fmt.Printf("Number of somethings in the dictionary: %v\n", len (dictslice))

	input_string := ""
	for _, arg := range os.Args[1:] {
		input_string += arg
	}

	bag := anagrams.WordToBag (input_string)

	result := anagrams.Anagrams (dictslice, bag)
	fmt.Fprintf(os.Stderr,
				"%d anagrams of '%s'\n", len (result), input_string) 
	fmt.Println(result)
}
