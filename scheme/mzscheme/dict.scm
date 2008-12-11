#! /bin/sh
#| Hey Emacs, this is -*-scheme-*- code!
#$Id: v4-script-template.ss 5748 2008-11-17 01:57:34Z erich $
exec  mzscheme --require "$0" --main -- ${1+"$@"}
|#

#lang scheme
(require (except-in "bag.scm" main))
(require (planet schematics/schemeunit:3)
         (planet schematics/schemeunit:3/text-ui))

(provide init)

;; Takes either a file name, or an input port.  This makes testing easier.
(define wordlist->hash
  (match-lambda

   [(? string? inp)
    (wordlist->hash (build-path inp))]

   [(? path? inp)
    (fprintf (current-error-port) "Reading dictionary ~s ... " inp)

    (let ((dict (call-with-input-file inp wordlist->hash)))

      (fprintf (current-error-port) "done; ~s words, ~a distinct bags~%"
               (length (apply append (map cdr (hash-map dict cons))))
               (hash-count dict))
      dict)]

   [(? input-port? inp)
    (for/fold ([dict (make-immutable-hash '())])
        ([word (in-lines inp)])
        (let ((word (string-downcase word)))
          (if (word-acceptable? word)
              (adjoin-word dict word)
              dict)))]))

(define (adjoin-word dict word)
  (let ((bag (bag word)))

    (hash-update dict bag
                 (lambda (old)
                            (cons word old))
                 '())))

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
                        (hash-map (wordlist->hash dict-file-name) cons))))
    (fprintf
     (current-error-port)
     "Pruned dictionary now has ~a words~%"
     (apply + (map (lambda (seq)
                     (length (cdr seq)))
                   result)))
    result)

  )

(provide main)
(define (main . args)
  (exit
   (run-tests
    (test-suite
     "yow"
     (test-begin
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
          (check-equal? probe (cons (bag "plonk") (list "plonk"))))))
     (test-begin
      (let ((d (wordlist->hash (open-input-string "god\ncat\ndog\n"))))
        (printf "~s~%" d)
        (check-equal? 2 (hash-count d)))))
    )))
