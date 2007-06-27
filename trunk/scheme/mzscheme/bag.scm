(module bag
  mzscheme
  (require
   (planet "test.ss"     ("schematics" "schemeunit.plt" 2))
   (planet "text-ui.ss"  ("schematics" "schemeunit.plt" 2))
   (planet "util.ss"     ("schematics" "schemeunit.plt" 2)))
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

(test/text-ui
 (test-suite
  "The one and only suite"
  (test-case "sam" (check-true (bag-empty? (bag ""))))

  (test-case "fred" (check-false (bag-empty? (bag "a"))))
  (test-case "tim" (check-true  (bags=? (bag "abc")
                                         (bag "cba"))))

  (test-case "harry" (check-true (bags=? (bag "X")
                                          (bag "x"))))
  (test-case "mumble" (check-true (bags=? (bag "a!")
                                           (bag "a"))))
  (test-case "frotz" (check-false  (bags=? (bag "abc")
                                            (bag "bc"))))

  (test-case "zimbalist" (check-true (bags=? (bag "a")
                                              (subtract-bags (bag "ab")
                                                             (bag "b")))))

  (test-case "ethel" (check-false  (subtract-bags (bag "a")
                                                   (bag "b"))))
  (test-case "grunt" (check-false  (subtract-bags (bag "a")
                                                   (bag "aa"))))

  (let ((empty-bag (subtract-bags (bag "a")
                                  (bag "a"))))
    0
    (test-case "snork" (check-pred bag-empty? empty-bag))
    (test-case "qquuzz" (check-false (not empty-bag)))
    )

  ))
)
