check:
	mzc anagrams.scm
	time ./anagrams.scm  "Ernest Hemingway" > /dev/null

anagrams:
	mzc --exe $@ anagrams.scm

profile:
	time ./profile.ss  "Ernest Hemingway" > /dev/null

tags: TAGS

TAGS: $(wildcard *.scm)
	-etags.ss $^

clean:
	rm -rf TAGS anagrams profile compiled

.PHONY: check clean tags
