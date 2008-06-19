# On Ubuntu Hardy, at least, "sudo aptitude install erlang" should get
# you everything you need.
check: wheedledict.beam bag.beam
	escript anagrams.erl Ernestx

%.beam: %.erl
	erlc -W $<

clean:
	-rm *.beam *.dets

.PHONY: check clean
