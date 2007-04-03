prog	 := anagrams
SCMS 	 := bag.scm dict.scm $(prog).scm 
CS   	 := $(SCMS:.scm=.c)
LINKFILE := $(prog)_.c
gsc	 := /usr/local/stow/gambit/current/bin/gsc

all: $(prog)

check: $(prog)
	for i in "hemingway" "st hemingway" "est hemingway" "Ernest Hemingway"; \
	do time ./$(prog) $$i > /dev/null ; done

%.c : %.scm
	$(gsc) -prelude "(declare (standard-bindings) (block) (not safe))" -c $^

$(LINKFILE): $(CS)
	$(gsc) $^

LDLIBS := -lgambc -lm -lutil -ldl 

$(prog): $(CS) $(LINKFILE)

clean:
	rm -f $(CS) $(LINKFILE) $(prog) hmm *.o

.PHONY: clean check
.INTERMEDIATE: $(CS) $(LINKFILE)
