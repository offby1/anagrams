# Note: jython 2.5 works too, although it's quite slow.
PYTHON := python

.PHONY: check
check: hash.cache
	time $(PYTHON) ./anagrams.py "Ernest Hemingway" >/dev/null

hash.cache:
	$(PYTHON) ./anagrams.py foo

.PHONY: clean
clean:
	-rm -f hash.cache
