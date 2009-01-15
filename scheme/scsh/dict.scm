(define *the-dictionary* (make-integer-table))

(define word-acceptable?
  (let ((has-vowel-regexp (make-regexp "[aeiouyAEIOUY]"))
        (has-non-letter-regexp (make-regexp "[^a-zA-Z]")))
    (lambda (word)
      (and
       ;; it's gotta have a vowel.
       (string-match has-vowel-regexp word)

       ;; it's gotta be all letters -- no weird un-American characters
       ;; allowed!
       (not (string-match has-non-letter-regexp word))

       ;; it's gotta be two letters long, unless it's `i' or `a'.
       (or (string=? "i" word)
           (string=? "a" word)
           (< 1 (string-length word)))))))

;; returns a list of words that can be made from CRITERION-BAG.
(define (prune-dictionary criterion-bag)
  (let ((rv '())
        (words-seen 0)
        (words-saved 0))
    (display "Pruning dictionary ... " (current-error-port))
    (table-walk (lambda (number words)
                  (set! words-seen (+ words-seen (length words)))
                  (if (subtract-bags criterion-bag number)
                      (begin
                        (set! words-saved (+ words-saved (length words)))
                        (set! rv (cons (cons number words)
                                       rv)))))
                *the-dictionary*)
    (display "Before: "  (current-error-port))
    (display words-seen  (current-error-port))
    (display "; after: " (current-error-port))
    (display words-saved (current-error-port))
    (newline             (current-error-port))
    rv))

(define (snarf-dictionary)
  (display "Reading dictionary; this takes a long time ... ")
  (let loop ((wordlist (with-cwd "/usr/share/dict"
                                 (call-with-input-file (find file-readable? (list
                                                                             "words"
                                                                             "american-english") )
                                   (lambda (p)
                                     (port->string-list p))))))
    (if (pair? wordlist)
        (let ((word (car wordlist)))
          (if (word-acceptable? word)
              (let* ((num  (bag word))
                     (prev (table-ref *the-dictionary* num)))
                (if (not prev)
                    (set! prev '()))
                (set! prev (cons word prev))
                (table-set! *the-dictionary* num prev)))
          (loop (cdr wordlist)))))
  (display "done")
  (newline))
