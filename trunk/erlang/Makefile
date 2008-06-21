# On Ubuntu Hardy, at least, "sudo aptitude install erlang" should get
# you everything you need.
SRCS  = $(wildcard *.erl)
BEAMS = $(SRCS:.erl=.beam)

%.beam: %.erl
	erlc -W $<

all: $(BEAMS)

check: all
	time escript anagrams.erl "Est Hemingway"

profile: all
	-rm -f fprof.trace
	escript do_profile.erl "Hemingway"

clean:
	-rm *.beam *.dets

.PHONY: all check clean profile
