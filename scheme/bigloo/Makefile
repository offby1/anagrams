# TODO -- see if the program "bglmake" would simplify the process of
#compilation

anagrams: $(addsuffix .o,anagrams bag dict)

BIGLOO=bigloo -Obench
%.o : %.scm
	$(BIGLOO) -c $^

% : %.o
	$(BIGLOO) -o $@ $^

check: anagrams
	time LD_LIBRARY_PATH=/usr/local/lib:$(LD_LIBRARY_PATH) ./$^ "Ernest Hemingway" > /dev/null

clean:
	rm -f anagrams *.o cached-dictionary

.PHONY: check clean
