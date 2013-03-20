package anagrams

import (
	"anagrams/bag"
	"log"
	"testing"
)

func BenchmarkOneRun(b *testing.B) {
	dictslice, error := SnarfDict("/usr/share/dict/words")

	if error != nil {
		log.Fatal(error)
	}

	Anagrams(dictslice, bag.FromString("Hemingway"))
}
