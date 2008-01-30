#! /bin/sh
#| Hey Emacs, this is -*-scheme-*- code!
#$Id$
exec /usr/local/src/langs/arc/mzscheme-352/bin/mzscheme --no-init-file --mute-banner --version --load "$0"
|#

(current-directory "/usr/local/src/langs/arc/arc0/")

(load "ac.scm")

(require  (file "/usr/local/src/langs/arc/arc0/brackets.scm"))
(use-bracket-readtable)

(aload "arc.arc")
(aload "libs.arc")

(arc-eval '(prn "Hello, world"))
