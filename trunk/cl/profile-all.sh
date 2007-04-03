#!/bin/sh

# This worked on a Debian `testing' system as of 19 May 2004.

# Some observations about the relative merits of the different Lisps:

# they're roughly the same speed, with cmucl a bit faster.

# sbcl's and cmu's compiler outputs are very informative; I bet if I
# fixed everything they were whining about, the program would run
# faster.  clisp's output is quite terse; I wonder if I can give some
# switch to make it whine louder.

for cmd in "lisp -load" "clisp -q -i" "sbcl --load"
  do 
  echo -n $cmd " ... "
  time $cmd profile.lisp > /dev/null
  echo
  echo 
done
