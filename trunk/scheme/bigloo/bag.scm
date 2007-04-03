(module bag
    (export bag-empty? subtract-bags bag bag->string))

(define (bag s)
  "Return an object that describes all the letters in S, without
regard to order."
  (sort (filter char-alphabetic? (string->list (string-downcase s))) char<?))

(define bag-empty? null?)
(define bags=? equal?)
(define bag->string list->string)

;; top minus bottom.

;; if BOTTOM contains any characters that aren't in TOP, fail.

;; if BOTTOM contains more of a given character than TOP does, also fail.

(define (subtract-bags top bottom)

  (define (internal top bottom result)
    (cond
     ((null? bottom)
      (append (reverse result) top))
     ((null? top)
      #f)
     (else
      (let ((t (car top))
            (b (car bottom)))
        (cond
         ((char=? t b)
          (internal (cdr top)
                    (cdr bottom)
                    result))
         ((char<? t b)
          (internal (cdr top)
                    bottom
                    (cons t result)))
         (else
          #f))))))

  (cond
   ((internal top bottom '()) => values)
   (else #f)))



;;; unit tests

;; Notes about bags in general:

;; creating a bag from a string needn't be all that fast, since we'll
;; probably only do it a few thousand times per application (namely,
;; reading a dictionary of words), whereas subtracting bags needs to
;; be *really* fast, since I suspect we do this O(n!) times where n is
;; the length of the string being anagrammed.

;; I haven't figured out how to enable "assert" on bigloo.  So I'll write my own.
(define-syntax my-assert
  (syntax-rules ()
    ((my-assert _expr)
     (or _expr
         (error "failed assertion: " '_expr #f)))))

(define-syntax assert-bags=
  (syntax-rules ()
    ((_ b1 b2)
     (let ((result (bags=? b1 b2)))
       (if (not result)
         (error "failed assertion -- bags unequal: " b1 b2))))))

(my-assert (bag-empty? (bag "")))
(my-assert (not (bag-empty? (bag "a"))))
(assert-bags=  (bag "abc")
                (bag "cba"))

(assert-bags=  (bag "X")
                   (bag "x"))

(my-assert (not (bags=? (bag "abc")
                     (bag "bc"))))

(assert-bags= (bag "a")
              (bag "a "))

(assert-bags=  (bag "a")
                (subtract-bags (bag "ab")
                               (bag "b")))

(my-assert (not (subtract-bags (bag "a")
                            (bag "b"))))
(my-assert (not (subtract-bags (bag "a")
                            (bag "aa"))))

(let ((empty-bag (subtract-bags (bag "on")
                                (bag "no"))))
  (my-assert (bag-empty? empty-bag))
  (my-assert (not (not empty-bag))))

(my-assert (bags=? (bag "g") (subtract-bags (bag "dgo") (bag "do"))))
(my-assert (string=? (bag->string (bag "g")) "g"))
(my-assert (string=? (bag->string (bag "Dog!")) "dgo"))

;; ensure we maintain alphabetical order
(my-assert (string=? (bag->string (subtract-bags (bag "Fonda") (bag "fa"))) "dno"))

(display  "bag tests passed.")
(newline)
