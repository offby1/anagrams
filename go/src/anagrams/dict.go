package anagrams

import (
	"bufio"
	"fmt"
	"log"
	"math/big"
	"os"
	"strings"
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
		word, err := reader.ReadString('\n')
		if err != nil {
			// EOF, presumably
			return accum, nil
		}

		word = strings.ToLower(strings.TrimSpace (word))
		
		words, ok := accum[WordToBag(word)]

		if !ok {
			words = make(WordSet)
			accum[WordToBag(word)] = words
		} else {
			words[word] = 1

			fmt.Printf ("First bag with 2 entries: %v\n", words[word])
			return accum, nil
		}

		words[word] = 1
	}
	// Never reached
	return nil, nil
}
