(define-syntax assert
  (syntax-rules ()
    ((assert exp)
     (let ((result exp))
       (if (not result)
           )))))