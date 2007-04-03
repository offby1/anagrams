# TODO -- see if the program "bglmake" would simplify the process of
#compilation

anagrams: $(addsuffix .o,anagrams bag dict)

# -g enables assertions
%.o : %.scm
	bigloo -g -g4 -c $^

% : %.o
	bigloo -g4 -o $@ $^

check: anagrams
	LD_LIBRARY_PATH=/usr/local/lib:$(LD_LIBRARY_PATH) time ./$^ "Ernes Hemingway" > /dev/null

clean:
	rm -f anagrams *.o cached-dictionary

.PHONY: check clean
