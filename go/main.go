package main

import (
	"./bag"
	"fmt"
)

func main() {
	strings := []string{"Hooray", "cat", "My dog has fleas"}

	for _, w := range strings {
		fmt.Printf("%s:\t%d\n",
			w,
			bag.WordToBag(w))
	}
}
