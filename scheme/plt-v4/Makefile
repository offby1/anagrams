COMPILED=$(patsubst %.ss,compiled/%_ss.zo,$(wildcard *.ss))

compiled/%_ss.zo: %.ss
	mzc $?

.PHONY: check
check: $(COMPILED)
	time mzscheme anagrams.ss "Ernest Hemingway" > /dev/null

.PHONY: clean
clean:
	-rm -rf compiled

