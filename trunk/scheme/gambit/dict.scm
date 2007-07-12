(define *big-ol-hash-table* #f)

(define (wordlist->hash fn)

  (define (string-downcase s)
    (list->string (map char-downcase (string->list s))))

  (with-input-from-file fn
    (lambda ()
      (let ((dict (make-table init: #f
                              test: eqv?
                              size: 90000
                              )))
        (display  "Reading dictionary ... " (current-error-port))
        (let loop ((words-saved 0))
          (let ((word  (read-line)))
            (if (eof-object? word)
                (begin
                  (display  " done: " (current-error-port))
                  (display words-saved (current-error-port))
                  (display " words."  (current-error-port))
                  (newline (current-error-port)))
              (let ((word (string-downcase word)))
                (if (word-acceptable? word)
                    (begin
                      (adjoin-word dict word)
                      (loop (+ 1 words-saved)))
                  (loop words-saved))))))
        dict)
      )))

(define *dictionary* #f)

(define (adjoin-word dict word)
  (let* ((this-bag (bag word))
         (probe (table-ref dict this-bag)))
    (cond
     ((not probe)
      (table-set! dict this-bag (list word)))
     ((not (member word probe))
      (table-set! dict this-bag (cons word probe)))
     )))

(define (word-acceptable? word)

  (define (at-least-one pred l)
    (and (not (null? l))
	 (or (pred (car l))
	     (at-least-one pred (cdr l)))))

  (define (string-contains-matching-char? char-pred s)
    (at-least-one char-pred (string->list s)))

  (define (has-vowel? s)
    (string-contains-matching-char?
     (lambda (c)
       (case (char-downcase c)
         ((#\a #\e #\i #\o #\u) #t)
         (else #f))) s ))

  (define (has-non-letter? s)
    (string-contains-matching-char?
     (lambda (c)
       (or (char-ci<? c #\a)
           (char-ci>? c #\z)))
     s))


  (let ((l (string-length word)))
    (and (not (zero? l))

         ;; it's gotta have a vowel.
         (has-vowel? word)

         ;; it's gotta be all letter, all the time.
         (not (has-non-letter? word))

         ;; it's gotta be two letters long, unless it's `i' or `a'.
         (or (< 1 l)
	     (string-ci=? "i" word)
             (string-ci=? "a" word)))))

(define (init bag-to-meet dict-file-name)
  (if (not *big-ol-hash-table*)
      (set! *big-ol-hash-table* (wordlist->hash dict-file-name)))

  (display "Pruning dictionary ... " (current-error-port))

  (set! *dictionary*
        (filter (lambda (entry)
                  (subtract-bags bag-to-meet (car entry)))
                (table->list *big-ol-hash-table*)))
  (display " done; down to "     (current-error-port))
  (display (apply + (map length (map cdr *dictionary*))) (current-error-port))
  (display " words: "            (current-error-port))
  ;(write *dictionary*            (current-error-port))
  (newline                       (current-error-port)))

