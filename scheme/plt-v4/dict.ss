#lang scheme

(require "bag.ss")

(provide dict-init)

(define (wordlist->hash fn)
  (with-input-from-file fn
    (lambda ()
      (let ((dict (make-hash)))
        (fprintf (current-error-port) "Reading dictionary ~s ... " fn)
        (let loop ((words-read 0))
          (let ((word (read-line)))
            (when (not (eof-object? word))
              (let ((word (string-downcase word)))
                (when (word-acceptable? word)
                  (adjoin-word! dict word))
                (loop (+ 1 words-read))))))
        (fprintf (current-error-port) "done; ~s words, ~a distinct bags~%"
                 (length (apply append (map cdr (hash-map dict cons))))
                 (hash-count dict))
        dict))))

(define (adjoin-word! dict word)
  (let ((bag (bag word)))

    (define (! thing)
      (hash-set! dict bag thing))

    (let ((probe (hash-ref
                  dict
                  bag
                  (lambda ()
                    (let ((new (list word)))
                      (! new)
                      new)))))
      (when (not (member word probe))
        (! (cons word probe))))))

(define word-acceptable?
  (let ((has-vowel-regexp (regexp "[aeiou]"))
        (has-non-letter-regexp (regexp "[^a-z]")))
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

(define (dict-init bag-to-meet dict-file-name)
  (let ((result (filter (lambda (entry)
                          (subtract-bags bag-to-meet (car entry)))
                        (hash-map (wordlist->hash dict-file-name) cons))))
    (fprintf
     (current-error-port)
     "Pruned dictionary now has ~a words~%"
     (apply + (map (lambda (seq)
                     (length (cdr seq)))
                   result)))
    result)

  )
