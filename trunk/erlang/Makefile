# On Ubuntu Hardy, at least, "sudo aptitude install erlang" should get
# you everything you need.
SRCS  = $(wildcard *.erl)
BEAMS = $(SRCS:.erl=.beam)

all: $(BEAMS)

check: all
	escript anagrams.erl Ernestx

%.beam: %.erl
	erlc -W $<

clean:
	-rm *.beam *.dets

.PHONY: all check clean
