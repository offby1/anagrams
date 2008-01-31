#!/bin/sh

arc=/usr/local/src/langs/arc
(
    cat bag.arc dict.arc anagrams.arc
    echo '(anagrams (bag "scate") dictionary*)'
    echo '(quit)'
    ) \
        | \
        (
    cd $arc/arc0
    $arc/plt/bin/mzscheme -m -f as.scm
    ) 
