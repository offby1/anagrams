prog	 := anagrams
SCMS 	 := bag.scm dict.scm $(prog).scm 
CS   	 := $(SCMS:.scm=.c)
LINKFILE := $(prog)_.c
gambc	 := /usr/local/stow/gambc/current
gsc	 := $(gambc)/bin/gsc -cc-options -I$(gambc)/include

all: $(prog)

check: $(prog)
	for i in "hemingway" "st hemingway" "est hemingway" "Ernest Hemingway"; \
	do time ./$(prog) $$i > /dev/null ; done

%.c : %.scm
	$(gsc) -prelude "(declare (standard-bindings) (block) (not safe))" -c $^

$(prog)_.o: $(LINKFILE)
	$(gsc) -c $^

$(LINKFILE): $(CS)
	$(gsc) -link -I$(gambc)/include $^

LDLIBS := -lgambc -lm -lutil -ldl 

$(prog): CPPFLAGS = -I$(gambc)/include 
$(prog): LDFLAGS  = -L$(gambc)/lib
$(prog): $(CS) $(LINKFILE)

clean:
	rm -f $(CS) $(LINKFILE) $(prog) hmm *.o

.PHONY: clean check
.INTERMEDIATE: $(CS) $(LINKFILE)
