#! /bin/sh
#| Hey Emacs, this is -*-scheme-*- code!
exec mzscheme -qu "$0" ${1+"$@"}
|#

#lang scheme

(require "dict.scm"
         "bag.scm"
;;;          (only (lib "1.ss"  "srfi") filter find take)
         (lib "etc.ss"))

(provide all-anagrams)

(define (all-anagrams string dict-file-name )
  (let ((in-bag   (bag string)))
    (all-anagrams-internal
     in-bag
     (init in-bag dict-file-name)
     0)))

(define (all-anagrams-internal bag dict level [callback #f])

  (let loop ((rv '())
             (dict dict))

    (if (null? dict)
        rv

      (let* ((key   (caar dict))
             (words (cdar dict))
             (smaller-bag (subtract-bags bag key)))

        (loop
         (if smaller-bag
             (let ((new-stuff
                    (if (bag-empty? smaller-bag)
                        (map list words)
                      (combine
                       words
                       (all-anagrams-internal
                        smaller-bag
                        (filter (lambda (entry)
                                  (subtract-bags
                                   smaller-bag
                                   (car entry)))
                                dict)
                        (add1 level)
                        callback)))))
               (when (and (zero? level)
                          (procedure? callback)
                          (not (null? new-stuff)))
                 (for-each (lambda (w)
                             (callback w))
                           new-stuff))
               (append new-stuff rv))
           rv)
         (cdr dict))))))

(define (combine words anagrams)
  "Given a list of WORDS, and a list of ANAGRAMS, creates a new
list of anagrams, each of which begins with one of the WORDS."
  (apply append (map (lambda (word)
                       (map (lambda (an)
                              (cons word an))
                            anagrams))
                     words)))

(define (length-of-longest words)
  (apply max (map string-length words)))

(let* ((in (vector-ref
            (current-command-line-arguments)
            0))
       (results (all-anagrams
                 in
                 (build-path (this-expression-source-directory) 'up 'up "words")
                 )))
  (fprintf (current-error-port) "~a anagrams of ~s~%" (length results) in)
  (for ([an (in-list (sort results > #:key length-of-longest))])
    (display an)
    (newline)))

