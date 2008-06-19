# On Ubuntu Hardy, at least, "sudo aptitude install erlang" should get
# you everything you need.
check: wheedledict.beam bag.beam
	escript anagrams.erl Ernest

%.beam: %.erl
	erlc -W $<

clean:
	-rm *.beam

.PHONY: check clean
