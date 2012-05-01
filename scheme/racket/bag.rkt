#! /bin/sh
#| Hey Emacs, this is -*-scheme-*- code!
exec racket -l errortrace --require "$0" --main -- ${1+"$@"}
|#

#lang racket
(require rackunit rackunit/text-ui)

(provide bag subtract-bags bag-empty? bags=?)
(define primes #(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101))

(define char->factor
  (let ((a-code (char->integer #\a)))
    (lambda (c)
      (if (char-alphabetic? c)
          (let ((index (- (char->integer (char-downcase c))
                          a-code)))
            (vector-ref primes index))
          1))))

(define (bag s)
  "Return an object that describes all the letters in S, without
regard to order."
  (for/product ([ch (in-string s)])
               (char->factor ch)))

(define (subtract-bags b1 b2)
  (let ((quotient (/ b1 b2)))
    (and (integer? quotient)
         quotient)))

(define (bag-empty? b)
  (= 1  b))

(define bags=? =)

;;; unit tests

;; Notes about bags in general:

;; creating a bag from a string needn't be all that fast, since we'll
;; probably only do it a few thousand times per application (namely,
;; reading a dictionary of words), whereas subtracting bags needs to
;; be *really* fast, since I suspect we do this O(n!) times where n is
;; the length of the string being anagrammed.

(define-test-suite bag-tests


  (check-true (bag-empty? (bag "")))

  (check-false (bag-empty? (bag "a")))
  (check-true  (bags=? (bag "abc")
                       (bag "cba")))

  (check-true (bags=? (bag "X")
                      (bag "x")))
  (check-true (bags=? (bag "a!")
                      (bag "a")))
  (check-false  (bags=? (bag "abc")
                        (bag "bc")))

  (check-true (bags=? (bag "a")
                      (subtract-bags (bag "ab")
                                     (bag "b"))))

  (check-false  (subtract-bags (bag "a")
                               (bag "b")))
  (check-false  (subtract-bags (bag "a")
                               (bag "aa")))

  (let ((empty-bag (subtract-bags (bag "a")
                                  (bag "a"))))
    (check-pred bag-empty? empty-bag)
    (check-false (not empty-bag))))

(provide main)
(define (main . args)
  (exit (run-tests bag-tests)))
