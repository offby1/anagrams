package anagrams

import (
	"fmt"
	"math/big"
	"bufio"
	"log"
	"os"
)

// Open /usr/share/dict/words
// read each word; return a map from bags to a set of words

func SnarfDict() ([]byte, error) {
	fmt.Printf("Ahoy?\n")
	file, err := os.Open ("/usr/share/dict/words")
	if err != nil {
		log.Fatal (err)
	}

	reader := bufio.NewReader (file)
	_, _ = reader.ReadBytes ('\n');
	_, _ = reader.ReadBytes ('\n');
	_, _ = reader.ReadBytes ('\n');
	_, _ = reader.ReadBytes ('\n');
	return reader.ReadBytes ('\n');
}
