(module dict
mzscheme
(require "bag.scm"
         (lib "trace.ss")
         (only (lib "list.ss") quicksort)
         (only (lib "1.ss" "srfi") filter))
(provide init)

(define (wordlist->hash fn)
  (with-input-from-file fn
    (lambda ()
      (let ((dict (make-hash-table 'equal)))
        (fprintf (current-error-port) "Reading dictionary ~s ... " fn)
        (let loop ((words-read 0))
          (let ((word (read-line)))
            (when (not (eof-object? word))
              (let ((word (string-downcase word)))
                (when (word-acceptable? word)
                  (adjoin-word! dict word))
                (loop (+ 1 words-read))))))
        (fprintf (current-error-port) "done; ~s words, ~a distinct bags~%"
                 (length (apply append (map cdr (hash-table-map dict cons))))
                 (hash-table-count dict))
        dict))))

(define (adjoin-word! dict word)
  (let ((bag (bag word)))

    (define (! thing)
      (hash-table-put! dict bag thing))

    (let ((probe (hash-table-get
                  dict
                  bag
                  (lambda ()
                    (let ((new (list word)))
                      (! new)
                      new)))))
      (if (not (member word probe))
          (! (cons word probe))))))

(define word-acceptable?
  (let ((has-vowel-regexp (regexp "[aeiouAEIOU]"))
        (has-non-letter-regexp (regexp "[^a-zA-Z]")))
    (lambda (word)
      (let ((l (string-length word)))
        (and (not (zero? l))

             ;; it's gotta have a vowel.
             (regexp-match has-vowel-regexp word)

             ;; it's gotta be all letters
             (not (regexp-match has-non-letter-regexp word))

             ;; it's gotta be two letters long, unless it's `i' or `a'.
             (or (string=? "i" word)
                 (string=? "a" word)
                 (< 1 l)))))))

(define (init bag-to-meet dict-file-name)
  (let ((result (filter (lambda (entry)
                          (subtract-bags bag-to-meet (car entry)))
                        (hash-table-map (wordlist->hash dict-file-name) cons))))
    (fprintf
     (current-error-port)
     "Pruned dictionary now has ~a words~%"
     (apply + (map (lambda (seq)
                     (length (cdr seq)))
                   result)))
    result)

  ))
