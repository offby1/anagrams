(module ports
    mzscheme
  (provide output-port
           set-output-port!
           status-port
           set-status-port!)
  (define output-port (current-output-port))
  (define (set-output-port! p) (set! output-port p))
  (define status-port (current-error-port))
  (define (set-status-port! p) (set! status-port p))
  )