package anagrams

import (
	"fmt"
	"testing"
)

func TestSnarfDict(t *testing.T) {
	data, error := SnarfDict()

	if error != nil {
		t.Error("I fear it didn't work\n")
	} else {
		fmt.Printf("I dare to hope it worked.  %s\n", data)
	}
}
