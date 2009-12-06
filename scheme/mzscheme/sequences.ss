#! /bin/sh
#| Hey Emacs, this is -*-scheme-*- code!
#$Id$
exec  mzscheme -l errortrace --require "$0" --main -- ${1+"$@"}
|#

#lang scheme
(require (planet schematics/schemeunit:3)
         (planet schematics/schemeunit:3/text-ui))

(define (in-cdrs seq)
  (make-do-sequence
   (lambda ()
     (values
      ;; pos->element(s)
      (lambda (seq)
        (values (first seq)
                seq))

      ;; next-pos
      cdr

      ;; initial position
      seq

      ;; not-last?  pos->bool
      (compose not null?)

      ;; not-last?  element(s)->bool
      (const #t)

      ;; not-last? (-> pos elt ... bool)
      (const #t)))))

(define-test-suite in-cdrs-tests

  (check-equal?
   (for/list ([(elt rest) (in-cdrs (list 1 2 3))])
     (list elt rest))
   '((1 (1 2 3))
     (2 (2 3))
     (3 (3)))))

(define (main . args)
  (exit (run-tests in-cdrs-tests 'verbose)))
(provide in-cdrs main)
