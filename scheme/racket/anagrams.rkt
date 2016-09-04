#! /usr/bin/env racket

#lang racket

(require "dict.rkt"
         "bag.rkt"
         "sequences.rkt"
         (lib "etc.ss"))

(provide all-anagrams)

(define (all-anagrams string dict-file-name )
  (let ((in-bag   (bag string)))
    (all-anagrams-internal
     in-bag
     (init in-bag dict-file-name))))

(define (all-anagrams-internal bag dict)

  (for/fold ([rv '()])
      ([(elt dict) (in-cdrs dict)])
      (let ((words (cdr elt))
            (smaller-bag (subtract-bags bag (car elt))))

        (append
         (cond
          ((not smaller-bag)
           '())
          ((bag-empty? smaller-bag)
           (map list words))
          (else
           (combine
            words
            (all-anagrams-internal
             smaller-bag
             (filter (lambda (entry)
                       (subtract-bags
                        smaller-bag
                        (car entry)))
                     dict)))))
         rv))))

(define (combine words anagrams)
  "Given a list of WORDS, and a list of ANAGRAMS, creates a new
list of anagrams, each of which begins with one of the WORDS."
  (apply append (map (lambda (word)
                       (map (lambda (an)
                              (cons word an))
                            anagrams))
                     words)))


(module+ main
  (let* ((in (apply string-append (command-line #:args str str)))
         (results (all-anagrams
                   in
                   (build-path (this-expression-source-directory) 'up 'up "words.utf8")
                   )))
    (fprintf (current-error-port) "~a anagrams of ~s~%" (length results) in)

    (when #t
      (for ([an (in-list (sort results > #:key length))])
        (display an)
        (newline)))
    ))
