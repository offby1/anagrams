(module anagrams
    (main start)
    (import (dict "dict.scm")
            (bag "bag.scm")))

(define (all-anagrams-internal bag dict)
  (define rv '())
  (let loop ((dict dict))
    (if (null? dict)
        rv
      (let ((key   (caar dict))
            (words (cdar dict)))
        (let ((smaller-bag (subtract-bags bag key)))
          (if smaller-bag
              (if (bag-empty? smaller-bag)
                  (begin
                    (let ((combined (map list words)))
                      (set! rv (append rv combined))))
                (let ((anagrams (all-anagrams-internal
                                 smaller-bag
                                 (filter (lambda (entry) (subtract-bags smaller-bag (car entry)))
                                         dict))))
                  (if (not (null? anagrams))
                      (begin
                        (let ((combined (combine words anagrams)))
                          (set! rv (append rv combined)))))))))

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
  (let* ((b (bag str))
         (pruned (dictionary-for b))
         )

    (display "Pruned dictionary has "(current-error-port))
    (display (apply + (map length (map cdr pruned))) (current-error-port))
    (display " entries"(current-error-port))
    ;;     (write pruned (current-error-port))
    (newline (current-error-port))

    (let ((result (all-anagrams-internal b pruned)))
      (display (length result) (current-error-port))
      (display " anagrams of "(current-error-port))
      (write str (current-error-port))
      (display ":"(current-error-port))
      (newline (current-error-port))
      (display result) (newline)
      )
    ))

(define (start argv)
 (write argv) (newline)
 (anagrams (cadr argv))
 (newline))
