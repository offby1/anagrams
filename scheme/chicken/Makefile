srcs := anagrams.scm dict.scm bag.scm
objs := $(srcs:.scm=.o)

# The -profile option seems to slow it waaay down, at least with build
# 315

# "foof" on #scheme suggests I use -Ob, but that causes a segfault.
anagrams: $(srcs)
	csc -disable-interrupts -lambda-lift -O3 $^

words: /usr/share/dict/words
	ln -sv $^ $@
#head -10 $^  > $@

check: anagrams words
	time ./$< "Ernest Hemingway" > /dev/null && if [ -f PROFILE ]; then chicken-profile; fi

clean:
	rm -f $(objs) $(srcs:.scm=.c) anagrams PROFILE words

realclean: clean
	rm -f cached-dictionary.scm

.PHONY: clean check realclean
