#!/bin/sh
GUILE_LOAD_PATH=.
export GUILE_LOAD_PATH
GUILE_WARN_DEPRECATED=detailed
export GUILE_WARN_DEPRECATED

exec guile -s $0 ${1+"$@"}
!#

(use-modules (anagrams))
(display (length (all-anagrams (cadr (command-line)))))
(newline)
