#! /bin/sh
#| Hey Emacs, this is -*-scheme-*- code!
exec racket -l errortrace --require "$0" --main -- ${1+"$@"}
|#

#lang racket
(require rackunit rackunit/text-ui)

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
