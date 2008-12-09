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
	rm -f TAGS anagrams profile

.PHONY: check clean tags
