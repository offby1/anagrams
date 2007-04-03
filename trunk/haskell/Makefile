PROG := anagrams
PROF_PROG := profiled-anagrams

INPUT :=  Ernest Hemingway
PROF_OUTPUT := $(PROG).prof
CLEANFILES := $(PROG) $(PROF_OUTPUT) $(PROF_PROG)

all: $(PROG)

check: $(PROG)
	time ./$^ "$(INPUT)" > /dev/null

prof: $(PROF_OUTPUT)

$(PROF_OUTPUT): $(PROF_PROG)
	time ./$^ "$(INPUT)" +RTS -p  > /dev/null

$(PROG) : $(wildcard *.hs)
	ghc -O                 --make -o $@ anagrams.hs

$(PROF_PROG): $(wildcard *.hs)
	ghc -O -prof -auto-all --make -o $@ anagrams.hs

clean:
	-rm -f *.o *.hi $(CLEANFILES)

.PHONY: clean check prof all
