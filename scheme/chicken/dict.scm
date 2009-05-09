;;; Thanks to "zbigniew" on #scheme for pointing out that using alists
;;; as hash keys is a _really_ bad idea.

(declare (unit dict))
(declare (uses bag))

(require-extension regex)
(require-extension srfi-1)

(define word-acceptable?
  (let ((has-vowel-regexp (regexp "[aeiouy]" #t))
        (has-non-ASCII-regexp (regexp "[^a-zA-Z]" #t)))
    (lambda (word)
      (let ((l (string-length word)))
        (and (not (zero? l))

             ;; it's gotta have a vowel.
             (string-match has-vowel-regexp word)

             ;; it's gotta be all ASCII, all the time.
             (not (string-match has-non-ASCII-regexp word))

             ;; it's gotta be two letters long, unless it's `i' or `a'.
             (or (string=? "i" word)
                 (string=? "a" word)
                 (< 1 l)))))))

(define *the-dictionary* #f)
(define *dict-cache-file-name* "cached-dictionary")
(define (err . args)
  (for-each (lambda (arg)
              (display arg  (current-error-port)))
           args))
(define (string-downcase s)
  (list->string (map char-downcase (string->list s))))
(if (file-exists? *dict-cache-file-name*)
    (begin
      (err "Reading ")(err *dict-cache-file-name*) (err " ... ")
      (set! *the-dictionary* (with-input-from-file *dict-cache-file-name* read))

      ;; originally I had

      ;; (apply + (map (lambda (e) (length (cdr e))) *the-dictionary*))

      ;; but that segfaulted, perhaps because I was passing tens of
      ;; thousands of arguments.
      (err (let loop ((d *the-dictionary*)
                      (sum 0))
             (if (null? d)
                 sum
               (loop (cdr d)
                     (+ sum (length (cdar d)))))))
      (err " entries")
      (newline (current-error-port)))
  (let ((ht  (make-hash-table)))
    (call-with-input-file
        "words"
      (lambda (p)
        (display "Reading dictionary ... " (current-error-port))
        (newline (current-error-port))
        (let loop ((words-read 0))
          (let ((word (read-line p)))
            (when (not (eof-object? word))
              (let ((word (string-downcase word)))
                (when (zero? (remainder words-read 1000))
                  (display "Read " (current-error-port))
                  (display words-read (current-error-port))
                  (display " words ..." (current-error-port))
                  (newline (current-error-port)))
                (if (word-acceptable? word)
                    (let* ((key  (bag word))
                           (prev (hash-table-ref ht key (lambda () '()))))
                      (if (not (member word prev))
                          (set! prev (cons word prev)))
                      (hash-table-set! ht key prev))))
              (loop (+ 1 words-read)))))))
    (set! *the-dictionary*
          ;; put longest words first.
          (sort
           (hash-table->alist ht)
           (lambda (e1 e2)
             (> (string-length (cadr e1))
                (string-length (cadr e2))))))
    (with-output-to-file *dict-cache-file-name*
      (lambda ()
        ;;(write *the-dictionary*)

        ;; add plenty of line breaks so that CVS Emacs (March 2006)
        ;; can visit the file without freaking out
        (display "(") (newline)
        (for-each (lambda (entry)
                    (write entry)
                    (newline))
                  *the-dictionary*)
        (display ")") (newline)
        ))
    (display "Wrote " )
    (write *dict-cache-file-name*)
    (newline)))

;; return a dictionary of words that can be made from CRITERION-BAG.
;; The dictionary is a list of entries; each entry is (cons key words)
(define (dictionary-for criterion-bag)
  (let ((rv (filter (lambda (p)
            (subtract-bags criterion-bag (car p)))
          *the-dictionary*)))
    (with-output-to-file "pruned" (lambda () (write (sort (map cdr rv)
                                                          (lambda (a b)
                                                            (string<? (car a)
                                                                      (car b)))))))
    rv))
