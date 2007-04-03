(define-module (bag))

(define primes #(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101))


(define char->index #f)
(define char->factor #f)

(let ((a-code (char->integer #\a)))
   
  (set! char->index
        (lambda ( c)
          (- (char->integer (char-downcase c))
             a-code)))

  (set! char->factor
        (lambda (c)
          (if (char-alphabetic? c)
              (vector-ref primes (char->index c))
            1))))

(define-public (bag s)
  "Return an object that describes all the letters in S, without
regard to order."
  (let loop ((chars-to-examine (string-length s))
             (product 1))
    (if (zero? chars-to-examine)
        product
      (loop (- chars-to-examine 1)
            (* product (char->factor (string-ref s (- chars-to-examine 1))))))))

(define-public (subtract-bags b1 b2)
  (if (bag-empty? b2)
      (error "Hey!  Don't subtract the empty bag."))
  (let ((quotient (/ b1 b2)))
    (and (integer? quotient)
          quotient)))

(define-public (bag-empty? b)
  (= 1  b))

(define-public bags=? =)

;;; unit tests
(use-modules (assert))

;; Notes about bags in general:

;; creating a bag from a string needn't be all that fast, since we'll
;; probably only do it a few thousand times per application (namely,
;; reading a dictionary of words), whereas subtracting bags needs to
;; be *really* fast, since I suspect we do this O(n!) times where n is
;; the length of the string being anagrammed.

(assert (bag-empty? (bag "")))
(assert (not (bag-empty? (bag "a"))))
(assert (bags=? (bag "abc")
                (bag "cba")))

(assert (not (bags=? (bag "abc")
                     (bag "bc"))))

(assert (bags=? (bag "a")
                (subtract-bags (bag "ab")
                               (bag "b"))))

(assert (not (subtract-bags (bag "a")
                            (bag "b"))))
(assert (not (subtract-bags (bag "a")
                            (bag "aa"))))

(let ((empty-bag (subtract-bags (bag "a")
                                (bag "a"))))
  (assert (bag-empty? empty-bag))
  (assert empty-bag))

(format #t "~a tests passed.~%" (module-name (current-module)))
