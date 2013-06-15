package anagrams

import (
	"anagrams/bag"
	"bufio"
	"encoding/gob"
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

// The key is the gob representation of a big int
type DictMap map[string]WordSet

type Entry struct {
	Bag   bag.Bag
	Words []string
}

func (e Entry) Format(f fmt.State, c rune) { fmt.Fprintf(f, "%v: %v", e.Bag, e.Words) }

const cache_file_name = "/tmp/dict-cache"

func snarf_cached_dict() (DictSlice, bool) {
	_, err := os.Stat(cache_file_name)
	if err != nil {
		return nil, false
	}
	in, err := os.Open(cache_file_name)
	if err != nil {
		log.Fatal(err)
	}
	decoder := gob.NewDecoder(in)
	d := new(DictSlice)
	err = decoder.Decode(d)
	if err != nil {
		log.Panic(err)
	}
	return *d, true
}

func save_cached_dict(d DictSlice) {
	out, err := os.Create(cache_file_name)
	if err != nil {
		log.Fatal(err)
	}
	defer out.Close()

	encoder := gob.NewEncoder(out)
	err = encoder.Encode(d)
	if err != nil {
		log.Panic(err)
	}
}

type DictSlice []Entry

func SnarfDict(input_file_name string) (DictSlice, error) {

	cached, ok := snarf_cached_dict()
	if ok {
		log.Printf("Read cached dictionary from %v, w00t\n", cache_file_name)
		return cached, nil
	}

	file, err := os.Open(input_file_name)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var dm DictMap
	dm, err = snarfdict(bufio.NewReader(file))
	if err != nil {
		log.Fatal(err)
	}

	cache_me := dictmap_to_slice(dm)
	save_cached_dict(cache_me)

	return cache_me, nil
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
	log.Printf("Reading dictionary ... ")

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

		key := bag.FromString(word).AsString()

		words, ok := accum[string(key)]

		if !ok {
			words = make(WordSet)
			accum[string(key)] = words
		}

		words[word] = 1
	}

	log.Printf("Reading dictionary ... done")
	return accum, nil
}

// Convert the map into a flat list of entries, where each entry is
// the key (a string of digits) followed by one or more words.
func dictmap_to_slice(dm DictMap) DictSlice {
	return_value := make(DictSlice, 0)

	longest_length := 0

	for key, val := range dm {
		e := new(Entry)
		e.Bag = bag.FromString(key)

		e.Words = make([]string, 0)

		for word, _ := range val {
			e.Words = append(e.Words, word)
		}

		if len(val) > longest_length {
			longest_length = len(val)
			fmt.Println(val)
		}

		return_value = append(return_value, *e)
	}

	// TODO -- maybe sort the return value in some interesting way (longest bags first, e.g.)
	return return_value
}
