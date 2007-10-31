(library
 (dict)
 (export init)
 (import (bag)
         (rnrs)
         (rnrs hashtables (6))
         (ikarus))

(define (wordlist->hash fn)
  (with-input-from-file fn
    (lambda ()
      (let ((dict (make-eqv-hashtable)))
        (fprintf (standard-error-port) "Reading dictionary ~s ... " fn)
        (let loop ((words-read 0))
          (let ((word (get-line)))
            (when (not (eof-object? word))
              (let ((word (string-downcase word)))
                (when (word-acceptable? word)
                  (adjoin-word! dict word))
                (loop (+ 1 words-read))))))
        (fprintf (standard-error-port) "done; ~s words, ~a distinct bags~%"
                 (length (apply append (let-values (((keys values)
                                                     (hashtable-entries dict)))
                                         values)))
                 (hashtable-size dict))
        dict))))

(define (adjoin-word! dict word)
  (let ((bag (bag word)))

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
  (let ((result (filter (lambda (entry)
                          (subtract-bags bag-to-meet (car entry)))
                        (vector->list
                         (let ((h (wordlist->hash dict-file-name)))
                           (vector-map
                            (lambda (key)
                              (cons key (hashtable-ref h)))
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