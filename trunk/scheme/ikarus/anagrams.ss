(import (rnrs)
        (ikarus)
        (dict)
        (bag))

(define (all-anagrams string dict-file-name )
  (let ((in-bag   (bag string)))
    (all-anagrams-internal
     in-bag
     (init in-bag dict-file-name))))

(define (pair-fold func seq)
  (let pf ((input seq)
           (accumulator '()))
    (if (null? input)
        (reverse accumulator)
        (pf (cdr input)
            (func input accumulator)))))

(define (all-anagrams-internal bag dict)
  (pair-fold
   (lambda (subdict accum)
     (let* ((key   (caar subdict))
            (words (cdar subdict))
            (smaller-bag (subtract-bags bag key)))

       (cond
        ((not smaller-bag)
         accum)
        ((bag-empty? smaller-bag)
         (append (map list words) accum))
        (else
         (append
          (combine
           words
           (all-anagrams-internal
            smaller-bag
            (filter (lambda (entry)
                      (subtract-bags
                       smaller-bag
                       (car entry)))
                    subdict)))
          accum)))))
   dict))


(define (combine words anagrams)
  "Given a list of WORDS, and a list of ANAGRAMS, creates a new
list of anagrams, each of which begins with one of the WORDS."
  (apply append (map (lambda (word)
                       (map (lambda (an)
                              (cons word an))
                            anagrams))
                     words)))

(let* ((in (cadr (command-line)))
       (result (all-anagrams
                in
                "../../words.utf8")))

  (fprintf (current-error-port)
           "~a anagrams of ~s~%"
           (length result)
           in)
  (let loop ((result result))
    (if (not (null? result))
        (begin
          (printf "~a~%" (car result))
          (loop (cdr result)))))
  (newline))
