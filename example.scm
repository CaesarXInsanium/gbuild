(use-modules (ice-9 string-fun)
             (ice-9 curried-definitions)
             (srfi srfi-1))

(define (join2 a b)
  (if (nil? a) 
    b 
    (cons (car a) 
          (join2 (cdr a) 
                 b))))

(define (join . a)
  (if (nil? a)
    NIL
    (join2 (car a)
           (apply join (cdr a)))))
  

;; empty list
(define NIL '())

(define CC "/usr/bin/gcc")

(define (include-flags include-paths)
  (map (lambda (path) (string-append "-I" path))
       include-paths))

(define (path-exists? path) (access? path R_OK))

(define (compile-target source-path objdir)
  (string-append objdir
                 "/"
                 (string-replace-substring source-path "/" "%")
                 ".o"))

;; returns output path
;; compile single file and place into obj directory
(define* (compile source 
                  objdir 
                  compiler 
                  #:key 
                  (include NIL) 
                  (cflags NIL))

  (apply system* 
         (join (list CC source "-o" 
                (compile-target source objdir))
               cflags)))

(define* (executable target-name 
                     sources 
                     #:key (cflags NIL)
                     (ldflags NIL))
  (map (lambda (source) 
         (compile source "obj" CC))
       sources))

(define cflags '("-Wall" "-Werror" "-std=c99"))
;; empty list as no libraries need to be linked with
(define ldflags '())

(define sources '("hello.c"))
(define include-dirs '())

(executable "hello"
            sources)
