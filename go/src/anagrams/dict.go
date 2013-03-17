package anagrams

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

// Open /usr/share/dict/words
// read each word; return a map from bags to a set of words

// Ideally I'd use a proper "set" type, but I haven't found one; I'll
// just use a map and ignore the values instead
type WordSet map[string]int

// The key is the string representation of a big int
type DictMap map[string]WordSet

type Entry struct {
	bag   string
	words []string
}

type DictSlice []Entry

func SnarfDict(input_file_name string) (DictMap, error) {
	fmt.Printf("Ahoy?\n")
	file, err := os.Open(input_file_name)
	if err != nil {
		log.Fatal(err)
	}

	return snarfdict(bufio.NewReader(file))
}

func snarfdict(reader *bufio.Reader) (DictMap, error) {
	accum := make(DictMap, 50000)

	for {
		word, err := reader.ReadString('\n')
		if err != nil {
			// EOF, presumably
			break
		}

		word = strings.ToLower(strings.TrimSpace(word))

		// Unfortunatley, we cannot use bigInts as map keys, so we use
		// the next best thing: the bigInt's string representation.
		key := WordToBag(word).String()

		words, ok := accum[key]

		if !ok {
			words = make(WordSet)
			accum[key] = words
		}

		words[word] = 1
	}

	return accum, nil
}

// Convert the map into a flat list of entries, where each entry is
// the key (a string of digits) followed by one or more words.
func dictmap_to_slice(dm DictMap) DictSlice {
	return_value := make(DictSlice, 1)

	for key, val := range dm {
		e := new(Entry)
		e.bag = key
		e.words = make([]string, 1)

		for word, _ := range val {
			e.words = append(e.words, word)
		}

		return_value = append(return_value, *e)
	}

	return return_value
}
