(library
 (dict)
 (export init)
 (import (bag)
         (rnrs)
         (rnrs hashtables (6))
         (ikarus))

(define (my-get-line ip)
  (let loop ((line-chars '()))
    (let ((one-char (read-char ip)))
      (cond
       ((eof-object? one-char)
        (if (null? line-chars)
            one-char
            (list->string (reverse line-chars))))
       ((member one-char '(#\newline #\return))
        (list->string (reverse line-chars)))
       (else
        (loop (cons one-char line-chars)))))))

(define (wordlist->hash fn)
  (call-with-input-file fn
    (lambda (ip)
      (let ((dict (make-eq-hashtable)))
        (fprintf (standard-error-port) "Reading dictionary ~s ... " fn)
        (let loop ((words-read 0))
          (let ((word (my-get-line ip)))
            (when (not (eof-object? word))
              (let ((word (list->string (map char-downcase (string->list word)))))
                (when (word-acceptable? word)
                  (adjoin-word! dict word))
                (loop (+ 1 words-read))))))
        (fprintf (standard-error-port) "done; ~s words, ~a distinct bags~%"
                 (apply
                  +
                  (vector->list
                   (vector-map
                    (lambda (key)
                      (length (hashtable-ref dict key '())))
                    (hashtable-keys dict))))
                 (hashtable-size dict))
        dict))))

(define (adjoin-word! dict word)
  (let ((bag (string->symbol (number->string (bag word)))))

    (define (! thing)
      (hashtable-set! dict bag thing))

    (let* ((probe (hashtable-ref
                   dict
                   bag
                   #f))
           (probe (or probe
                      (let ((new (list word)))
                        (! new)
                        new))))

      (if (not (member word probe))
          (! (cons word probe))))))

(define (has-matching-char? str char-predicate)
  (let loop ((result #f)
             (chars-to-examine (string-length str)))
    (cond
     (result result)
     ((zero? chars-to-examine)
      result)
     (else
      (loop (char-predicate (string-ref str (sub1 chars-to-examine)))
            (sub1 chars-to-examine))))))

(define (has-vowel? str)
  (has-matching-char?
   str
   (lambda (c) (member (char-downcase c) '(#\a #\e #\i #\o #\u)))))

(define (has-non-letter? str)
  (has-matching-char?
   str
   (lambda (c) (not (char-alphabetic? c)))))

(define word-acceptable?
  (lambda (word)
    (let ((l (string-length word)))
      (and (not (zero? l))

           ;; it's gotta have a vowel.
           (has-vowel? word)

           ;; it's gotta be all letters
           (not (has-non-letter? word))

           ;; it's gotta be two letters long, unless it's `i' or `a'.
           (or (string=? "i"  word)
               (string=? "a"  word)
               (< 1 l))))))

(define (init bag-to-meet dict-file-name)
  (let ((result (filter (trace-lambda bag-filter (entry)
                          (subtract-bags bag-to-meet (car entry)))
                        (vector->list
                         (let ((h (wordlist->hash dict-file-name)))
                           (vector-map
                            (lambda (key)
                              (cons key (hashtable-ref h key #f)))
                            (hashtable-keys h)))
                         )
                        )))
    (fprintf
     (standard-error-port)
     "Pruned dictionary now has ~a words~%"
     (apply + (map (lambda (seq)
                     (length (cdr seq)))
                   result)))
    result)

  ) )