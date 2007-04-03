check:
	time echo y | \
	mit-scheme --heap 6000 --load bag.scm dict.scm anagrams.scm \
	--eval '(begin (display (length (anagrams "est Hemingway"))) (newline) (exit))'

.PHONY: check
