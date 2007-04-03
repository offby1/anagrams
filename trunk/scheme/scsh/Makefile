bytecode := anagrams.image
vm := /usr/local/bin/scshvm

$(bytecode): $(vm) $(wildcard *.scm)
	./compile.scm

$(vm):
	@echo $@ is missing.
	@echo sudo ln -s /usr/local/lib/scsh/scshvm $@
	@echo might do it.
	@false

check: $(bytecode)
	 time PATH=$$PATH:/usr/local/lib/scsh scshvm -h 12000000 -i ./$^ "Hemingway" > /dev/null

clean:
	rm -f $(bytecode)

.PHONY: check clean
