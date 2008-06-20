# On Ubuntu Hardy, at least, "sudo aptitude install erlang" should get
# you everything you need.
SRCS  = $(wildcard *.erl)
BEAMS = $(SRCS:.erl=.beam)

%.beam: %.erl
	erlc -W $<

all: $(BEAMS)

check: all
	time escript anagrams.erl "Est Hemingway"

cover: all
	escript do_coverage.erl

clean:
	-rm *.beam *.dets

.PHONY: all check clean cover
