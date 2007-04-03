(load-option 'regular-expression)
(load-option 'rb-tree)
(define word-acceptable?
  (let ((has-vowel-regexp (rexp-compile (rexp-case-fold (string->char-set "aeiou"))))
        (has-non-letter-regexp (rexp-compile (char-set-invert
                                              (char-set-union
                                               (ascii-range->char-set (char->ascii #\A) (+ 1 (char->ascii #\Z)))
                                               (ascii-range->char-set (char->ascii #\a) (+ 1 (char->ascii #\z))))))))
    (lambda (word)
      (let ((l (string-length word)))
        (and (not (zero? l))

             ;; it's gotta have a vowel.
             (re-string-search-forward has-vowel-regexp word)

             ;; it's gotta be all letters
             (not (re-string-search-forward has-non-letter-regexp word))

             ;; it's gotta be two letters long, unless it's `i' or `a'.
             (or (string=? "i" word)
                 (string=? "a" word)
                 (< 1 l)))))))

;; return a dictionary of words that can be made from CRITERION-BAG.
;; The dictionary is a list of entries; each entry is (cons key words)

;; Riastradh suggested the strong-hash-table/constructor instead of
;; make-eqv-hash-table, which is what I first tried, and which was
;; intolerably slow

(define (snarf-dictionary criterion-bag)
  (let* ((ht-ctor   (strong-hash-table/constructor
                     (lambda (integer modulus)
                       (remainder (abs integer) modulus))
                     =))
         (*the-table* (ht-ctor 65000)))
    (call-with-input-file
        "/usr/share/dict/words"
      (lambda (p)
        (display "Reading dictionary ... ")
        (let loop ((word (read-line p))
                   (words-read 0))
          (if (eof-object? word)
              (let ((pruned (keep-matching-items  (hash-table->alist *the-table*)
                                                  (lambda (entry)
                                                    (subtract-bags criterion-bag (car entry))))))
                (display words-read)
                (display " words in dictionary; ")
                (display "kept ")
                (display (length pruned))
                (display " of them")
                (newline)
                pruned)
            (begin
              (if (word-acceptable? word)
                  (let* ((num  (bag word))
                         (prev (hash-table/get *the-table* num '())))
                    (set! prev (cons word prev))

                    (hash-table/put! *the-table* num prev)))

              (loop (read-line p)
                    (+ 1 words-read)))))))))
