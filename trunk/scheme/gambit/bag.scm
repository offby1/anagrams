(define primes (vector 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101))

(define char->factor
  (let ((a-code (char->integer #\a)))
    (lambda (c)
      (if (char-alphabetic? c)
          (let ((index (- (char->integer (char-downcase c))
                          a-code)))
            (vector-ref primes index))
        1))))

(define (binary-splitting-product list)
  (let loop ((list list)
	     (next-list '()))
    (cond ((null? list)
	   (cond ((null? next-list)
		  1)
		 ((null? (cdr next-list))
		  (car next-list))
		 (else (loop next-list '()))))
	  ((null? (cdr list))
	   (loop (cdr list)
		 (cons (car list) next-list)))
	  (else
	   (loop (cddr list)
		 (cons (* (car list) (cadr list))
		       next-list))))))

(define (bag s)
  "Return an object that describes all the letters in S, without
regard to order."
  (binary-splitting-product (map char->factor (string->list s))))

(define (subtract-bags b1 b2)
  (let ((qr (##exact-int.div b1 b2)))
    (and (zero? (cdr qr))
	 (car qr))))

(define (bag-empty? b)
  (= 1  b))

(define bags=? =)

