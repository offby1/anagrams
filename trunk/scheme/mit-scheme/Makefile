MITSCHEME = mit-scheme --batch-mode --heap 10000 --stack 500

all:        check fastcheck

check:        bench
	@echo "Running benchmark"
	@time $(MITSCHEME) --load bench --eval                                 \
	'(begin (write-line (length (anagrams "est Hemingway"))) (%exit))'

bench:        bench.scm
	@echo "Compiling benchmark"
	@$(MITSCHEME) --compiler --eval '(begin (cf "bench") (%exit))'

bench.scm: bag.scm dict.scm anagrams.scm
	@echo "Generating benchmark"
	@echo "(declare (usual-integrations))" > bench.scm
	@cat bag.scm dict.scm anagrams.scm >> bench.scm

fastcheck: fast
	@echo "Running faster version"
	@time $(MITSCHEME) --load fast --eval                                 \
	'(begin (write-line (length (anagrams "est Hemingway"))) (%exit))'

fast:        fast.scm
	@echo "Compiling faster version"
	@$(MITSCHEME) --compiler --eval '(begin (cf "fast") (%exit))'

clean:
	rm -f bench.scm bench.com bench.bci bench.bin

fastclean:
	rm -f fast.so fast.o fast.c fast.com fast.bin fast.bci

distclean: clean fastclean
	rm -f pruned-*

.PHONY: all check fastcheck fast clean fastclean distclean
