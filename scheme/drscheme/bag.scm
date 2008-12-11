#lang scheme

(require  (planet schematics/schemeunit:3)
          (planet schematics/schemeunit:3/text-ui))
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
  (let loop ((chars-to-examine (string-length s))
             (product 1))
    (if (zero? chars-to-examine)
        product
        (loop (- chars-to-examine 1)
              (* product (char->factor (string-ref s (- chars-to-examine 1))))))))

(define (subtract-bags b1 b2)
  (when (bag-empty? b2)
    (error "Hey!  Don't subtract the empty bag."))
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

(check-not-false (bag-empty? (bag "")))
(check-not-false (not (bag-empty? (bag "a"))))
(check-not-false (bags=? (bag "abc")
                         (bag "cba")))

(check-not-false (not (bags=? (bag "abc")
                              (bag "bc"))))

(check-not-false (bags=? (bag "a")
                         (subtract-bags (bag "ab")
                                        (bag "b"))))

(check-not-false (not (subtract-bags (bag "a")
                                     (bag "b"))))
(check-not-false (not (subtract-bags (bag "a")
                                     (bag "aa"))))

(let ((empty-bag (subtract-bags (bag "a")
                                (bag "a"))))
  (check-not-false (bag-empty? empty-bag))
  (check-not-false empty-bag))

(fprintf (current-error-port) (format "bag tests passed.~%"))
