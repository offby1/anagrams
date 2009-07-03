;; Stolen from http://okmij.org/ftp/Scheme/assert-syntax-rule.txt

; Frequently-occurring syntax-rule macros

; A symbol? predicate at the macro-expand time
;	symbol?? FORM KT KF
; FORM is an arbitrary form or datum
; expands in KT if FORM is a symbol (identifier), Otherwise, expands in KF

(define-syntax symbol??
  (syntax-rules ()
    ((symbol?? (x . y) kt kf) kf)	; It's a pair, not a symbol
    ((symbol?? #(x ...) kt kf) kf)	; It's a vector, not a symbol
    ((symbol?? maybe-symbol kt kf)
      (let-syntax
	((test
	   (syntax-rules ()
	     ((test maybe-symbol t f) t)
	     ((test x t f) f))))
	(test abracadabra kt kf)))))

; A macro-expand-time memv function for identifiers
;	id-memv?? FORM (ID ...) KT KF
; FORM is an arbitrary form or datum, ID is an identifier.
; The macro expands into KT if FORM is an identifier, which occurs
; in the list of identifiers supplied by the second argument.
; All the identifiers in that list must be unique.
; Otherwise, id-memv?? expands to KF.
; Two identifiers match if both refer to the same binding occurrence, or
; (both are undefined and have the same spelling).

; (id-memv??			; old code.
;   (syntax-rules ()
;     ((_ x () kt kf) kf)
;     ((_ x (y . rest) kt kf)
;       (let-syntax
; 	((test
; 	   (syntax-rules (y)
; 	     ((test y _x _rest _kt _kf) _kt)
; 	     ((test any _x _rest _kt _kf)
; 	       (id-memv?? _x _rest _kt _kf)))))
; 	(test x x rest kt kf)))))


(define-syntax id-memv??
  (syntax-rules ()
    ((id-memv?? form (id ...) kt kf)
      (let-syntax
	((test
	   (syntax-rules (id ...)
	     ((test id _kt _kf) _kt) ...
	     ((test otherwise _kt _kf) _kf))))
	(test form kt kf)))))

; Test cases
; (id-memv?? x (a b c) #t #f)
; (id-memv?? a (a b c) 'OK #f)
; (id-memv?? () (a b c) #t #f)
; (id-memv?? (x ...) (a b c) #t #f)
; (id-memv?? "abc" (a b c) #t #f)
; (id-memv?? x () #t #f)
; (let ((x 1))
;   (id-memv?? x (a b x) 'OK #f))
; (let ((x 1))
;   (id-memv?? x (a x b) 'OK #f))
; (let ((x 1))
;   (id-memv?? x (x a b) 'OK #f))

; Commonly-used CPS macros
; The following macros follow the convention that a continuation argument
; has the form (k-head ! args ...)
; where ! is a dedicated symbol (placeholder).
; When a CPS macro invokes its continuation, it expands into
; (k-head value args ...)
; To distinguish such calling conventions, we prefix the names of
; such macros with k!

(define-syntax k!id			; Just the identity. Useful in CPS
  (syntax-rules ()
    ((k!id x) x)))

; k!reverse ACC (FORM ...) K
; reverses the second argument, appends it to the first and passes
; the result to K

(define-syntax k!reverse
  (syntax-rules (!)
    ((k!reverse acc () (k-head ! . k-args))
      (k-head acc . k-args))
    ((k!reverse acc (x . rest) k)
      (k!reverse (x . acc) rest k))))


; (k!reverse () (1 2 () (4 5)) '!) ;==> '((4 5) () 2 1)
; (k!reverse (x) (1 2 () (4 5)) '!) ;==> '((4 5) () 2 1 x)
; (k!reverse (x) () '!) ;==> '(x)


; assert the truth of an expression (or of a sequence of expressions)
;
; syntax: assert ?expr ?expr ... [report: ?r-exp ?r-exp ...]
;
; If (and ?expr ?expr ...) evaluates to anything but #f, the result
; is the value of that expression.
; If (and ?expr ?expr ...) evaluates to #f, an error is reported.
; The error message will show the failed expressions, as well
; as the values of selected variables (or expressions, in general).
; The user may explicitly specify the expressions whose
; values are to be printed upon assertion failure -- as ?r-exp that
; follow the identifier 'report:'
; Typically, ?r-exp is either a variable or a string constant.
; If the user specified no ?r-exp, the values of variables that are
; referenced in ?expr will be printed upon the assertion failure.


(define-syntax assert
  (syntax-rules ()
    ((assert _expr . _others)
     (letrec-syntax
       ((write-report
	  (syntax-rules ()
			; given the list of expressions or vars,
			; create a cerr form
	    ((_ exprs prologue)
	      (k!reverse () (cerr . prologue)
		(write-report* ! exprs #\newline)))))
	 (write-report*
	   (syntax-rules ()
	     ((_ rev-prologue () prefix)
	       (k!reverse () (nl . rev-prologue) (k!id !)))
	     ((_ rev-prologue (x . rest) prefix)
	       (symbol?? x
		 (write-report* (x ": " 'x #\newline . rev-prologue)
		   rest #\newline)
		 (write-report* (x prefix . rev-prologue) rest "")))))

			; return the list of all unique "interesting"
			; variables in the expr. Variables that are certain
			; to be bound to procedures are not interesting.
	 (vars-of
	   (syntax-rules (!)
	     ((_ vars (op . args) (k-head ! . k-args))
	       (id-memv?? op
		 (quote let let* letrec let*-values lambda cond quasiquote
		   case define do assert)
		 (k-head vars . k-args) ; won't go inside
				; ignore the head of the application
		 (vars-of* vars args (k-head ! . k-args))))
		  ; not an application -- ignore
	     ((_ vars non-app (k-head ! . k-args)) (k-head vars . k-args))
	     ))
	 (vars-of*
	   (syntax-rules (!)
	     ((_ vars () (k-head ! . k-args)) (k-head vars . k-args))
	     ((_ vars (x . rest) k)
	       (symbol?? x
		 (id-memv?? x vars
		   (vars-of* vars rest k)
		   (vars-of* (x . vars) rest k))
		 (vars-of vars x (vars-of* ! rest k))))))

	 (do-assert
	   (syntax-rules (report:)
	     ((_ () expr)			; the most common case
	       (do-assert-c expr))
	     ((_ () expr report: . others) ; another common case
	       (do-assert-c expr others))
	     ((_ () expr . others) (do-assert (expr and) . others))
	     ((_ exprs)
	       (k!reverse () exprs (do-assert-c !)))
	     ((_ exprs report: . others)
	       (k!reverse () exprs (do-assert-c ! others)))
	     ((_ exprs x . others) (do-assert (x . exprs) . others))))

	 (do-assert-c
	   (syntax-rules ()
	     ((_ exprs)
	       (or exprs
		 (begin (vars-of () exprs
			  (write-report !
			    ("failed assertion: " 'exprs nl "bindings")))
		   (error "assertion failure"))))
	     ((_ exprs others)
	       (or exprs
		 (begin (write-report others
			  ("failed assertion: " 'exprs))
		   (error "assertion failure"))))))
	 )
       (do-assert () _expr . _others)
       ))))

(define (cerr . args)
  (for-each (lambda (x)
              (if (procedure? x) (x) (display x)))
    args))

; If there is (current-error-port), uncomment the following
;(define (cerr . args)
;  (for-each (lambda (x)
;              (if (procedure? x) (x (current-error-port))
;		(display x (current-error-port))))
;    args))

(define nl (string #\newline))

