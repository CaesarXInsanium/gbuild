(use-modules (cbuild))
;; sample work

(define cflags (list "-Wall" "-Werror" "-std=gnu99" "-c"))
;; empty list as no libraries need to be linked with
(define ldflags '())

(define sources (list "hello.c" "header.c"))
(define include-dirs '())

(executable "hello"
            sources
            #:cflags cflags)
