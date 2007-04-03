(define-module dict
  (use bag)
  (use srfi-1)
  (export dictionary-for))

(select-module dict)

(define word-acceptable?
  (let ((has-vowel-regexp #/[aeiou]/i)
        (has-non-letter-regexp #/[^a-z]/i))
    (lambda (word)
      (let ((l (string-length word)))
        (and (not (zero? l))

             ;; it appears that word will be "incomplete" if and only
             ;; if it contains non-ASCII characters.
             (not (string-incomplete? word))

             ;; it's gotta have a vowel.
             (rxmatch has-vowel-regexp word)

             ;; it's gotta be all ASCII, all the time.
             (not (rxmatch has-non-letter-regexp word))

             ;; it's gotta be two letters long, unless it's `i' or `a'.
             (or (string=? "i" word)
                 (string=? "a" word)
                 (< 1 l)))))))
(define *ht* (make-hash-table 'eqv?))
(define (adjoin-word! dict word)
  (let ((bag (bag word)))

    (define (! thing)
      (hash-table-put! dict bag thing))

    (let ((probe (hash-table-get dict bag #f)))
      (if (not probe)
          (! (list word))
        (if (not (member word probe))
            (! (cons word probe)))))))
(call-with-input-file "/usr/share/dict/words"
  (lambda (p)
    (let loop ((words-saved 0))
      (let ((line (read-line p #t)))
        (if (eof-object? line)
            (begin
              (display "Dictionary has ")
              (display words-saved)
              (display " entries")
              (newline)
              )
            (if (word-acceptable? line)
                (begin
                  (adjoin-word! *ht* (list->string (map char-downcase (string->list line))))
                  (loop (+ 1 words-saved)))
              (loop words-saved))
          )))))

;; now convert the hash table to a list
(define (dictionary-for criterion-bag)
  (filter
   (lambda (pair) (subtract-bags criterion-bag (car pair)))
   (hash-table-map *ht* cons)))

(provide "dict")
