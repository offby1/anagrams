# On Ubuntu Hardy, at least, "sudo aptitude install erlang" should get
# you everything you need.
SRCS  = $(wildcard *.erl)
BEAMS = $(SRCS:.erl=.beam)
CACHE = dict.dets

%.beam: %.erl
	erlc -W $<

all: $(BEAMS)

$(CACHE): all
	@echo "Rebuilding the dictionary cache \"$(CACHE)\"."
	@escript anagrams.erl ""

check: all $(CACHE)
	time escript anagrams.erl "Est Hemingway"

profile: all
	-rm -f fprof.trace
	escript do_profile.erl "Hemingway"

clean:
	-rm -f *.beam *.dets *.analysis *.trace

.PHONY: all check clean profile
