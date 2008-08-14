# On Ubuntu Hardy, at least, "sudo aptitude install erlang" should get
# you everything you need.
SRCS  = $(wildcard *.erl)
BEAMS = $(SRCS:.erl=.beam)
CACHE = dict.dets

%.beam: %.erl
	erlc -W $<

all: $(BEAMS) $(CACHE)

check: all
	time escript anagrams.erl "Ernes Hemingway"

$(CACHE): $(BEAMS)
	@echo "Rebuilding the dictionary cache \"$(CACHE)\"."
	@escript anagrams.erl ""

profile: all
	-rm -f *.trace *.analysis 
	escript do_profile.erl "St Hemingway"

clean:
	-rm -f *.beam *.dets *.analysis *.trace

.PHONY: all check clean profile
