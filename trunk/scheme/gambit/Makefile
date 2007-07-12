SCMS 	 := bag.scm dict.scm anagrams.scm 
CS   	 := $(SCMS:.scm=.c)
LINKFILE := $(prog)_.c
gambc	 := /usr/local/stow/gambc/current
gsc	 := $(gambc)/bin/gsc -cc-options -I$(gambc)/include
gsi	 := $(gambc)/bin/gsi

all.o1: $(SCMS)
	$(gsc) all

# BUGBUG -- I think the compiler will generate all.o1, then all.o2, etc
check: all.o1
	for i in "hemingway" "st hemingway" "est hemingway" "Ernest Hemingway"; \
	do time $(gsi) -:m100000 all $$i > /dev/null; done

clean:
	rm -f $(CS) $(LINKFILE) $(prog) hmm *.o *.o1

.PHONY: clean check all
.INTERMEDIATE: $(CS) $(LINKFILE)
