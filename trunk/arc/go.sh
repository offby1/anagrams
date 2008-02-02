#!/bin/sh

here=$(cd $(dirname "$0"); pwd)
cd "$here"
(
    cat bag.arc dict.arc anagrams.arc
    echo '(time (len (anagrams (bag "Ernest Hemingway") dictionary*)))'
    echo '(quit)'
    )  | /usr/local/src/langs/arc/arc0/arc.sh