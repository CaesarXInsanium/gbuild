#!/usr/bin/env -S guile -e main -s
!#
;; module definition must be on top
(use-modules 
 (ice-9 string-fun)
 (ice-9 curried-definitions)
 (srfi srfi-1)
 (ice-9 ftw)
 (ice-9 local-eval))

;; empty list
(define NIL '())

;; TODO ADD Default Variables
; define method to change this value
(define CC "/usr/bin/gcc")

(define CSTD18 "-std=c18")
(define CWALL "-Wall")
(define CWERROR "-Werror")
(define GGDB "-ggdb")

;; should support relative paths and full paths
(define (include-flags include-paths)
  (map (lambda (path) (string-append "-I" path))
       include-paths))

(define (path-exists? path) (access? path R_OK))

;; takes path to source file and returns new path to object file
(define (object-target source-path objdir)
  (string-append objdir
                 "/"
                 (string-replace-substring source-path "/" "%")
                 ".o"))

;; returns output path
;; compile single file and place into obj directory
(define* (compile-command source
                          objdir
                          compiler
                          #:key
                          (include NIL)
                          (cflags NIL))
         (let* ((obj-target (object-target source objdir)))
          (concatenate (list (list compiler source "-o" obj-target)
                             (include-flags include)
                             cflags)))) 

;; add check to see if there is one source file, and it compiles to a valid
;; executable, 
(define* (compile source
                  objdir
                  compiler
                  #:key
                  (include NIL)
                  (cflags NIL))
         (if (not (access? objdir (logior R_OK F_OK W_OK)))
           (mkdir objdir))
         (define command (compile-command source
                                          objdir
                                          compiler
                                          #:include include
                                          #:cflags (append cflags '("-c"))))
         (display (format #f "Compiling ~a ~%" command))
         (apply system* command)
         (object-target source objdir))
         
                            
;; generate command to run
(define* (link-command target
                       objects
                       linker
                       #:key
                       (ldflags NIL))
         (concatenate (list (list linker) 
                            objects
                            (list "-o" target)
                            ldflags)))

;; generates an executable for now
;; TODO: returns the path to the executable
(define* (link target
               objects
               linker
               #:key
               (ldflags NIL))
         (define command (link-command target
                                      objects
                                      linker
                                      #:ldflags ldflags))
         (display (format #f "Linking ~a ~%" command))
         (apply system* command))
                      

;; add check to see if there is one source
(define* (executable target-name 
                     sources 
                     #:key 
                     (cflags NIL)
                     (ldflags NIL)
                     (include-paths NIL))
  (link target-name
        (map (lambda (source)
               (compile source 
                        "obj" 
                        CC
                        #:cflags cflags
                        #:include include-paths))
             sources)
        CC
        #:ldflags ldflags))

;; get current working directory
;; find a file named build.scm
;; load and evaluate it
;; hopefully return some nice errors if it finds any
;; TODO: check if obj directory exists and is writable

(define (main args)
  (define dir (getcwd))
  (define cbuild "build.scm")
  (define files 
    (scandir dir 
             (lambda (filename) 
               (string=? cbuild filename))))
  (if (null? files)
    (error "cbuild.scm not preset")
    (primitive-load (string-append dir "/" cbuild))))
    

