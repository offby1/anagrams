PYTHON := python

SOS = $(patsubst %.py,%.so,$(wildcard *.py))

.PHONY: check
check:  $(SOS) hash.cache
	time $(PYTHON) ./anagrams.py "Ernest Hemingway" >/dev/null

hash.cache:
	$(PYTHON) ./anagrams.py foo

%.c: %.py
	cython $^
CFLAGS=-fPIC -O3 -I/usr/include/python2.5/

%.so: %.o
	gcc -shared $^ -o $@

.PHONY: clean
clean:
	-rm -f hash.cache *.o *.so *.class
