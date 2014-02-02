package main

import (
	"anagrams"
	"anagrams/bag"
	"flag"
	"fmt"
	"log"
	"os"
	"runtime/pprof"
)

var cpuprofile = flag.String("cpuprofile", "", "write cpu profile to file")
var input_string = flag.String("input", "", "string from which to compute anagrams")
var words_file = flag.String("words", "", "name of dictionary file")

func main() {
	flag.Parse()

	dictslice, error := anagrams.SnarfDict(*words_file)

	if error != nil {
		log.Fatal(error)
	}

	fmt.Printf("Number of somethings in the dictionary: %v\n", len(dictslice))

	bag := bag.FromString(*input_string)

	if *cpuprofile != "" {
		f, err := os.Create(*cpuprofile)
		if err != nil {
			log.Fatal(err)
		}
		pprof.StartCPUProfile(f)
		defer pprof.StopCPUProfile()
	}

	result := anagrams.Anagrams(dictslice, bag)
	fmt.Fprintf(os.Stderr,
		"%d anagrams of '%s'\n", len(result), *input_string)
	for _, a := range result {
		fmt.Println(a)
	}
}
