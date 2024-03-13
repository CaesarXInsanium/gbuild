;; module definition must be on top
(define-module (cbuild))
(use-modules (ice-9 string-fun)
             (ice-9 curried-definitions)
             (srfi srfi-1))

;; empty list
(define NIL '())

(define CC "/usr/bin/gcc")

(define (include-flags include-paths)
  (map (lambda (path) (string-append "-I" path))
       include-paths))

(define (path-exists? path) (access? path R_OK))

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
                                          #:cflags cflags))
         (display (format #f "Compiling ~a ~%" command))
         (apply system* command)
         (object-target source objdir))
         
                            
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
                     (ldflags NIL))
  (link target-name
        (map (lambda (source)
               (compile source 
                        "obj" 
                        CC
                        #:cflags cflags))
             sources)
        CC
        #:ldflags ldflags))
        
(export NIL
        executable)
        
