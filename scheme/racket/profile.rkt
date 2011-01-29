#! /bin/sh
#| Hey Emacs, this is -*-scheme-*- code!
exec racket -qr "$0" ${1+"$@"}
|#

;; Use me as a drop-in replacement for "anagrams.rkt" -- i.e., run me like

;; ./profile.rkt "Ernest Hemingway" > /dev/null

;; I am much slower than anagrams.rkt, but in theory I print out nice
;; profiling information when I'm done.  In practice it always seems
;; to be just three uninteresting lines.

(require (lib "errortrace.ss" "errortrace"))

(profiling-enabled #t)
(profiling-record-enabled #t)
(profile-paths-enabled #t)
(require "anagrams.rkt")
(apply main (vector->list (current-command-line-arguments)))
(parameterize ([current-output-port (current-error-port)])
  (output-profile-results #t #t))
