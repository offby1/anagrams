(define (read-line port)
  (iterate loop ((input* c port read-char))
           ((chars '()))
    (if (char=? c #\newline)
        (list->string (reverse chars))
      (loop (cons c chars)))
    (if (null? chars)
        (eof-object)                   ; from the PRIMITIVES structure
      (list->string (reverse chars)))))

(define word-acceptable?
  (let ((has-vowel-regexp (set "aeiouyAEIOU"))
        (has-non-ASCII-regexp (negate (ascii-ranges #\a #\z #\A #\Z))))
    (lambda (word)
      (let ((l (string-length word)))
        (and (not (zero? l))

             ;; it's gotta have a vowel.
             (match has-vowel-regexp word)

             ;; it's gotta be all ASCII, all the time.
             (not (match has-non-ASCII-regexp word))

             ;; it's gotta be two letters long, unless it's `i' or `a'.
             (or (string=? "i" word)
                 (string=? "a" word)
                 (< 1 l)))))))

(define (file-readable? f)
  (accessible? f (access-mode read)))

;; return a dictionary of words that can be made from CRITERION-BAG.
;; The dictionary is a list of entries; each entry is (cons key words)
(define (snarf-dictionary criterion-bag)
  (let ((*the-hash-table* (make-integer-table))
        (rv '()))
    (call-with-input-file
        (find file-readable? (list
                              "../../words") )
      (lambda (p)
        (display "Reading dictionary ... ")
        (let loop ((word (read-line p))
                   (words-read 0))
          (if (eof-object? word)
              (let ((words-kept 0))
                (table-walk (lambda (number words)
                              (if (subtract-bags criterion-bag number)
                                  (begin
                                    (set! words-kept (+ 1 words-kept))
                                    (set! rv (cons (cons number words)
                                                   rv)))))
                            *the-hash-table*)
                (display words-read)
                (display " words; kept ")
                (display words-kept)
                (newline)
                rv)
            (begin
              (if (word-acceptable? word)
                  (let* ((num  (bag word))
                         (prev (table-ref *the-hash-table* num)))
                    (if (not prev)
                        (set! prev '()))
                    (set! prev (cons word prev))
                    (table-set! *the-hash-table* num prev)))
              (loop (read-line p)
                    (+ 1 words-read)))))))))
