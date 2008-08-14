check:
	time ./anagrams.scm  "Ernest Hemingway" > /dev/null

profile:
	time ./profile.ss  "Ernest Hemingway" > $@

tags: TAGS

TAGS: $(wildcard *.scm)
	-etags.ss $^

clean:
	-rm TAGS

.PHONY: check clean tags
