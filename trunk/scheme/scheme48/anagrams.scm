(define (all-anagrams-internal bag dict)
  (define rv '())
  (let loop ((dict dict))
    (if (null? dict)
        rv
      (let ((key   (caar dict))
            (words (cdar dict)))
        (let ((smaller-bag (subtract-bags bag key)))
          (define pruned
            (filter (lambda (entry) (subtract-bags smaller-bag (car entry)))
                    dict))
          (if smaller-bag
              (if (bag-empty? smaller-bag)
                  (begin
                    (let ((combined (map list words)))
                      (set! rv (append! combined rv))))
                (let ((anagrams (all-anagrams-internal smaller-bag pruned)))
                  (if (not (null? anagrams))
                      (begin
                        (let ((combined (combine words anagrams)))
                          (set! rv (append! combined rv)))))))))

        (loop (cdr dict))))))


(define (combine words anagrams)
  "Given a list of WORDS, and a list of ANAGRAMS, creates a new
list of anagrams, each of which begins with one of the WORDS."
  (apply append (map (lambda (word)
                       (map (lambda (an)
                              (cons word an))
                            anagrams))
                     words)))

(define (anagrams str)
  (let* ((w (bag str))
         (pruned (snarf-dictionary w)))
    (with-output-to-file (string-append "pruned-" str)
      (lambda ()
        (write (sort-list pruned (lambda (p1 p2)
                                   (< (car p1)
                                      (car p2)))))))
    (all-anagrams-internal w pruned)))
