# Note that precompilation doesn't make a noticeable difference in
# speed.  But hey, it's fun.
compiled: $(wildcard *.ss)
	mzc anagrams.ss

.PHONY: check
check: compiled
	time mzscheme anagrams.ss "Ernest Hemingway" > /dev/null
