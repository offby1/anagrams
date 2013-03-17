package anagrams

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
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

func SnarfDict(input_file_name string) (DictSlice, error) {
	fmt.Printf("Ahoy?\n")
	file, err := os.Open(input_file_name)
	if err != nil {
		log.Fatal(err)
	}

	var dm DictMap
	dm, err = snarfdict(bufio.NewReader(file))
	if err != nil {
		log.Fatal(err)
	}

	return dictmap_to_slice(dm), nil
}

func word_acceptable(s string) bool {
	// return true if and only if:

	// the word contains a vowel;
	matched, error := regexp.MatchString("[aeiouy]", s)
	if error != nil {
		log.Fatal(error)
	}
	if !matched {
		//log.Printf("%s isn't acceptable because it has no vowel", s)
		return false
	}

	// the word does not contain a non-letter;
	matched, error = regexp.MatchString("[^a-z]", s)
	if error != nil {
		log.Fatal(error)
	}
	if matched {
		//log.Printf("%s isn't acceptable because it has a non-letter", s)
		return false
	}

	// the word is either "i", "a", or has two or more letters.
	if s == "i" {
		return true
	}

	if s == "a" {
		return true
	}

	if len(s) > 1 {
		return true
	}

	//log.Printf("%s isn't acceptable because it is too short", s)
	return false
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

		if !word_acceptable(word) {
			continue
		}

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
	return_value := make(DictSlice, 0)

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
