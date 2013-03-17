package anagrams

import (
	"bufio"
	"fmt"
	"log"
	"math/big"
	"os"
)

// Open /usr/share/dict/words
// read each word; return a map from bags to a set of words

// Ideally I'd use a proper "set" type, but I haven't found one; I'll
// just use a map and ignore the values instead
type WordSet map[string]int

type Dict map[*big.Int]WordSet

func SnarfDict() (Dict, error) {
	fmt.Printf("Ahoy?\n")
	file, err := os.Open("/usr/share/dict/words")
	if err != nil {
		log.Fatal(err)
	}

	reader := bufio.NewReader(file)
	accum := make(Dict, 50000)

	for {
		word, err := reader.ReadBytes('\n')
		if err != nil {
			// EOF, presumably
			return accum, nil
		}

		words, ok := accum[WordToBag(string(word))]

		if !ok {
			words = make(WordSet)
			accum[WordToBag(string(word))] = words
		}

		words[string(word)] = 1
	}
	return nil, nil
}
