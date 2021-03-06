#lang racket
(require  "bag.rkt")
(module+ test
  (require
   rackunit
   rackunit/text-ui
   (lib "etc.ss")))
(require srfi/1
         srfi/26)

(provide init)

;; Creates a function named FUNCTION-NAME that applies
;; INPUT-PORT-CONSUMER to an input port derived from its lone
;; argument.  If that argument is already an input port, it just uses
;; it unchanged; if it's a string or a path, then it opens the port in
;; the obvious way (and closes it when it's done).
(define-syntax-rule (define-flexible-reader function-name input-port-consumer)
  (define function-name
    (match-lambda
     [(? string? input-file-name)
      (function-name (build-path input-file-name))]
     [(? path? input-path)
      (call-with-input-file input-path function-name)]
     [(? input-port? inp)
      (input-port-consumer inp)])))

;; Takes either a file name, or an input port.  This makes testing easier.
(define-flexible-reader wordlist->hash
  (lambda (inp)
    (for/fold ([dict (make-immutable-hash '())])
        ([word (in-lines inp)])
        (let ((word (string-downcase word)))
          (if (word-acceptable? word)
              (adjoin-word dict word)
              dict)))))

(define (adjoin-word dict word)
  (hash-update
   dict
   (bag word)
   (cut lset-adjoin equal? <> word)
   '()))

(define word-acceptable?
  (let ((has-vowel-regexp (regexp "[aeiouy]"))
        (has-non-letter-regexp (regexp "[^a-z]")))
    (lambda (word)
      (and
       ;; it's gotta have a vowel.
       (regexp-match has-vowel-regexp word)

       ;; it's gotta be all letters
       (not (regexp-match has-non-letter-regexp word))

       ;; it's gotta be two letters long, unless it's `i' or `a'.
       (or (string=? "i" word)
           (string=? "a" word)
           (< 1 (string-length word)))))))

(define (init bag-to-meet dict-file-name)
  (let ((result (filter (lambda (entry)
                          (subtract-bags bag-to-meet (car entry)))
                        (hash-map (wordlist->hash dict-file-name) cons))))
    (fprintf
     (current-error-port)
     "Pruned dictionary now has ~a words~%"
     (apply + (map (lambda (seq)
                     (length (cdr seq)))
                   result)))

    ;; I never knew this before December 2008, but sorting the result
    ;; makes the algorithm go a _lot_ faster.  Matthew Flatt pointed
    ;; that out --
    ;; http://groups.google.com/group/plt-scheme/msg/69df9547af5dc679
    (sort result > #:key car)))


(module+ test
  (check-not-false (word-acceptable? "dog"))
  (check-false (word-acceptable? "C3PO"))
  (let ([d (wordlist->hash (build-path (this-expression-source-directory) 'up 'up "words"))])
    (check-equal? (length (apply append (map cdr (hash-map d cons)))) 72794)
    (check-equal? (hash-count d) 66965))

  (let ((d (adjoin-word (make-immutable-hash '()) "frotz")))
    (let ((alist (hash-map d cons)))
      (check-equal? alist (list (cons  (bag "frotz")
                                       (list "frotz")))))
    (let ((alist (hash-map (adjoin-word d "zortf") cons)))
      (check-equal? (caar alist) (bag "frotz"))
      (check-not-false (member "zortf" (cdar alist)))
      (check-not-false (member "frotz" (cdar alist))))

    (let* ((alist (hash-map (adjoin-word d "plonk") cons))
           (probe (assoc (bag "plonk" )
                         alist)))
      (check-equal? 2 (length alist))
      (check-equal? probe (cons (bag "plonk") (list "plonk")))))
  (let ((d (wordlist->hash (open-input-string "god\ncat\ndog\n"))))
    (check-equal? 2 (hash-count d)))
  (let ((d (wordlist->hash (open-input-string "see\nshy\nJo\n"))))
    (test-not-false "see" (hash-ref d (bag "see")))
    (test-not-false "shy" (hash-ref d (bag "shy")))
    (test-not-false "jo"  (hash-ref d (bag "jo")))
    ))
