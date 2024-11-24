(define-module (gbuild compiler))

(define DEFAULT-CC "/usr/bin/gcc")
(define DEFAULT-JAVAC "/usr/bin/javac")
(define-public DEFAULT-CPP "usr/bin/g++")

;; determines is compiler provided exists
(define (compiler-else-default bin-path lang)
  (cond ((eq? 'CC lang)
         (if (file-exists? bin-path)
           bin-path
           DEFAULT-CC))
        ((eq? 'JAVA lang)
         (handle-java-compiler bin-path))
        ((eq? 'NIM lang)
         (handle-nim-compiler bin-path))
        ((eq? 'CPP lang)
         (if (file-exists? bin-path)
           bin-path
           DEFAULT-CPP))))
