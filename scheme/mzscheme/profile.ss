#! /bin/sh
#| Hey Emacs, this is -*-scheme-*- code!
exec mzscheme -qr "$0" ${1+"$@"}
|#

;; Use me as a drop-in replacement for "anagrams.scm" -- i.e., run me like

;; ./profile.ss "Ernest Hemingway"

;; I am much slower than anagrams.scm, but I print out nice profiling
;; information when I'm done.  Assuming you're using version 301.8
;; (r2373) or later of PLT scheme.

(require (lib "errortrace.ss" "errortrace"))

(profiling-enabled #t)
(profiling-record-enabled #t)
(profile-paths-enabled #t)
(require "anagrams.scm")
(output-profile-results #t #t)
