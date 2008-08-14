#!/usr/local/bin/scshvm \
-o scshvm -h 28000000 -i /usr/local/lib/scsh/scsh.image -o scheme-with-scsh -o tables -o primitives -o srfi-23 -o srfi-1 -o sort -l bag.scm -l dict.scm -l anagrams.scm -e compile -s
!#

(define (compile args)
  (snarf-dictionary)

  ;; this call to with-resources-aligned shouldn't be necessary, but
  ;; is, because of a bug in scsh 0.6.7.  (The bug is simply that
  ;; dump-scsh-program should use with-resources-aligned to wrap its
  ;; own guts for me)

  ;; Thanks to Taylor Campbell
  (with-resources-aligned
   (list cwd-resource)
   (lambda ()
     (dump-scsh-program main "anagrams.image"))))
