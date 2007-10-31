(library
 (bag)
 (export  bag subtract-bags bag-empty? bags=?)
 (import (rnrs))

 (define primes (vector 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101))

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
 )