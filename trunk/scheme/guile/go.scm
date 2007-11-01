#!/bin/sh
exec guile -s $0 ${1+"$@"}
!#

(use-modules (anagrams))
(display (length (all-anagrams (cadr (command-line)))))
(newline)