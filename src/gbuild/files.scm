(define-module (gbuild files)
               #:export (path-exists?))

;; TODO unused
(define (path-exists? path) (access? path R_OK))
