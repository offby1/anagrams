check: wheedledict.beam bag.beam
	escript test.erl

%.beam: %.erl
	erlc -W $<

clean:
	-rm *.beam

.PHONY: check clean
