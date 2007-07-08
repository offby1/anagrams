# Contributed by "mejja", denizen of #scheme on irc.freenode.org

bench:  bag.scm dict.scm anagrams.scm
	echo "(declare (usual-integrations))" > bench.scm
	cat bag.scm dict.scm anagrams.scm >> bench.scm
	mit-scheme --compiler --eval '(begin (cf "bench") (%exit))'

check:
	time mit-scheme --heap 10000 --load bench --eval \
	'(begin (display (length (anagrams "Ernest Hemingway"))) (%exit))'

clean:
	rm -f bench.scm bench.com bench.bci bench.bin

distclean:
	rm -f pruned-Ernest\ Hemingway

.PHONY: check
