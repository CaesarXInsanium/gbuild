;; module definition must be on top
(define-module (gbuild)
               #:use-module (ice-9 string-fun)
               #:use-module (ice-9 curried-definitions)
               #:use-module (srfi srfi-1)
               #:use-module (ice-9 ftw)
               #:use-module (ice-9 local-eval)
               #:use-module (gbuild files)
               #:use-module (gbuild c cflags)
               #:export (gbuild-main
                          executable))

;; empty list
(define NIL '())

;; TODO ADD Default Variables
; define method to change this value
(define CC "/usr/bin/gcc")
;; TODO add way to search for a compiler


(define (include-flags include-paths)
  (map (lambda (path) 
         (string-append "-I" (canonicalize-path path)))
       include-paths))

;; TODO declare a fuzzy file finder

;; takes path to source file and returns new path to object file
;; TODO check if source file is newer than object, file, compile if so
(define (object-target source-path objdir)
  (string-append objdir
                 "/"
                 (string-replace-substring source-path "/" "%")
                 ".o"))

;; assumes that a and b are valid file paths
;; stat-mtime returns an integer
(define (is-newer? a b)
  (let ((a-mod-time (stat:mtime (stat a)))
        (b-mod-time (stat:mtime (stat b))))
    (> a-mod-time b-mod-time)))

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

;; target is already defined, src/hello.c -> obj/hello.c.o
(define* (compile-to-object source target compiler includes cflags)
         (concatenate (list (list compiler source "-o" target)
                            (include-flags includes)
                            cflags)))
         
;; add check to see if there is one source file, and it compiles to a valid
;; executable, 
(define* (compile source
                  objdir
                  compiler
                  #:key
                  (include NIL)
                  (cflags NIL))
         ;; TODO move this outside
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
                       ldflags)
         (concatenate (list (list linker) 
                            objects
                            (list "-o" target)
                            ldflags)))

;; generates an executable for now
;; TODO: returns the path to the executable
(define (link target
              objects
              linker
              ldflags
         (define command (link-command target
                                      objects
                                      linker
                                      ldflags))
         (display (format #f "Linking ~a ~%" command))
         (apply system* command)))
                      

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
;; TODO figure out what to do if the compilation fails
;; TODO check if obj directory exists and is writable

(define (gbuild-main args)
  (let* ((dir (getcwd))
         (build-scm (string-append dir
                                 "/"
                                 "build.scm")))
    (if (path-exists? build-scm)
      (primitive-load build-scm)
      (gbuild-error-no-build-script))))

