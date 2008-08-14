check:
	time ./anagrams.scm  "Ernest Hemingway" > /dev/null

anagrams:
	mzc --exe $@ anagrams.scm

profile:
	time ./profile.ss  "Ernest Hemingway" > $@

tags: TAGS

TAGS: $(wildcard *.scm)
	-etags.ss $^

clean:
	-rm TAGS anagrams

.PHONY: check clean tags
