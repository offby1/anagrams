(define (filter proc seq)
  (let loop ((seq seq)
             (result '()))
    (if (null? seq)
        (reverse result)
      (loop (cdr seq)
            (if (proc (car seq))
                (cons (car seq)
                      result)
              result)))))

(define (find pred seq)
  (cond
   ((null? seq)
    #f)
   ((pred (car seq))
    (car seq))
   (else
    (find pred (cdr seq)))))

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

                      (set! rv (append rv combined))))
                (let ((anagrams (all-anagrams-internal smaller-bag pruned)))
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

(let ((b (bag (apply string-append (cddr (command-line))))))
  (init b  (find file-exists? (list
                                 "/usr/share/dict/words"
                                 "/usr/share/dict/american-english") )
           )
  (let ((result (all-anagrams-internal b *dictionary*)))
    (display (length result)        (current-error-port))
    (display " anagrams of "        (current-error-port))
    (display (cddr (command-line)) (current-error-port))
    (newline                        (current-error-port))
    (write result)
    (newline)))
