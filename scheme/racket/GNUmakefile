# The number 1156 is, of course, merely what I saw it emit once; I
# don't know that it's actually correct.

check:
	raco make anagrams.rkt
	./bag.rkt
	./dict.rkt
	test $$(./anagrams.rkt "harry potter" | wc -l | tail -1) -eq 1156
	time ./anagrams.rkt  "Ernest Hemingway" > /dev/null

anagrams:
	mzc --exe $@ anagrams.rkt

profile:
	time ./profile.ss  "Ernest Hemingway" > /dev/null

tags: TAGS

TAGS: $(wildcard *.rkt)
	-etags.ss $^

clean:
	rm -rf TAGS anagrams profile compiled

.PHONY: check clean tags
