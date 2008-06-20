# On Ubuntu Hardy, at least, "sudo aptitude install erlang" should get
# you everything you need.
SRCS  = $(wildcard *.erl)
BEAMS = $(SRCS:.erl=.beam)

%.beam: %.erl
	erlc -W $<

all: $(BEAMS)

check: all
	escript anagrams.erl cat

cover: all
	escript do_coverage.erl

clean:
	-rm *.beam *.dets

.PHONY: all check clean cover
