;; see also http://okmij.org/ftp/Scheme/assert-syntax-rule.txt,
;; although I can't figure out how to get it to work in Guile

(define-module (assert)
  #:export (assert))

(define-syntax assert
  (syntax-rules ()
    ((assert _expr)
     (or _expr
         (error "failed assertion: " '_expr)))))
