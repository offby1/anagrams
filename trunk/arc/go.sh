#!/bin/sh

here=$(cd $(dirname "$0"); pwd)
arcdir=/usr/local/src/langs/arc/arc-wiki

cd "$here"
(
    cat bag.arc dict.arc anagrams.arc
    echo '(time (len (anagrams (bag "Ernest Hemingway") dictionary*)))'
    echo '(quit)'
    )  | (cd "$arcdir"; mzscheme -m -f as.scm)
