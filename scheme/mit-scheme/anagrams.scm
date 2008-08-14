(define (all-anagrams-internal bag dict level)
  (define rv '())
  (let loop ((dict dict))
    (if (null? dict)
        rv
      (let ((key   (caar dict))
            (words (cdar dict)))
        (let ((smaller-bag (subtract-bags bag key)))
          (define pruned
            (keep-matching-items dict
                                 (lambda (entry) (subtract-bags smaller-bag (car entry)))))
          (if smaller-bag
              (if (bag-empty? smaller-bag)
                  (begin
                    (let ((combined (map list words)))
                      (set! rv (append! combined rv))))
                (let ((anagrams (all-anagrams-internal smaller-bag pruned (+ 1 level))))
                  (if (not (null? anagrams))
                      (set! rv (append! (combine words anagrams  (and #f (zero? level))) rv)))))))

        (loop (cdr dict))))))


(define (combine words anagrams verbose?)
  "Given a list of WORDS, and a list of ANAGRAMS, creates a new
list of anagrams, each of which begins with one of the WORDS."
  (let ((unappended (map (lambda (word)
                           (map (lambda (an)
                                  (cons word an))
                                anagrams))
                         words)))
    (if verbose? (for-each (lambda (x)
                             (for-each (lambda (y)
                                         (display y)
                                         (newline))
                                       x))
                           unappended))
    (apply append unappended)))

(define (anagrams str)
  (let* ((w (bag str))
         (pruned  (snarf-dictionary w)))
    (with-output-to-file (string-append "pruned-" str)
      (lambda ()
        (write (sort pruned (lambda (p1 p2)
                              (< (car p1)
                                 (car p2)))))))
    (all-anagrams-internal w pruned 0)))
