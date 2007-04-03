(module anagrams
mzscheme
(require "dict.scm"
         "bag.scm"
         "ports.scm"
         (lib "mred.ss" "mred") ;for `yield'
         (lib "defmacro.ss")
         (lib "pretty.ss")
         (prefix srfi-1-  (lib "1.ss"  "srfi")))

(provide all-anagrams)

(define-macro (prog1 expr . rest)
  (let ((e (gensym)))
    `(let ((,e ,expr))
       (begin
         ,@rest)
       ,e)))

(define (all-anagrams string dict-file-name callback)
  (let ((in-bag   (bag string)))
    (init in-bag dict-file-name)
    (fprintf status-port "") ;clears the status window
    (all-anagrams-internal
     in-bag
     *dictionary*
     #t
     callback)))

(define (all-anagrams-internal bag dict top-level? callback)
  (define rv '())
  (let loop ((dict dict))
    (if (null? dict)
        rv
      (let ((key   (caar dict))
            (words (cdar dict)))
        (yield)
        (let ((smaller-bag (subtract-bags bag key)))
          (if smaller-bag
              (if (bag-empty? smaller-bag)
                  (begin
                    (let ((combined (map list words)))
                      (if top-level? (callback combined))
                      (set! rv (append! rv combined))))
                (let ((anagrams (all-anagrams-internal smaller-bag dict #f callback)))
                  (if (not (null? anagrams))
                      (begin
                        (let ((combined (combine words anagrams)))
                          (if top-level? (callback combined))
                          (set! rv (append! rv combined)))))))))

        (loop (cdr dict))))))


(define (combine words anagrams)
  "Given a list of WORDS, and a list of ANAGRAMS, creates a new
list of anagrams, each of which begins with one of the WORDS."
  (apply append (map (lambda (word)
                       (map (lambda (an)
                              (cons word an))
                            anagrams))
                     words)))
)