package main

import (
	"anagrams"
	"fmt"
)

func main() {
	strings := []string{"Hooray", "cat", "My dog has fleas"}

	for _, w := range strings {
		fmt.Printf("%s:\t%d\n",
			w,
			anagrams.WordToBag(w))
	}
}
