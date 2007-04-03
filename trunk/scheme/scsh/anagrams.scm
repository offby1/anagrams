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
                      (set! rv (append! rv combined))))
                (let ((anagrams (all-anagrams-internal smaller-bag pruned)))
                  (if (not (null? anagrams))
                      (begin
                        (let ((combined (combine words anagrams)))
                          (set! rv (append! rv combined)))))))))

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
  (let ((b (bag str)))
    (all-anagrams-internal
     b
     (prune-dictionary b))))

(define (main args)
  (let* ((input  (cadr args))
         (result (anagrams input)))
    (display (length result) (current-error-port))
    (display " anagrams of " (current-error-port))
    (write input             (current-error-port))
    (display ": "            (current-error-port))
    (newline                 (current-error-port))
    (for-each (lambda (a)
                (display a)
                (newline))
             result)))
