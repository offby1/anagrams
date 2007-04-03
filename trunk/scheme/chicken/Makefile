srcs := anagrams.scm dict.scm bag.scm
objs := $(srcs:.scm=.o)

CFLAGS := $(shell chicken-config -cflags)
LDFLAGS:= $(shell chicken-config -libs)

# The -profile option seems to slow it waaay down, at least with build
# 315
%.c : %.scm
	chicken $^ # -profile

%.o : %.c
	gcc -c $^ $(CFLAGS)

anagrams: $(objs)
	gcc $^ -o $@ $(LDFLAGS)

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
