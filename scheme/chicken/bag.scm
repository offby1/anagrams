(declare (unit bag)
         (uses srfi-1))

(define (string-downcase s)
  (list->string (map char-downcase (string->list s))))

(define (bag s)
  "Return an object that describes all the letters in S, without
regard to order."
  (list->string (sort (filter char-alphabetic? (string->list (string-downcase s))) char<?)))


(define (bag-empty? s) (string=? s ""))
(define bags=? string=?)


;; top minus bottom.

;; if BOTTOM contains any characters that aren't in TOP, fail.

;; if BOTTOM contains more of a given character than TOP does, also fail.

(define (subtract-bags top bottom)

  (define (string-cdr s)
    (substring s 1 (string-length s)))

  (let loop ((top top)
             (bottom bottom)
             (result ""))
    (cond
     ((string=? bottom "")
      (string-append result top))
     ((string=? top "")
      #f)
     (else
      (let ((t (string-ref top    0))
            (b (string-ref bottom 0)))
        (cond
         ((char=? t b)
          (loop (string-cdr top)
                (string-cdr bottom)
                result))
         ((char<? t b)
          (loop (string-cdr top)
                bottom
                (string-append result (make-string 1 t))))
         (else
          #f)))))))


;;; unit tests

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

(assert (bags=? (bag "X")
                (bag "x")))

(assert (not (bags=? (bag "abc")
                     (bag "bc"))))

(assert (bags=? (bag "a")
                (subtract-bags (bag "ab")
                               (bag "b"))))

(assert (bags=? (bag "a ")
                (bag "a")))

(assert (not (subtract-bags (bag "a")
                            (bag "b"))))
(assert (not (subtract-bags (bag "a")
                            (bag "aa"))))

(let ((empty-bag (subtract-bags (bag "a")
                                (bag "a"))))
  (assert (bag-empty? empty-bag))
  (assert empty-bag))

(display  "bag tests passed." (current-error-port))
(newline (current-error-port))
