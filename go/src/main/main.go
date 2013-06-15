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

func main() {
	flag.Parse()

	// TODO -- figure out how to get this file name reliably without
	// hard-coding it
	dictslice, error := anagrams.SnarfDict("/Users/erichanchrow/anagrams/words")

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
	fmt.Println(result)
}
