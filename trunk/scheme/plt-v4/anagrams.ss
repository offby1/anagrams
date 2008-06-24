#!/usr/bin/env mzscheme

#lang scheme

(require "bag.ss"
         "dict.ss"
         (lib "1.ss" "srfi")
         (lib "etc.ss")
         )

(provide all-anagrams)

(define (all-anagrams string dict-file-name )
  (let ((in-bag   (bag string)))
    (all-anagrams-internal
     in-bag
     (dict-init in-bag dict-file-name))))

(define (all-anagrams-internal bag dict)
  (pair-fold
   (lambda (dict accum)
     (let* ((key   (caar dict))
            (words (cdar dict))
            (smaller-bag (subtract-bags bag key)))

       (cond
        ((not smaller-bag)
         accum)
        ((bag-empty? smaller-bag)
         (append (map list words) accum))
        (else
         (append
          (combine
           words
           (all-anagrams-internal
            smaller-bag
            (filter (lambda (entry)
                      (subtract-bags
                       smaller-bag
                       (car entry)))
                    dict)))
          accum)))))

   '()
   dict))

(define (combine words anagrams)
  "Given a list of WORDS, and a list of ANAGRAMS, creates a new
list of anagrams, each of which begins with one of the WORDS."
  (append-map (lambda (word)
                (map (lambda (an)
                       (cons word an))
                     anagrams))
              words))

(let ((in (vector-ref
           (current-command-line-arguments)
           0)))
  (let ((result
         (all-anagrams
          in
          (build-path (this-expression-source-directory) 'up 'up "words")
          )))
    (fprintf (current-error-port) "~a anagrams of ~s~%" (length result) in)
    (newline)
    (call-with-output-file
        in
      #:exists 'truncate/replace
      (lambda (op)
        (for ((anagram (in-list result)))
          (display anagram op)
          (newline op))))))

