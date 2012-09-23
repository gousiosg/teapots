(module
  tri
  (library srfi1)
  (export
    string->point
    tri->svg
    decompose
    trisort
    normalize
    random-color
    tri->div
    translate
    normalizes
    coord-x
    coord-y
    min-x
    min-y
    min-xs
    min-ys))
(define _eqv?_17 eqv?)
(define _cons_31 cons)
(define _append_32 append)
(define _list_33 list)
(define _vector_34 vector)
(define _list->vector_35 list->vector)
(define _map_36 map)
(define
  match-failure
  (lambda
    (val)
    (error 'match-failure "failed match" val)))
(define
  curry
  (lambda
    (f . args)
    (lambda x (apply f (append args x)))))
(define
  rcurry
  (lambda
    (f . args)
    (lambda x (apply f (append x args)))))
(define value (lambda (x) x))
(define ref-list (lambda (k l) (list-ref l k)))
(define
  ref-struct
  (lambda (k s) (struct-ref s k)))
(define
  ref-vector
  (lambda (k v) (vector-ref v k)))
(define
  ref-string
  (lambda (k s) (string-ref s k)))
(define
  ref-ucs2-string
  (lambda (k s) (ucs2-string-ref s k)))
(define
  ref-utf8-string
  (lambda (k s) (utf8-string-ref s k)))
(define
  is-struct?
  (lambda
    (t s)
    (cond-expand
      (bigloo
        (if (struct? s)
            ((lambda
               (sk)
               ((lambda
                  (st)
                  ((lambda
                     (lt)
                     ((lambda
                        (ts)
                        ((lambda
                           (ls)
                           ((lambda
                              (x)
                              (if x
                                  x
                                  (begin (if (if (string-prefix? "<" st)
                                                 (string-suffix? ">" st)
                                                 #f)
                                             (set! st
                                                   (substring st 1 (- lt 1))))
                                         (if (if (string-prefix? "<" ts)
                                                 (string-suffix? ">" ts)
                                                 #f)
                                             (set! ts
                                                   (substring ts 1 (- ls 1))))
                                         (string=? ts st))))
                            (eq? t sk)))
                         (string-length ts)))
                      (symbol->string t)))
                   (string-length st)))
                (symbol->string sk)))
             (struct-key s))
            #f))
      (else (error 'is-struct
                   "unsupported"
                   "on this platform")))))
'(define-syntax
   debug
   (syntax-rules
     ()
     ((_)
      (begin (display "MARK: ")
             (display (gensym))
             (newline)))
     ((_ term)
      (begin (display `term) (display ": ") (pp term)))
     ((_ term rest |...|)
      (begin (debug term) (debug rest |...|)))))
(define +1+ (lambda x (apply + (cons 1 x))))
(define +2+ (lambda x (apply + (cons 2 x))))
(define +3+ (lambda x (apply + (cons 3 x))))
(define -1+ (lambda x (apply + (cons -1 x))))
(define -2+ (lambda x (apply + (cons -2 x))))
(define -3+ (lambda x (apply + (cons -3 x))))
(define +1- (lambda x (apply - (cons 1 x))))
(define +2- (lambda x (apply - (cons 2 x))))
(define +3- (lambda x (apply - (cons 3 x))))
(define -1- (lambda x (apply - (cons -1 x))))
(define -2- (lambda x (apply - (cons -2 x))))
(define -3- (lambda x (apply - (cons -3 x))))
(define +2* (lambda x (apply * (cons 2 x))))
(define +3* (lambda x (apply * (cons 3 x))))
(define -2* (lambda x (apply * (cons -2 x))))
(define -3* (lambda x (apply * (cons -3 x))))
(define +2/ (lambda x (apply / (cons 2 x))))
(define +3/ (lambda x (apply / (cons 3 x))))
(define -2/ (lambda x (apply / (cons -2 x))))
(define -3/ (lambda x (apply / (cons -3 x))))
(define
  /+2
  (lambda x (apply / (append x (list 2)))))
(define
  /+3
  (lambda x (apply / (append x (list 3)))))
(define
  /-2
  (lambda x (apply / (append x (list -2)))))
(define
  /-3
  (lambda x (apply / (append x (list -3 x)))))
(define sqr (lambda (x) (* x x)))
(define |˖| +)
(define |˗| -)
(define |×| *)
(define |÷| /)
(set-sharp-read-syntax! '|π/4| (atan 1))
(set-sharp-read-syntax!
  '|π/2|
  (* 2 0.7853981633974483))
(set-sharp-read-syntax!
  '|π|
  (* 2 1.5707963267948966))
(set-sharp-read-syntax! 'e (exp 1))
(define box list)
(define unbox car)
(define set-box! set-car!)
(define cat string-append)
(define nl "\n")
(define tab "t")
(define empty "")
(define
  empty?
  (lambda
    (x)
    (if (string? x) (string=? x empty) #f)))
(define ac (lambda (x y) (if (empty? x) y x)))
(define dc (lambda (x y) (if (empty? x) x y)))
(define
  |out'|
  (lambda
    (head tail separator)
    (lambda
      l
      (begin ((lambda
                (first cr)
                (for-each
                  (lambda
                    (x)
                    (begin (if first
                               (if (not (empty? x)) (display head) #f)
                               #f)
                           ((lambda
                              (_x_63)
                              (if _x_63
                                  _x_63
                                  ((lambda
                                     (x)
                                     (if x
                                         x
                                         ((lambda
                                            (x)
                                            (if x x (display separator)))
                                          cr)))
                                   (empty? x))))
                            first)
                           ((lambda
                              (_x_63)
                              (if _x_63
                                  _x_63
                                  (begin (display x)
                                         (set! first #f)
                                         (set! cr
                                               (if (string? x)
                                                   (string-suffix? "\n" x)
                                                   #f)))))
                            (empty? x))))
                  l))
              #t
              #t)
             (display tail)))))
(define out (|out'| "" #\newline #\space))
(define ou (|out'| "" #\newline ""))
(define
  out-seq
  (lambda (l) (apply (|out'| "" "" " ") l)))
(define
  out-list
  (lambda (l) (apply (|out'| "" "" "; ") l)))
(define
  out-list-pref
  (lambda (p l) (apply (|out'| p "" "; ") l)))
(define
  wout
  (lambda
    args
    (begin (map display args) (newline))))
(define
  foldl
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (null? vals)
                   (lambda args (matcher args))
                   (if (pair? vals)
                       ((lambda
                          (valx valy)
                          ((lambda
                             (f)
                             (if (null? valy)
                                 (lambda args (matcher (append (list f) args)))
                                 (if (pair? valy)
                                     ((lambda
                                        (valx valy)
                                        ((lambda
                                           (r)
                                           (if (null? valy)
                                               (lambda
                                                 args
                                                 (matcher
                                                   (append (list f r) args)))
                                               (if (pair? valy)
                                                   ((lambda
                                                      (valx valy)
                                                      (if (null? valx)
                                                          ((lambda
                                                             (exp)
                                                             (if (null? valy)
                                                                 exp
                                                                 (apply exp
                                                                        valy)))
                                                           r)
                                                          (fail 'continue)))
                                                    (car valy)
                                                    (cdr valy))
                                                   (fail 'pair-expected))))
                                         valx))
                                      (car valy)
                                      (cdr valy))
                                     (fail 'pair-expected))))
                           valx))
                        (car vals)
                        (cdr vals))
                       (fail 'pair-expected))))
             (lambda
               (___)
               ((lambda
                  (fail)
                  (if (null? vals)
                      (lambda args (matcher args))
                      (if (pair? vals)
                          ((lambda
                             (valx valy)
                             ((lambda
                                (f)
                                (if (null? valy)
                                    (lambda
                                      args
                                      (matcher (append (list f) args)))
                                    (if (pair? valy)
                                        ((lambda
                                           (valx valy)
                                           ((lambda
                                              (r)
                                              (if (null? valy)
                                                  (lambda
                                                    args
                                                    (matcher
                                                      (append (list f r) args)))
                                                  (if (pair? valy)
                                                      ((lambda
                                                         (valx valy)
                                                         (if (pair? valx)
                                                             ((lambda
                                                                (valx _valy_84)
                                                                ((lambda
                                                                   (x)
                                                                   ((lambda
                                                                      (xs)
                                                                      ((lambda
                                                                         (exp)
                                                                         (if (null? valy)
                                                                             exp
                                                                             (apply exp
                                                                                    valy)))
                                                                       (foldl f
                                                                              (f r
                                                                                 x)
                                                                              xs)))
                                                                    _valy_84))
                                                                 valx))
                                                              (car valx)
                                                              (cdr valx))
                                                             (fail 'continue)))
                                                       (car valy)
                                                       (cdr valy))
                                                      (fail 'pair-expected))))
                                            valx))
                                         (car valy)
                                         (cdr valy))
                                        (fail 'pair-expected))))
                              valx))
                           (car vals)
                           (cdr vals))
                          (fail 'pair-expected))))
                (lambda
                  (___)
                  (match-failure (_list_33 'autocurry vals)))))))))
       matcher)
     args)))
(define
  foldr
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (null? vals)
                   (lambda args (matcher args))
                   (if (pair? vals)
                       ((lambda
                          (valx valy)
                          ((lambda
                             (f)
                             (if (null? valy)
                                 (lambda args (matcher (append (list f) args)))
                                 (if (pair? valy)
                                     ((lambda
                                        (valx valy)
                                        ((lambda
                                           (r)
                                           (if (null? valy)
                                               (lambda
                                                 args
                                                 (matcher
                                                   (append (list f r) args)))
                                               (if (pair? valy)
                                                   ((lambda
                                                      (valx valy)
                                                      (if (null? valx)
                                                          ((lambda
                                                             (exp)
                                                             (if (null? valy)
                                                                 exp
                                                                 (apply exp
                                                                        valy)))
                                                           r)
                                                          (fail 'continue)))
                                                    (car valy)
                                                    (cdr valy))
                                                   (fail 'pair-expected))))
                                         valx))
                                      (car valy)
                                      (cdr valy))
                                     (fail 'pair-expected))))
                           valx))
                        (car vals)
                        (cdr vals))
                       (fail 'pair-expected))))
             (lambda
               (___)
               ((lambda
                  (fail)
                  (if (null? vals)
                      (lambda args (matcher args))
                      (if (pair? vals)
                          ((lambda
                             (valx valy)
                             ((lambda
                                (f)
                                (if (null? valy)
                                    (lambda
                                      args
                                      (matcher (append (list f) args)))
                                    (if (pair? valy)
                                        ((lambda
                                           (valx valy)
                                           ((lambda
                                              (r)
                                              (if (null? valy)
                                                  (lambda
                                                    args
                                                    (matcher
                                                      (append (list f r) args)))
                                                  (if (pair? valy)
                                                      ((lambda
                                                         (valx valy)
                                                         (if (pair? valx)
                                                             ((lambda
                                                                (valx _valy_84)
                                                                ((lambda
                                                                   (x)
                                                                   ((lambda
                                                                      (xs)
                                                                      ((lambda
                                                                         (exp)
                                                                         (if (null? valy)
                                                                             exp
                                                                             (apply exp
                                                                                    valy)))
                                                                       (f x
                                                                          (foldr f
                                                                                 r
                                                                                 xs))))
                                                                    _valy_84))
                                                                 valx))
                                                              (car valx)
                                                              (cdr valx))
                                                             (fail 'continue)))
                                                       (car valy)
                                                       (cdr valy))
                                                      (fail 'pair-expected))))
                                            valx))
                                         (car valy)
                                         (cdr valy))
                                        (fail 'pair-expected))))
                              valx))
                           (car vals)
                           (cdr vals))
                          (fail 'pair-expected))))
                (lambda
                  (___)
                  (match-failure (_list_33 'autocurry vals)))))))))
       matcher)
     args)))
(define
  zip-with
  (lambda
    (c)
    (lambda
      (list1 . more-lists)
      (apply map c list1 more-lists))))
(define
  insert
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (null? vals)
                   (lambda args (matcher args))
                   (if (pair? vals)
                       ((lambda
                          (valx valy)
                          ((lambda
                             (x)
                             (if (null? valy)
                                 (lambda args (matcher (append (list x) args)))
                                 (if (pair? valy)
                                     ((lambda
                                        (valx valy)
                                        (if (pair? valx)
                                            ((lambda
                                               (valx _valy_77)
                                               (if (null? valx)
                                                   (if (null? _valy_77)
                                                       ((lambda
                                                          (exp)
                                                          (if (null? valy)
                                                              exp
                                                              (apply exp valy)))
                                                        x)
                                                       (fail 'continue))
                                                   (fail 'continue)))
                                             (car valx)
                                             (cdr valx))
                                            (fail 'continue)))
                                      (car valy)
                                      (cdr valy))
                                     (fail 'pair-expected))))
                           valx))
                        (car vals)
                        (cdr vals))
                       (fail 'pair-expected))))
             (lambda
               (___)
               ((lambda
                  (fail)
                  (if (null? vals)
                      (lambda args (matcher args))
                      (if (pair? vals)
                          ((lambda
                             (valx valy)
                             ((lambda
                                (x)
                                (if (null? valy)
                                    (lambda
                                      args
                                      (matcher (append (list x) args)))
                                    (if (pair? valy)
                                        ((lambda
                                           (valx valy)
                                           (if (pair? valx)
                                               ((lambda
                                                  (valx _valy_78)
                                                  ((lambda
                                                     (h)
                                                     ((lambda
                                                        (t)
                                                        ((lambda
                                                           (exp)
                                                           (if (null? valy)
                                                               exp
                                                               (apply exp
                                                                      valy)))
                                                         (cons (insert x h)
                                                               (insert x t))))
                                                      _valy_78))
                                                   valx))
                                                (car valx)
                                                (cdr valx))
                                               (fail 'continue)))
                                         (car valy)
                                         (cdr valy))
                                        (fail 'pair-expected))))
                              valx))
                           (car vals)
                           (cdr vals))
                          (fail 'pair-expected))))
                (lambda
                  (___)
                  ((lambda
                     (fail)
                     (if (null? vals)
                         (lambda args (matcher args))
                         (if (pair? vals)
                             ((lambda
                                (valx valy)
                                ((lambda
                                   (x)
                                   (if (null? valy)
                                       (lambda
                                         args
                                         (matcher (append (list x) args)))
                                       (if (pair? valy)
                                           ((lambda
                                              (valx valy)
                                              ((lambda
                                                 (y)
                                                 ((lambda
                                                    (exp)
                                                    (if (null? valy)
                                                        exp
                                                        (apply exp valy)))
                                                  y))
                                               valx))
                                            (car valy)
                                            (cdr valy))
                                           (fail 'pair-expected))))
                                 valx))
                              (car vals)
                              (cdr vals))
                             (fail 'pair-expected))))
                   (lambda
                     (___)
                     (match-failure (_list_33 'autocurry vals)))))))))))
       matcher)
     args)))
(define
  flatten0
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (null? vals)
                   (lambda args (matcher args))
                   (if (pair? vals)
                       ((lambda
                          (valx valy)
                          ((lambda
                             (x)
                             (if (null? valy)
                                 (lambda args (matcher (append (list x) args)))
                                 (if (pair? valy)
                                     ((lambda
                                        (valx valy)
                                        (if (null? valx)
                                            ((lambda
                                               (exp)
                                               (if (null? valy)
                                                   exp
                                                   (apply exp valy)))
                                             x)
                                            (fail 'continue)))
                                      (car valy)
                                      (cdr valy))
                                     (fail 'pair-expected))))
                           valx))
                        (car vals)
                        (cdr vals))
                       (fail 'pair-expected))))
             (lambda
               (___)
               ((lambda
                  (fail)
                  (if (null? vals)
                      (lambda args (matcher args))
                      (if (pair? vals)
                          ((lambda
                             (valx valy)
                             ((lambda
                                (x)
                                (if (null? valy)
                                    (lambda
                                      args
                                      (matcher (append (list x) args)))
                                    (if (pair? valy)
                                        ((lambda
                                           (valx valy)
                                           (if (pair? valx)
                                               ((lambda
                                                  (valx _valy_78)
                                                  ((lambda
                                                     (l)
                                                     ((lambda
                                                        (r)
                                                        ((lambda
                                                           (exp)
                                                           (if (null? valy)
                                                               exp
                                                               (apply exp
                                                                      valy)))
                                                         (flatten0
                                                           (append
                                                             x
                                                             (flatten0 '() l))
                                                           r)))
                                                      _valy_78))
                                                   valx))
                                                (car valx)
                                                (cdr valx))
                                               (fail 'continue)))
                                         (car valy)
                                         (cdr valy))
                                        (fail 'pair-expected))))
                              valx))
                           (car vals)
                           (cdr vals))
                          (fail 'pair-expected))))
                (lambda
                  (___)
                  ((lambda
                     (fail)
                     (if (null? vals)
                         (lambda args (matcher args))
                         (if (pair? vals)
                             ((lambda
                                (valx valy)
                                ((lambda
                                   (x)
                                   (if (null? valy)
                                       (lambda
                                         args
                                         (matcher (append (list x) args)))
                                       (if (pair? valy)
                                           ((lambda
                                              (valx valy)
                                              ((lambda
                                                 (y)
                                                 ((lambda
                                                    (exp)
                                                    (if (null? valy)
                                                        exp
                                                        (apply exp valy)))
                                                  (cons y x)))
                                               valx))
                                            (car valy)
                                            (cdr valy))
                                           (fail 'pair-expected))))
                                 valx))
                              (car vals)
                              (cdr vals))
                             (fail 'pair-expected))))
                   (lambda
                     (___)
                     (match-failure (_list_33 'autocurry vals)))))))))))
       matcher)
     args)))
(define flatten (flatten0 '()))
(define
  intersect0
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (null? vals)
                   (lambda args (matcher args))
                   (if (pair? vals)
                       ((lambda
                          (valx valy)
                          ((lambda
                             (x)
                             (if (null? valy)
                                 (lambda args (matcher (append (list x) args)))
                                 (if (pair? valy)
                                     ((lambda
                                        (valx valy)
                                        ((lambda
                                           (s)
                                           (if (null? valy)
                                               (lambda
                                                 args
                                                 (matcher
                                                   (append (list x s) args)))
                                               (if (pair? valy)
                                                   ((lambda
                                                      (valx valy)
                                                      (if (null? valx)
                                                          ((lambda
                                                             (exp)
                                                             (if (null? valy)
                                                                 exp
                                                                 (apply exp
                                                                        valy)))
                                                           x)
                                                          (fail 'continue)))
                                                    (car valy)
                                                    (cdr valy))
                                                   (fail 'pair-expected))))
                                         valx))
                                      (car valy)
                                      (cdr valy))
                                     (fail 'pair-expected))))
                           valx))
                        (car vals)
                        (cdr vals))
                       (fail 'pair-expected))))
             (lambda
               (___)
               ((lambda
                  (fail)
                  (if (null? vals)
                      (lambda args (matcher args))
                      (if (pair? vals)
                          ((lambda
                             (valx valy)
                             ((lambda
                                (x)
                                (if (null? valy)
                                    (lambda
                                      args
                                      (matcher (append (list x) args)))
                                    (if (pair? valy)
                                        ((lambda
                                           (valx valy)
                                           (if (pair? valx)
                                               ((lambda
                                                  (valx _valy_78)
                                                  ((lambda
                                                     (s)
                                                     ((lambda
                                                        (ss)
                                                        (if (null? valy)
                                                            (lambda
                                                              args
                                                              (matcher
                                                                (append
                                                                  (list x ss)
                                                                  args)))
                                                            (if (pair? valy)
                                                                ((lambda
                                                                   (valx valy)
                                                                   ((lambda
                                                                      (t)
                                                                      ((lambda
                                                                         (exp)
                                                                         (if (null? valy)
                                                                             exp
                                                                             (apply exp
                                                                                    valy)))
                                                                       (intersect0
                                                                         (append
                                                                           x
                                                                           (intersect0
                                                                             '()
                                                                             ss
                                                                             t))
                                                                         s
                                                                         t)))
                                                                    valx))
                                                                 (car valy)
                                                                 (cdr valy))
                                                                (fail 'pair-expected))))
                                                      _valy_78))
                                                   valx))
                                                (car valx)
                                                (cdr valx))
                                               (fail 'continue)))
                                         (car valy)
                                         (cdr valy))
                                        (fail 'pair-expected))))
                              valx))
                           (car vals)
                           (cdr vals))
                          (fail 'pair-expected))))
                (lambda
                  (___)
                  ((lambda
                     (fail)
                     (if (null? vals)
                         (lambda args (matcher args))
                         (if (pair? vals)
                             ((lambda
                                (valx valy)
                                ((lambda
                                   (x)
                                   (if (null? valy)
                                       (lambda
                                         args
                                         (matcher (append (list x) args)))
                                       (if (pair? valy)
                                           ((lambda
                                              (valx valy)
                                              ((lambda
                                                 (s)
                                                 (if (null? valy)
                                                     (lambda
                                                       args
                                                       (matcher
                                                         (append
                                                           (list x s)
                                                           args)))
                                                     (if (pair? valy)
                                                         ((lambda
                                                            (valx valy)
                                                            (if (pair? valx)
                                                                ((lambda
                                                                   (valx _valy_85)
                                                                   ((lambda
                                                                      (l)
                                                                      ((lambda
                                                                         (r)
                                                                         ((lambda
                                                                            (exp)
                                                                            (if (null? valy)
                                                                                exp
                                                                                (apply exp
                                                                                       valy)))
                                                                          (intersect0
                                                                            (append
                                                                              x
                                                                              (intersect0
                                                                                '()
                                                                                s
                                                                                l))
                                                                            s
                                                                            r)))
                                                                       _valy_85))
                                                                    valx))
                                                                 (car valx)
                                                                 (cdr valx))
                                                                (fail 'continue)))
                                                          (car valy)
                                                          (cdr valy))
                                                         (fail 'pair-expected))))
                                               valx))
                                            (car valy)
                                            (cdr valy))
                                           (fail 'pair-expected))))
                                 valx))
                              (car vals)
                              (cdr vals))
                             (fail 'pair-expected))))
                   (lambda
                     (___)
                     ((lambda
                        (fail)
                        (if (null? vals)
                            (lambda args (matcher args))
                            (if (pair? vals)
                                ((lambda
                                   (valx valy)
                                   ((lambda
                                      (x)
                                      (if (null? valy)
                                          (lambda
                                            args
                                            (matcher (append (list x) args)))
                                          (if (pair? valy)
                                              ((lambda
                                                 (valx valy)
                                                 ((lambda
                                                    (s)
                                                    (if (null? valy)
                                                        (lambda
                                                          args
                                                          (matcher
                                                            (append
                                                              (list x s)
                                                              args)))
                                                        (if (pair? valy)
                                                            ((lambda
                                                               (valx valy)
                                                               (if (equal?
                                                                     s
                                                                     valx)
                                                                   ((lambda
                                                                      (exp)
                                                                      (if (null? valy)
                                                                          exp
                                                                          (apply exp
                                                                                 valy)))
                                                                    (cons s x))
                                                                   (fail 'continue)))
                                                             (car valy)
                                                             (cdr valy))
                                                            (fail 'pair-expected))))
                                                  valx))
                                               (car valy)
                                               (cdr valy))
                                              (fail 'pair-expected))))
                                    valx))
                                 (car vals)
                                 (cdr vals))
                                (fail 'pair-expected))))
                      (lambda
                        (___)
                        ((lambda
                           (fail)
                           (if (null? vals)
                               (lambda args (matcher args))
                               (if (pair? vals)
                                   ((lambda
                                      (valx valy)
                                      ((lambda
                                         (x)
                                         (if (null? valy)
                                             (lambda
                                               args
                                               (matcher (append (list x) args)))
                                             (if (pair? valy)
                                                 ((lambda
                                                    (valx valy)
                                                    ((lambda
                                                       (s)
                                                       (if (null? valy)
                                                           (lambda
                                                             args
                                                             (matcher
                                                               (append
                                                                 (list x s)
                                                                 args)))
                                                           (if (pair? valy)
                                                               ((lambda
                                                                  (valx valy)
                                                                  ((lambda
                                                                     (exp)
                                                                     (if (null? valy)
                                                                         exp
                                                                         (apply exp
                                                                                valy)))
                                                                   '()))
                                                                (car valy)
                                                                (cdr valy))
                                                               (fail 'pair-expected))))
                                                     valx))
                                                  (car valy)
                                                  (cdr valy))
                                                 (fail 'pair-expected))))
                                       valx))
                                    (car vals)
                                    (cdr vals))
                                   (fail 'pair-expected))))
                         (lambda
                           (___)
                           (match-failure
                             (_list_33 'autocurry vals)))))))))))))))
       matcher)
     args)))
(define intersect (intersect0 '()))
(define
  occurs?
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (null? vals)
                   (lambda args (matcher args))
                   (if (pair? vals)
                       ((lambda
                          (valx valy)
                          ((lambda
                             (s)
                             (if (null? valy)
                                 (lambda args (matcher (append (list s) args)))
                                 (if (pair? valy)
                                     ((lambda
                                        (valx valy)
                                        (if (pair? valx)
                                            ((lambda
                                               (valx _valy_77)
                                               ((lambda
                                                  (l)
                                                  ((lambda
                                                     (r)
                                                     ((lambda
                                                        (exp)
                                                        (if (null? valy)
                                                            exp
                                                            (apply exp valy)))
                                                      ((lambda
                                                         (x)
                                                         (if x x (occurs? s r)))
                                                       (occurs? s l))))
                                                   _valy_77))
                                                valx))
                                             (car valx)
                                             (cdr valx))
                                            (fail 'continue)))
                                      (car valy)
                                      (cdr valy))
                                     (fail 'pair-expected))))
                           valx))
                        (car vals)
                        (cdr vals))
                       (fail 'pair-expected))))
             (lambda
               (___)
               ((lambda
                  (fail)
                  (if (null? vals)
                      (lambda args (matcher args))
                      (if (pair? vals)
                          ((lambda
                             (valx valy)
                             ((lambda
                                (s)
                                (if (null? valy)
                                    (lambda
                                      args
                                      (matcher (append (list s) args)))
                                    (if (pair? valy)
                                        ((lambda
                                           (valx valy)
                                           (if (equal? s valx)
                                               ((lambda
                                                  (exp)
                                                  (if (null? valy)
                                                      exp
                                                      (apply exp valy)))
                                                #t)
                                               (fail 'continue)))
                                         (car valy)
                                         (cdr valy))
                                        (fail 'pair-expected))))
                              valx))
                           (car vals)
                           (cdr vals))
                          (fail 'pair-expected))))
                (lambda (___) #f)))))))
       matcher)
     args)))
(define
  any-occurs?
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (null? vals)
                   (lambda args (matcher args))
                   (if (pair? vals)
                       ((lambda
                          (valx valy)
                          (if (null? valx)
                              (if (null? valy)
                                  (lambda args (matcher args))
                                  (if (pair? valy)
                                      ((lambda
                                         (valx valy)
                                         ((lambda
                                            (exp)
                                            (if (null? valy)
                                                exp
                                                (apply exp valy)))
                                          #f))
                                       (car valy)
                                       (cdr valy))
                                      (fail 'pair-expected)))
                              (fail 'continue)))
                        (car vals)
                        (cdr vals))
                       (fail 'pair-expected))))
             (lambda
               (___)
               ((lambda
                  (fail)
                  (if (null? vals)
                      (lambda args (matcher args))
                      (if (pair? vals)
                          ((lambda
                             (valx valy)
                             (if (pair? valx)
                                 ((lambda
                                    (valx _valy_73)
                                    ((lambda
                                       (l)
                                       ((lambda
                                          (r)
                                          (if (null? valy)
                                              (lambda
                                                args
                                                (matcher
                                                  (append (list r) args)))
                                              (if (pair? valy)
                                                  ((lambda
                                                     (valx valy)
                                                     ((lambda
                                                        (s)
                                                        ((lambda
                                                           (exp)
                                                           (if (null? valy)
                                                               exp
                                                               (apply exp
                                                                      valy)))
                                                         ((lambda
                                                            (x)
                                                            (if x
                                                                x
                                                                (any-occurs?
                                                                  r
                                                                  s)))
                                                          (occurs? l s))))
                                                      valx))
                                                   (car valy)
                                                   (cdr valy))
                                                  (fail 'pair-expected))))
                                        _valy_73))
                                     valx))
                                  (car valx)
                                  (cdr valx))
                                 (fail 'continue)))
                           (car vals)
                           (cdr vals))
                          (fail 'pair-expected))))
                (lambda
                  (___)
                  (match-failure (_list_33 'autocurry vals)))))))))
       matcher)
     args)))
(define identity (lambda (x) x))
(define
  compose2
  (lambda (f g) (lambda x (f (apply g x)))))
(define
  compose
  (lambda
    fs
    (letrec
      ((helper
         (lambda
           (r fs)
           (if (pair? fs)
               (helper (compose2 r (car fs)) (cdr fs))
               r))))
      (helper (car fs) (cdr fs)))))
(define
  filter-map-splice
  (lambda
    (p l)
    (labels
      ((filter-map-splice-helper
         (l res)
         (if (null? l)
             res
             (if (pair? l)
                 ((letrec
                    ((loop (lambda
                             (v r)
                             (if ((lambda (x) (if x x (null? v))) (not v))
                                 (filter-map-splice-helper (cdr l) r)
                                 (if (pair? v)
                                     (loop (cdr v)
                                           (append r (_list_33 (car v))))
                                     (loop '() (append r (_list_33 v))))))))
                    loop)
                  (p (car l))
                  res)
                 (error "filter-map-splice" "unexpected object" l)))))
      (filter-map-splice-helper l '()))))
(define
  |assq'|
  (lambda
    (t l . acc)
    (if (pair? l)
        ((lambda
           (p)
           (if (pair? p)
               ((lambda
                  (h)
                  (if (eq? h t)
                      (values (if (null? acc) identity (car acc)) l p)
                      (|assq'|
                        t
                        (cdr l)
                        (lambda
                          (x)
                          (cdr (if (null? acc) x ((car acc) x)))))))
                (car p))
               #f))
         (car l))
        #f)))
(define
  |partition'|
  (lambda
    (p ls)
    (letrec
      ((rec (lambda
              (as bs ls)
              (if (null? ls)
                  (values as bs)
                  ((lambda
                     (v r)
                     (if (p v)
                         (rec (append as (list v)) bs r)
                         (rec as (append bs (list v)) r)))
                   (car ls)
                   (cdr ls))))))
      (rec '() '() ls))))
(define
  filter-out
  (lambda
    (f . l)
    (apply filter (lambda (e) (not (f e))) l)))
(define
  string->point
  (lambda
    (s)
    (map string->number
         (string-split
           (substring s 1 (- (string-length s) 1))
           ", "))))
(define
  random-color
  (lambda
    ()
    (apply string-append
           "#"
           (map (lambda
                  args
                  ((letrec
                     ((matcher
                        (lambda
                          (vals)
                          ((lambda
                             (fail)
                             (if (pair? vals)
                                 ((lambda
                                    (valx valy)
                                    (if (null? valy)
                                        (integer->string/padding
                                          (random 256)
                                          2
                                          16)
                                        (fail)))
                                  (car vals)
                                  (cdr vals))
                                 (fail)))
                           (lambda () (match-failure vals))))))
                     matcher)
                   args))
                (iota 3)))))
(define zx 600)
(define zy 300)
(define sizex (lambda (x) (* x zx)))
(define sizey (lambda (y) (* y zy)))
(define
  size-x
  (lambda (x) (number->string (sizex x))))
(define
  size-y
  (lambda (y) (number->string (sizey y))))
(define
  coord-x
  (lambda (x) (number->string (+ 160 (sizex x)))))
(define
  coord-y
  (lambda (y) (number->string (- 700 (sizey y)))))
(define
  |coord-x'|
  (lambda (x) (number->string (+ 0 (* x 100)))))
(define
  |coord-y'|
  (lambda (y) (number->string (- 100 (* y 100)))))
(define
  translate
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (null? vals)
                   (lambda args (matcher args))
                   (if (pair? vals)
                       ((lambda
                          (valx valy)
                          ((lambda
                             (dx)
                             (if (null? valy)
                                 (lambda args (matcher (append (list dx) args)))
                                 (if (pair? valy)
                                     ((lambda
                                        (valx valy)
                                        ((lambda
                                           (dy)
                                           (if (null? valy)
                                               (lambda
                                                 args
                                                 (matcher
                                                   (append (list dx dy) args)))
                                               (if (pair? valy)
                                                   ((lambda
                                                      (valx valy)
                                                      (if (pair? valx)
                                                          ((lambda
                                                             (valx _valy_83)
                                                             ((lambda
                                                                (tag)
                                                                (if (pair? _valy_83)
                                                                    ((lambda
                                                                       (valx _valy_90)
                                                                       (if (pair? valx)
                                                                           ((lambda
                                                                              (valx _valy_92)
                                                                              ((lambda
                                                                                 (x1)
                                                                                 (if (pair? _valy_92)
                                                                                     ((lambda
                                                                                        (valx _valy_100)
                                                                                        ((lambda
                                                                                           (y1)
                                                                                           (if (null? _valy_100)
                                                                                               (if (pair? _valy_90)
                                                                                                   ((lambda
                                                                                                      (valx _valy_109)
                                                                                                      (if (pair? valx)
                                                                                                          ((lambda
                                                                                                             (valx _valy_111)
                                                                                                             ((lambda
                                                                                                                (x2)
                                                                                                                (if (pair? _valy_111)
                                                                                                                    ((lambda
                                                                                                                       (valx _valy_119)
                                                                                                                       ((lambda
                                                                                                                          (y2)
                                                                                                                          (if (null? _valy_119)
                                                                                                                              (if (pair? _valy_109)
                                                                                                                                  ((lambda
                                                                                                                                     (valx _valy_128)
                                                                                                                                     (if (pair? valx)
                                                                                                                                         ((lambda
                                                                                                                                            (valx _valy_130)
                                                                                                                                            ((lambda
                                                                                                                                               (x3)
                                                                                                                                               (if (pair? _valy_130)
                                                                                                                                                   ((lambda
                                                                                                                                                      (valx _valy_138)
                                                                                                                                                      ((lambda
                                                                                                                                                         (y3)
                                                                                                                                                         (if (null? _valy_138)
                                                                                                                                                             (if (null? _valy_128)
                                                                                                                                                                 ((lambda
                                                                                                                                                                    (exp)
                                                                                                                                                                    (if (null? valy)
                                                                                                                                                                        exp
                                                                                                                                                                        (apply exp
                                                                                                                                                                               valy)))
                                                                                                                                                                  (_list_33
                                                                                                                                                                    tag
                                                                                                                                                                    (_list_33
                                                                                                                                                                      (+ x1
                                                                                                                                                                         dx)
                                                                                                                                                                      (+ y1
                                                                                                                                                                         dy))
                                                                                                                                                                    (_list_33
                                                                                                                                                                      (+ x2
                                                                                                                                                                         dx)
                                                                                                                                                                      (+ y2
                                                                                                                                                                         dy))
                                                                                                                                                                    (_list_33
                                                                                                                                                                      (+ x3
                                                                                                                                                                         dx)
                                                                                                                                                                      (+ y3
                                                                                                                                                                         dy))))
                                                                                                                                                                 (fail 'continue))
                                                                                                                                                             (fail 'continue)))
                                                                                                                                                       valx))
                                                                                                                                                    (car _valy_130)
                                                                                                                                                    (cdr _valy_130))
                                                                                                                                                   (fail 'continue)))
                                                                                                                                             valx))
                                                                                                                                          (car valx)
                                                                                                                                          (cdr valx))
                                                                                                                                         (fail 'continue)))
                                                                                                                                   (car _valy_109)
                                                                                                                                   (cdr _valy_109))
                                                                                                                                  (fail 'continue))
                                                                                                                              (fail 'continue)))
                                                                                                                        valx))
                                                                                                                     (car _valy_111)
                                                                                                                     (cdr _valy_111))
                                                                                                                    (fail 'continue)))
                                                                                                              valx))
                                                                                                           (car valx)
                                                                                                           (cdr valx))
                                                                                                          (fail 'continue)))
                                                                                                    (car _valy_90)
                                                                                                    (cdr _valy_90))
                                                                                                   (fail 'continue))
                                                                                               (fail 'continue)))
                                                                                         valx))
                                                                                      (car _valy_92)
                                                                                      (cdr _valy_92))
                                                                                     (fail 'continue)))
                                                                               valx))
                                                                            (car valx)
                                                                            (cdr valx))
                                                                           (fail 'continue)))
                                                                     (car _valy_83)
                                                                     (cdr _valy_83))
                                                                    (fail 'continue)))
                                                              valx))
                                                           (car valx)
                                                           (cdr valx))
                                                          (fail 'continue)))
                                                    (car valy)
                                                    (cdr valy))
                                                   (fail 'pair-expected))))
                                         valx))
                                      (car valy)
                                      (cdr valy))
                                     (fail 'pair-expected))))
                           valx))
                        (car vals)
                        (cdr vals))
                       (fail 'pair-expected))))
             (lambda
               (___)
               (match-failure (_list_33 'autocurry vals)))))))
       matcher)
     args)))
(define
  maxx
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (pair? vals)
                   ((lambda
                      (valx valy)
                      ((lambda
                         (x2)
                         (if (pair? valy)
                             ((lambda
                                (valx valy)
                                (if (pair? valx)
                                    ((lambda
                                       (valx _valy_77)
                                       ((lambda
                                          (x1)
                                          (if (pair? _valy_77)
                                              ((lambda
                                                 (valx _valy_83)
                                                 (if (null? _valy_83)
                                                     (if (null? valy)
                                                         (max x1 x2)
                                                         (fail))
                                                     (fail)))
                                               (car _valy_77)
                                               (cdr _valy_77))
                                              (fail)))
                                        valx))
                                     (car valx)
                                     (cdr valx))
                                    (fail)))
                              (car valy)
                              (cdr valy))
                             (fail)))
                       valx))
                    (car vals)
                    (cdr vals))
                   (fail)))
             (lambda () (match-failure vals))))))
       matcher)
     args)))
(define
  minx
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (pair? vals)
                   ((lambda
                      (valx valy)
                      ((lambda
                         (x2)
                         (if (pair? valy)
                             ((lambda
                                (valx valy)
                                (if (pair? valx)
                                    ((lambda
                                       (valx _valy_77)
                                       ((lambda
                                          (x1)
                                          (if (pair? _valy_77)
                                              ((lambda
                                                 (valx _valy_83)
                                                 (if (null? _valy_83)
                                                     (if (null? valy)
                                                         (min x1 x2)
                                                         (fail))
                                                     (fail)))
                                               (car _valy_77)
                                               (cdr _valy_77))
                                              (fail)))
                                        valx))
                                     (car valx)
                                     (cdr valx))
                                    (fail)))
                              (car valy)
                              (cdr valy))
                             (fail)))
                       valx))
                    (car vals)
                    (cdr vals))
                   (fail)))
             (lambda () (match-failure vals))))))
       matcher)
     args)))
(define
  maxy
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (pair? vals)
                   ((lambda
                      (valx valy)
                      ((lambda
                         (y2)
                         (if (pair? valy)
                             ((lambda
                                (valx valy)
                                (if (pair? valx)
                                    ((lambda
                                       (valx _valy_77)
                                       (if (pair? _valy_77)
                                           ((lambda
                                              (valx _valy_79)
                                              ((lambda
                                                 (y1)
                                                 (if (null? _valy_79)
                                                     (if (null? valy)
                                                         (max y1 y2)
                                                         (fail))
                                                     (fail)))
                                               valx))
                                            (car _valy_77)
                                            (cdr _valy_77))
                                           (fail)))
                                     (car valx)
                                     (cdr valx))
                                    (fail)))
                              (car valy)
                              (cdr valy))
                             (fail)))
                       valx))
                    (car vals)
                    (cdr vals))
                   (fail)))
             (lambda () (match-failure vals))))))
       matcher)
     args)))
(define
  miny
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (pair? vals)
                   ((lambda
                      (valx valy)
                      ((lambda
                         (y2)
                         (if (pair? valy)
                             ((lambda
                                (valx valy)
                                (if (pair? valx)
                                    ((lambda
                                       (valx _valy_77)
                                       (if (pair? _valy_77)
                                           ((lambda
                                              (valx _valy_79)
                                              ((lambda
                                                 (y1)
                                                 (if (null? _valy_79)
                                                     (if (null? valy)
                                                         (min y1 y2)
                                                         (fail))
                                                     (fail)))
                                               valx))
                                            (car _valy_77)
                                            (cdr _valy_77))
                                           (fail)))
                                     (car valx)
                                     (cdr valx))
                                    (fail)))
                              (car valy)
                              (cdr valy))
                             (fail)))
                       valx))
                    (car vals)
                    (cdr vals))
                   (fail)))
             (lambda () (match-failure vals))))))
       matcher)
     args)))
(define
  flip
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (null? vals)
                   (lambda args (matcher args))
                   (if (pair? vals)
                       ((lambda
                          (valx valy)
                          ((lambda
                             (f)
                             (if (null? valy)
                                 (lambda args (matcher (append (list f) args)))
                                 (if (pair? valy)
                                     ((lambda
                                        (valx valy)
                                        ((lambda
                                           (x)
                                           (if (null? valy)
                                               (lambda
                                                 args
                                                 (matcher
                                                   (append (list f x) args)))
                                               (if (pair? valy)
                                                   ((lambda
                                                      (valx valy)
                                                      ((lambda
                                                         (y)
                                                         ((lambda
                                                            (exp)
                                                            (if (null? valy)
                                                                exp
                                                                (apply exp
                                                                       valy)))
                                                          (f y x)))
                                                       valx))
                                                    (car valy)
                                                    (cdr valy))
                                                   (fail 'pair-expected))))
                                         valx))
                                      (car valy)
                                      (cdr valy))
                                     (fail 'pair-expected))))
                           valx))
                        (car vals)
                        (cdr vals))
                       (fail 'pair-expected))))
             (lambda
               (___)
               (match-failure (_list_33 'autocurry vals)))))))
       matcher)
     args)))
(define
  min-x
  (lambda (w1009) (fold (flip minx) 10000 w1009)))
(define
  max-x
  (lambda (w1010) (fold (flip maxx) -10000 w1010)))
(define
  min-y
  (lambda (w1011) (fold (flip miny) 10000 w1011)))
(define
  max-y
  (lambda (w1012) (fold (flip maxy) -10000 w1012)))
(define
  normalize
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (pair? vals)
                   ((lambda
                      (valx valy)
                      ((lambda
                         (t)
                         (if (null? valy)
                             ((lambda
                                (mx my xm ym)
                                ((lambda
                                   (rx)
                                   ((lambda
                                      (ry)
                                      (map (lambda
                                             args
                                             ((letrec
                                                ((matcher
                                                   (lambda
                                                     (vals)
                                                     ((lambda
                                                        (fail)
                                                        (if (pair? vals)
                                                            ((lambda
                                                               (valx valy)
                                                               (if (pair? valx)
                                                                   ((lambda
                                                                      (valx _valy_96)
                                                                      ((lambda
                                                                         (x)
                                                                         (if (pair? _valy_96)
                                                                             ((lambda
                                                                                (valx _valy_101)
                                                                                ((lambda
                                                                                   (y)
                                                                                   (if (null? _valy_101)
                                                                                       (if (null? valy)
                                                                                           (_list_33
                                                                                             (/ (- x
                                                                                                   mx)
                                                                                                rx)
                                                                                             (/ (- y
                                                                                                   my)
                                                                                                ry))
                                                                                           (fail))
                                                                                       (fail)))
                                                                                 valx))
                                                                              (car _valy_96)
                                                                              (cdr _valy_96))
                                                                             (fail)))
                                                                       valx))
                                                                    (car valx)
                                                                    (cdr valx))
                                                                   (fail)))
                                                             (car vals)
                                                             (cdr vals))
                                                            (fail)))
                                                      (lambda
                                                        ()
                                                        (match-failure
                                                          vals))))))
                                                matcher)
                                              args))
                                           t))
                                    (- ym my)))
                                 (- xm mx)))
                              (min-x t)
                              (min-y t)
                              (max-x t)
                              (max-y t))
                             (fail)))
                       valx))
                    (car vals)
                    (cdr vals))
                   (fail)))
             (lambda () (match-failure vals))))))
       matcher)
     args)))
(define
  min-xs
  (lambda
    (ts)
    (reduce min 10000 (map min-x (map cdr ts)))))
(define
  max-xs
  (lambda
    (ts)
    (reduce max -10000 (map max-x (map cdr ts)))))
(define
  min-ys
  (lambda
    (ts)
    (reduce min 10000 (map min-y (map cdr ts)))))
(define
  max-ys
  (lambda
    (ts)
    (reduce max -10000 (map max-y (map cdr ts)))))
(define
  normalizes
  (lambda
    (ts)
    ((lambda
       (mx my xm ym)
       ((lambda
          (rx)
          ((lambda
             (ry)
             ((zip-with cons)
              (map car ts)
              (map (compose
                     (lambda
                       (w1013)
                       (map (lambda
                              args
                              ((letrec
                                 ((matcher
                                    (lambda
                                      (vals)
                                      ((lambda
                                         (fail)
                                         (if (pair? vals)
                                             ((lambda
                                                (valx valy)
                                                (if (pair? valx)
                                                    ((lambda
                                                       (valx _valy_80)
                                                       ((lambda
                                                          (x)
                                                          (if (pair? _valy_80)
                                                              ((lambda
                                                                 (valx _valy_85)
                                                                 ((lambda
                                                                    (y)
                                                                    (if (null? _valy_85)
                                                                        (if (null? valy)
                                                                            (_list_33
                                                                              (/ (- x
                                                                                    mx)
                                                                                 rx)
                                                                              (/ (- y
                                                                                    my)
                                                                                 ry))
                                                                            (fail))
                                                                        (fail)))
                                                                  valx))
                                                               (car _valy_80)
                                                               (cdr _valy_80))
                                                              (fail)))
                                                        valx))
                                                     (car valx)
                                                     (cdr valx))
                                                    (fail)))
                                              (car vals)
                                              (cdr vals))
                                             (fail)))
                                       (lambda () (match-failure vals))))))
                                 matcher)
                               args))
                            w1013))
                     cdr)
                   ts)))
           (- ym my)))
        (- xm mx)))
     (min-xs ts)
     (min-ys ts)
     (max-xs ts)
     (max-ys ts))))
(define
  tri->div
  (lambda
    (ax ay . t)
    (_list_33
      '<DIV>
      ':style
      (string-append
        "width:0;"
        "height:0;"
        "position:absolute;"
        "left:"
        (coord-x (+ ax (min-x (cdr t))))
        "px;"
        "top:"
        (coord-y (+ ay (max-y (cdr t))))
        "px;"
        (apply (lambda
                 args
                 ((letrec
                    ((matcher
                       (lambda
                         (vals)
                         ((lambda
                            (fail)
                            (if (pair? vals)
                                ((lambda
                                   (valx valy)
                                   (if (equal? valx ':GE)
                                       ((letrec
                                          ((loop (lambda
                                                   (z points)
                                                   (if (null? z)
                                                       ((lambda (points) '"")
                                                        (reverse points))
                                                       (if (pair? z)
                                                           ((lambda
                                                              (valx valy)
                                                              ((lambda
                                                                 (points)
                                                                 (loop valy
                                                                       (cons (car points)
                                                                             (cdr points))))
                                                               (cons valx
                                                                     points)))
                                                            (car z)
                                                            (cdr z))
                                                           (fail))))))
                                          loop)
                                        valy
                                        '())
                                       (fail)))
                                 (car vals)
                                 (cdr vals))
                                (fail)))
                          (lambda
                            ()
                            ((lambda
                               (fail)
                               (if (pair? vals)
                                   ((lambda
                                      (valx valy)
                                      (if (equal? valx ':UL)
                                          (if (pair? valy)
                                              ((lambda
                                                 (valx valy)
                                                 (if (pair? valx)
                                                     ((lambda
                                                        (valx _valy_78)
                                                        ((lambda
                                                           (x1)
                                                           (if (pair? _valy_78)
                                                               ((lambda
                                                                  (valx _valy_83)
                                                                  ((lambda
                                                                     (y1)
                                                                     (if (null? _valy_83)
                                                                         (if (pair? valy)
                                                                             ((lambda
                                                                                (valx valy)
                                                                                (if (pair? valx)
                                                                                    ((lambda
                                                                                       (valx _valy_91)
                                                                                       ((lambda
                                                                                          (x2)
                                                                                          (if (pair? _valy_91)
                                                                                              ((lambda
                                                                                                 (valx _valy_96)
                                                                                                 ((lambda
                                                                                                    (y2)
                                                                                                    (if (null? _valy_96)
                                                                                                        (if (pair? valy)
                                                                                                            ((lambda
                                                                                                               (valx valy)
                                                                                                               (if (pair? valx)
                                                                                                                   ((lambda
                                                                                                                      (valx _valy_104)
                                                                                                                      ((lambda
                                                                                                                         (x3)
                                                                                                                         (if (pair? _valy_104)
                                                                                                                             ((lambda
                                                                                                                                (valx _valy_109)
                                                                                                                                ((lambda
                                                                                                                                   (y3)
                                                                                                                                   (if (null? _valy_109)
                                                                                                                                       (if (null? valy)
                                                                                                                                           ((lambda
                                                                                                                                              (bx by
                                                                                                                                                  co)
                                                                                                                                              (string-append
                                                                                                                                                "border-top:"
                                                                                                                                                by
                                                                                                                                                "px solid "
                                                                                                                                                co
                                                                                                                                                ";"
                                                                                                                                                "border-left:"
                                                                                                                                                bx
                                                                                                                                                "px solid "
                                                                                                                                                co
                                                                                                                                                ";"
                                                                                                                                                "border-right:"
                                                                                                                                                bx
                                                                                                                                                "px solid transparent;"
                                                                                                                                                "border-bottom:"
                                                                                                                                                by
                                                                                                                                                "px solid transparent;"))
                                                                                                                                            (size-x
                                                                                                                                              (/ (- x2
                                                                                                                                                    x1)
                                                                                                                                                 2))
                                                                                                                                            (size-y
                                                                                                                                              (/ (- y1
                                                                                                                                                    y3)
                                                                                                                                                 2))
                                                                                                                                            (random-color))
                                                                                                                                           (fail))
                                                                                                                                       (fail)))
                                                                                                                                 valx))
                                                                                                                              (car _valy_104)
                                                                                                                              (cdr _valy_104))
                                                                                                                             (fail)))
                                                                                                                       valx))
                                                                                                                    (car valx)
                                                                                                                    (cdr valx))
                                                                                                                   (fail)))
                                                                                                             (car valy)
                                                                                                             (cdr valy))
                                                                                                            (fail))
                                                                                                        (fail)))
                                                                                                  valx))
                                                                                               (car _valy_91)
                                                                                               (cdr _valy_91))
                                                                                              (fail)))
                                                                                        valx))
                                                                                     (car valx)
                                                                                     (cdr valx))
                                                                                    (fail)))
                                                                              (car valy)
                                                                              (cdr valy))
                                                                             (fail))
                                                                         (fail)))
                                                                   valx))
                                                                (car _valy_78)
                                                                (cdr _valy_78))
                                                               (fail)))
                                                         valx))
                                                      (car valx)
                                                      (cdr valx))
                                                     (fail)))
                                               (car valy)
                                               (cdr valy))
                                              (fail))
                                          (fail)))
                                    (car vals)
                                    (cdr vals))
                                   (fail)))
                             (lambda
                               ()
                               ((lambda
                                  (fail)
                                  (if (pair? vals)
                                      ((lambda
                                         (valx valy)
                                         (if (equal? valx ':UR)
                                             (if (pair? valy)
                                                 ((lambda
                                                    (valx valy)
                                                    (if (pair? valx)
                                                        ((lambda
                                                           (valx _valy_78)
                                                           ((lambda
                                                              (x1)
                                                              (if (pair? _valy_78)
                                                                  ((lambda
                                                                     (valx _valy_83)
                                                                     ((lambda
                                                                        (y1)
                                                                        (if (null? _valy_83)
                                                                            (if (pair? valy)
                                                                                ((lambda
                                                                                   (valx valy)
                                                                                   (if (pair? valx)
                                                                                       ((lambda
                                                                                          (valx _valy_91)
                                                                                          ((lambda
                                                                                             (x2)
                                                                                             (if (pair? _valy_91)
                                                                                                 ((lambda
                                                                                                    (valx _valy_96)
                                                                                                    ((lambda
                                                                                                       (y2)
                                                                                                       (if (null? _valy_96)
                                                                                                           (if (pair? valy)
                                                                                                               ((lambda
                                                                                                                  (valx valy)
                                                                                                                  (if (pair? valx)
                                                                                                                      ((lambda
                                                                                                                         (valx _valy_104)
                                                                                                                         ((lambda
                                                                                                                            (x3)
                                                                                                                            (if (pair? _valy_104)
                                                                                                                                ((lambda
                                                                                                                                   (valx _valy_109)
                                                                                                                                   ((lambda
                                                                                                                                      (y3)
                                                                                                                                      (if (null? _valy_109)
                                                                                                                                          (if (null? valy)
                                                                                                                                              ((lambda
                                                                                                                                                 (bx by
                                                                                                                                                     co)
                                                                                                                                                 (string-append
                                                                                                                                                   "border-top:"
                                                                                                                                                   by
                                                                                                                                                   "px solid "
                                                                                                                                                   co
                                                                                                                                                   ";"
                                                                                                                                                   "border-left:"
                                                                                                                                                   bx
                                                                                                                                                   "px solid transparent;"
                                                                                                                                                   "border-right:"
                                                                                                                                                   bx
                                                                                                                                                   "px solid "
                                                                                                                                                   co
                                                                                                                                                   ";"
                                                                                                                                                   "border-bottom:"
                                                                                                                                                   by
                                                                                                                                                   "px solid transparent;"))
                                                                                                                                               (size-x
                                                                                                                                                 (/ (- x2
                                                                                                                                                       x1)
                                                                                                                                                    2))
                                                                                                                                               (size-y
                                                                                                                                                 (/ (- y1
                                                                                                                                                       y3)
                                                                                                                                                    2))
                                                                                                                                               (random-color))
                                                                                                                                              (fail))
                                                                                                                                          (fail)))
                                                                                                                                    valx))
                                                                                                                                 (car _valy_104)
                                                                                                                                 (cdr _valy_104))
                                                                                                                                (fail)))
                                                                                                                          valx))
                                                                                                                       (car valx)
                                                                                                                       (cdr valx))
                                                                                                                      (fail)))
                                                                                                                (car valy)
                                                                                                                (cdr valy))
                                                                                                               (fail))
                                                                                                           (fail)))
                                                                                                     valx))
                                                                                                  (car _valy_91)
                                                                                                  (cdr _valy_91))
                                                                                                 (fail)))
                                                                                           valx))
                                                                                        (car valx)
                                                                                        (cdr valx))
                                                                                       (fail)))
                                                                                 (car valy)
                                                                                 (cdr valy))
                                                                                (fail))
                                                                            (fail)))
                                                                      valx))
                                                                   (car _valy_78)
                                                                   (cdr _valy_78))
                                                                  (fail)))
                                                            valx))
                                                         (car valx)
                                                         (cdr valx))
                                                        (fail)))
                                                  (car valy)
                                                  (cdr valy))
                                                 (fail))
                                             (fail)))
                                       (car vals)
                                       (cdr vals))
                                      (fail)))
                                (lambda
                                  ()
                                  ((lambda
                                     (fail)
                                     (if (pair? vals)
                                         ((lambda
                                            (valx valy)
                                            (if (equal? valx ':UC)
                                                (if (pair? valy)
                                                    ((lambda
                                                       (valx valy)
                                                       (if (pair? valx)
                                                           ((lambda
                                                              (valx _valy_78)
                                                              ((lambda
                                                                 (x1)
                                                                 (if (pair? _valy_78)
                                                                     ((lambda
                                                                        (valx _valy_83)
                                                                        ((lambda
                                                                           (y1)
                                                                           (if (null? _valy_83)
                                                                               (if (pair? valy)
                                                                                   ((lambda
                                                                                      (valx valy)
                                                                                      (if (pair? valx)
                                                                                          ((lambda
                                                                                             (valx _valy_91)
                                                                                             ((lambda
                                                                                                (x2)
                                                                                                (if (pair? _valy_91)
                                                                                                    ((lambda
                                                                                                       (valx _valy_96)
                                                                                                       ((lambda
                                                                                                          (y2)
                                                                                                          (if (null? _valy_96)
                                                                                                              (if (pair? valy)
                                                                                                                  ((lambda
                                                                                                                     (valx valy)
                                                                                                                     (if (pair? valx)
                                                                                                                         ((lambda
                                                                                                                            (valx _valy_104)
                                                                                                                            ((lambda
                                                                                                                               (x3)
                                                                                                                               (if (pair? _valy_104)
                                                                                                                                   ((lambda
                                                                                                                                      (valx _valy_109)
                                                                                                                                      ((lambda
                                                                                                                                         (y3)
                                                                                                                                         (if (null? _valy_109)
                                                                                                                                             (if (null? valy)
                                                                                                                                                 ((lambda
                                                                                                                                                    (br bl
                                                                                                                                                        by
                                                                                                                                                        co)
                                                                                                                                                    (string-append
                                                                                                                                                      "border-top:"
                                                                                                                                                      by
                                                                                                                                                      "px solid "
                                                                                                                                                      co
                                                                                                                                                      ";"
                                                                                                                                                      "border-left:"
                                                                                                                                                      bl
                                                                                                                                                      "px solid transparent;"
                                                                                                                                                      "border-right:"
                                                                                                                                                      br
                                                                                                                                                      "px solid transparent;"
                                                                                                                                                      "border-bottom:"
                                                                                                                                                      "0"
                                                                                                                                                      "px solid transparent;"))
                                                                                                                                                  (size-x
                                                                                                                                                    (- x2
                                                                                                                                                       x3))
                                                                                                                                                  (size-x
                                                                                                                                                    (- x3
                                                                                                                                                       x1))
                                                                                                                                                  (size-y
                                                                                                                                                    (- y1
                                                                                                                                                       y3))
                                                                                                                                                  (random-color))
                                                                                                                                                 (fail))
                                                                                                                                             (fail)))
                                                                                                                                       valx))
                                                                                                                                    (car _valy_104)
                                                                                                                                    (cdr _valy_104))
                                                                                                                                   (fail)))
                                                                                                                             valx))
                                                                                                                          (car valx)
                                                                                                                          (cdr valx))
                                                                                                                         (fail)))
                                                                                                                   (car valy)
                                                                                                                   (cdr valy))
                                                                                                                  (fail))
                                                                                                              (fail)))
                                                                                                        valx))
                                                                                                     (car _valy_91)
                                                                                                     (cdr _valy_91))
                                                                                                    (fail)))
                                                                                              valx))
                                                                                           (car valx)
                                                                                           (cdr valx))
                                                                                          (fail)))
                                                                                    (car valy)
                                                                                    (cdr valy))
                                                                                   (fail))
                                                                               (fail)))
                                                                         valx))
                                                                      (car _valy_78)
                                                                      (cdr _valy_78))
                                                                     (fail)))
                                                               valx))
                                                            (car valx)
                                                            (cdr valx))
                                                           (fail)))
                                                     (car valy)
                                                     (cdr valy))
                                                    (fail))
                                                (fail)))
                                          (car vals)
                                          (cdr vals))
                                         (fail)))
                                   (lambda
                                     ()
                                     ((lambda
                                        (fail)
                                        (if (pair? vals)
                                            ((lambda
                                               (valx valy)
                                               (if (equal? valx ':DL)
                                                   (if (pair? valy)
                                                       ((lambda
                                                          (valx valy)
                                                          (if (pair? valx)
                                                              ((lambda
                                                                 (valx _valy_78)
                                                                 ((lambda
                                                                    (x1)
                                                                    (if (pair? _valy_78)
                                                                        ((lambda
                                                                           (valx _valy_83)
                                                                           ((lambda
                                                                              (y1)
                                                                              (if (null? _valy_83)
                                                                                  (if (pair? valy)
                                                                                      ((lambda
                                                                                         (valx valy)
                                                                                         (if (pair? valx)
                                                                                             ((lambda
                                                                                                (valx _valy_91)
                                                                                                ((lambda
                                                                                                   (x2)
                                                                                                   (if (pair? _valy_91)
                                                                                                       ((lambda
                                                                                                          (valx _valy_96)
                                                                                                          ((lambda
                                                                                                             (y2)
                                                                                                             (if (null? _valy_96)
                                                                                                                 (if (pair? valy)
                                                                                                                     ((lambda
                                                                                                                        (valx valy)
                                                                                                                        (if (pair? valx)
                                                                                                                            ((lambda
                                                                                                                               (valx _valy_104)
                                                                                                                               ((lambda
                                                                                                                                  (x3)
                                                                                                                                  (if (pair? _valy_104)
                                                                                                                                      ((lambda
                                                                                                                                         (valx _valy_109)
                                                                                                                                         ((lambda
                                                                                                                                            (y3)
                                                                                                                                            (if (null? _valy_109)
                                                                                                                                                (if (null? valy)
                                                                                                                                                    ((lambda
                                                                                                                                                       (bx by
                                                                                                                                                           co)
                                                                                                                                                       (string-append
                                                                                                                                                         "border-top:"
                                                                                                                                                         by
                                                                                                                                                         "px solid transparent;"
                                                                                                                                                         "border-left:"
                                                                                                                                                         bx
                                                                                                                                                         "px solid "
                                                                                                                                                         co
                                                                                                                                                         ";"
                                                                                                                                                         "border-right:"
                                                                                                                                                         bx
                                                                                                                                                         "px solid transparent;"
                                                                                                                                                         "border-bottom:"
                                                                                                                                                         by
                                                                                                                                                         "px solid "
                                                                                                                                                         co
                                                                                                                                                         ";"))
                                                                                                                                                     (size-x
                                                                                                                                                       (/ (- x3
                                                                                                                                                             x2)
                                                                                                                                                          2))
                                                                                                                                                     (size-y
                                                                                                                                                       (/ (- y1
                                                                                                                                                             y2)
                                                                                                                                                          2))
                                                                                                                                                     (random-color))
                                                                                                                                                    (fail))
                                                                                                                                                (fail)))
                                                                                                                                          valx))
                                                                                                                                       (car _valy_104)
                                                                                                                                       (cdr _valy_104))
                                                                                                                                      (fail)))
                                                                                                                                valx))
                                                                                                                             (car valx)
                                                                                                                             (cdr valx))
                                                                                                                            (fail)))
                                                                                                                      (car valy)
                                                                                                                      (cdr valy))
                                                                                                                     (fail))
                                                                                                                 (fail)))
                                                                                                           valx))
                                                                                                        (car _valy_91)
                                                                                                        (cdr _valy_91))
                                                                                                       (fail)))
                                                                                                 valx))
                                                                                              (car valx)
                                                                                              (cdr valx))
                                                                                             (fail)))
                                                                                       (car valy)
                                                                                       (cdr valy))
                                                                                      (fail))
                                                                                  (fail)))
                                                                            valx))
                                                                         (car _valy_78)
                                                                         (cdr _valy_78))
                                                                        (fail)))
                                                                  valx))
                                                               (car valx)
                                                               (cdr valx))
                                                              (fail)))
                                                        (car valy)
                                                        (cdr valy))
                                                       (fail))
                                                   (fail)))
                                             (car vals)
                                             (cdr vals))
                                            (fail)))
                                      (lambda
                                        ()
                                        ((lambda
                                           (fail)
                                           (if (pair? vals)
                                               ((lambda
                                                  (valx valy)
                                                  (if (equal? valx ':DR)
                                                      (if (pair? valy)
                                                          ((lambda
                                                             (valx valy)
                                                             (if (pair? valx)
                                                                 ((lambda
                                                                    (valx _valy_78)
                                                                    ((lambda
                                                                       (x1)
                                                                       (if (pair? _valy_78)
                                                                           ((lambda
                                                                              (valx _valy_83)
                                                                              ((lambda
                                                                                 (y1)
                                                                                 (if (null? _valy_83)
                                                                                     (if (pair? valy)
                                                                                         ((lambda
                                                                                            (valx valy)
                                                                                            (if (pair? valx)
                                                                                                ((lambda
                                                                                                   (valx _valy_91)
                                                                                                   ((lambda
                                                                                                      (x2)
                                                                                                      (if (pair? _valy_91)
                                                                                                          ((lambda
                                                                                                             (valx _valy_96)
                                                                                                             ((lambda
                                                                                                                (y2)
                                                                                                                (if (null? _valy_96)
                                                                                                                    (if (pair? valy)
                                                                                                                        ((lambda
                                                                                                                           (valx valy)
                                                                                                                           (if (pair? valx)
                                                                                                                               ((lambda
                                                                                                                                  (valx _valy_104)
                                                                                                                                  ((lambda
                                                                                                                                     (x3)
                                                                                                                                     (if (pair? _valy_104)
                                                                                                                                         ((lambda
                                                                                                                                            (valx _valy_109)
                                                                                                                                            ((lambda
                                                                                                                                               (y3)
                                                                                                                                               (if (null? _valy_109)
                                                                                                                                                   (if (null? valy)
                                                                                                                                                       ((lambda
                                                                                                                                                          (bx by
                                                                                                                                                              co)
                                                                                                                                                          (string-append
                                                                                                                                                            "border-top:"
                                                                                                                                                            by
                                                                                                                                                            "px solid transparent;"
                                                                                                                                                            "border-left:"
                                                                                                                                                            bx
                                                                                                                                                            "px solid transparent;"
                                                                                                                                                            "border-right:"
                                                                                                                                                            bx
                                                                                                                                                            "px solid "
                                                                                                                                                            co
                                                                                                                                                            ";"
                                                                                                                                                            "border-bottom:"
                                                                                                                                                            by
                                                                                                                                                            "px solid "
                                                                                                                                                            co
                                                                                                                                                            ";"))
                                                                                                                                                        (size-x
                                                                                                                                                          (/ (- x3
                                                                                                                                                                x2)
                                                                                                                                                             2))
                                                                                                                                                        (size-y
                                                                                                                                                          (/ (- y1
                                                                                                                                                                y2)
                                                                                                                                                             2))
                                                                                                                                                        (random-color))
                                                                                                                                                       (fail))
                                                                                                                                                   (fail)))
                                                                                                                                             valx))
                                                                                                                                          (car _valy_104)
                                                                                                                                          (cdr _valy_104))
                                                                                                                                         (fail)))
                                                                                                                                   valx))
                                                                                                                                (car valx)
                                                                                                                                (cdr valx))
                                                                                                                               (fail)))
                                                                                                                         (car valy)
                                                                                                                         (cdr valy))
                                                                                                                        (fail))
                                                                                                                    (fail)))
                                                                                                              valx))
                                                                                                           (car _valy_91)
                                                                                                           (cdr _valy_91))
                                                                                                          (fail)))
                                                                                                    valx))
                                                                                                 (car valx)
                                                                                                 (cdr valx))
                                                                                                (fail)))
                                                                                          (car valy)
                                                                                          (cdr valy))
                                                                                         (fail))
                                                                                     (fail)))
                                                                               valx))
                                                                            (car _valy_78)
                                                                            (cdr _valy_78))
                                                                           (fail)))
                                                                     valx))
                                                                  (car valx)
                                                                  (cdr valx))
                                                                 (fail)))
                                                           (car valy)
                                                           (cdr valy))
                                                          (fail))
                                                      (fail)))
                                                (car vals)
                                                (cdr vals))
                                               (fail)))
                                         (lambda
                                           ()
                                           ((lambda
                                              (fail)
                                              (if (pair? vals)
                                                  ((lambda
                                                     (valx valy)
                                                     (if (equal? valx ':DC)
                                                         (if (pair? valy)
                                                             ((lambda
                                                                (valx valy)
                                                                (if (pair? valx)
                                                                    ((lambda
                                                                       (valx _valy_78)
                                                                       ((lambda
                                                                          (x1)
                                                                          (if (pair? _valy_78)
                                                                              ((lambda
                                                                                 (valx _valy_83)
                                                                                 ((lambda
                                                                                    (y1)
                                                                                    (if (null? _valy_83)
                                                                                        (if (pair? valy)
                                                                                            ((lambda
                                                                                               (valx valy)
                                                                                               (if (pair? valx)
                                                                                                   ((lambda
                                                                                                      (valx _valy_91)
                                                                                                      ((lambda
                                                                                                         (x2)
                                                                                                         (if (pair? _valy_91)
                                                                                                             ((lambda
                                                                                                                (valx _valy_96)
                                                                                                                ((lambda
                                                                                                                   (y2)
                                                                                                                   (if (null? _valy_96)
                                                                                                                       (if (pair? valy)
                                                                                                                           ((lambda
                                                                                                                              (valx valy)
                                                                                                                              (if (pair? valx)
                                                                                                                                  ((lambda
                                                                                                                                     (valx _valy_104)
                                                                                                                                     ((lambda
                                                                                                                                        (x3)
                                                                                                                                        (if (pair? _valy_104)
                                                                                                                                            ((lambda
                                                                                                                                               (valx _valy_109)
                                                                                                                                               ((lambda
                                                                                                                                                  (y3)
                                                                                                                                                  (if (null? _valy_109)
                                                                                                                                                      (if (null? valy)
                                                                                                                                                          ((lambda
                                                                                                                                                             (br bl
                                                                                                                                                                 by
                                                                                                                                                                 co)
                                                                                                                                                             (string-append
                                                                                                                                                               "border-top:"
                                                                                                                                                               "0"
                                                                                                                                                               "px solid transparent;"
                                                                                                                                                               "border-left:"
                                                                                                                                                               bl
                                                                                                                                                               "px solid transparent;"
                                                                                                                                                               "border-right:"
                                                                                                                                                               br
                                                                                                                                                               "px solid transparent;"
                                                                                                                                                               "border-bottom:"
                                                                                                                                                               by
                                                                                                                                                               "px solid "
                                                                                                                                                               co
                                                                                                                                                               ";"))
                                                                                                                                                           (size-x
                                                                                                                                                             (- x3
                                                                                                                                                                x1))
                                                                                                                                                           (size-x
                                                                                                                                                             (- x1
                                                                                                                                                                x2))
                                                                                                                                                           (size-y
                                                                                                                                                             (- y1
                                                                                                                                                                y3))
                                                                                                                                                           (random-color))
                                                                                                                                                          (fail))
                                                                                                                                                      (fail)))
                                                                                                                                                valx))
                                                                                                                                             (car _valy_104)
                                                                                                                                             (cdr _valy_104))
                                                                                                                                            (fail)))
                                                                                                                                      valx))
                                                                                                                                   (car valx)
                                                                                                                                   (cdr valx))
                                                                                                                                  (fail)))
                                                                                                                            (car valy)
                                                                                                                            (cdr valy))
                                                                                                                           (fail))
                                                                                                                       (fail)))
                                                                                                                 valx))
                                                                                                              (car _valy_91)
                                                                                                              (cdr _valy_91))
                                                                                                             (fail)))
                                                                                                       valx))
                                                                                                    (car valx)
                                                                                                    (cdr valx))
                                                                                                   (fail)))
                                                                                             (car valy)
                                                                                             (cdr valy))
                                                                                            (fail))
                                                                                        (fail)))
                                                                                  valx))
                                                                               (car _valy_78)
                                                                               (cdr _valy_78))
                                                                              (fail)))
                                                                        valx))
                                                                     (car valx)
                                                                     (cdr valx))
                                                                    (fail)))
                                                              (car valy)
                                                              (cdr valy))
                                                             (fail))
                                                         (fail)))
                                                   (car vals)
                                                   (cdr vals))
                                                  (fail)))
                                            (lambda
                                              ()
                                              ((lambda
                                                 (fail)
                                                 (if (pair? vals)
                                                     ((lambda
                                                        (valx valy)
                                                        (if (equal? valx ':LC)
                                                            (if (pair? valy)
                                                                ((lambda
                                                                   (valx valy)
                                                                   (if (pair? valx)
                                                                       ((lambda
                                                                          (valx _valy_78)
                                                                          ((lambda
                                                                             (x1)
                                                                             (if (pair? _valy_78)
                                                                                 ((lambda
                                                                                    (valx _valy_83)
                                                                                    ((lambda
                                                                                       (y1)
                                                                                       (if (null? _valy_83)
                                                                                           (if (pair? valy)
                                                                                               ((lambda
                                                                                                  (valx valy)
                                                                                                  (if (pair? valx)
                                                                                                      ((lambda
                                                                                                         (valx _valy_91)
                                                                                                         ((lambda
                                                                                                            (x2)
                                                                                                            (if (pair? _valy_91)
                                                                                                                ((lambda
                                                                                                                   (valx _valy_96)
                                                                                                                   ((lambda
                                                                                                                      (y2)
                                                                                                                      (if (null? _valy_96)
                                                                                                                          (if (pair? valy)
                                                                                                                              ((lambda
                                                                                                                                 (valx valy)
                                                                                                                                 (if (pair? valx)
                                                                                                                                     ((lambda
                                                                                                                                        (valx _valy_104)
                                                                                                                                        ((lambda
                                                                                                                                           (x3)
                                                                                                                                           (if (pair? _valy_104)
                                                                                                                                               ((lambda
                                                                                                                                                  (valx _valy_109)
                                                                                                                                                  ((lambda
                                                                                                                                                     (y3)
                                                                                                                                                     (if (null? _valy_109)
                                                                                                                                                         (if (null? valy)
                                                                                                                                                             ((lambda
                                                                                                                                                                (bt bb
                                                                                                                                                                    bx
                                                                                                                                                                    co)
                                                                                                                                                                (string-append
                                                                                                                                                                  "border-top:"
                                                                                                                                                                  bt
                                                                                                                                                                  "px solid transparent;"
                                                                                                                                                                  "border-left:"
                                                                                                                                                                  bx
                                                                                                                                                                  "px solid "
                                                                                                                                                                  co
                                                                                                                                                                  ";"
                                                                                                                                                                  "border-right:"
                                                                                                                                                                  "0"
                                                                                                                                                                  "px solid transparent;"
                                                                                                                                                                  "border-bottom:"
                                                                                                                                                                  bb
                                                                                                                                                                  "px solid transparent;"))
                                                                                                                                                              (size-y
                                                                                                                                                                (- y1
                                                                                                                                                                   y2))
                                                                                                                                                              (size-y
                                                                                                                                                                (- y2
                                                                                                                                                                   y3))
                                                                                                                                                              (size-x
                                                                                                                                                                (- x2
                                                                                                                                                                   x1))
                                                                                                                                                              (random-color))
                                                                                                                                                             (fail))
                                                                                                                                                         (fail)))
                                                                                                                                                   valx))
                                                                                                                                                (car _valy_104)
                                                                                                                                                (cdr _valy_104))
                                                                                                                                               (fail)))
                                                                                                                                         valx))
                                                                                                                                      (car valx)
                                                                                                                                      (cdr valx))
                                                                                                                                     (fail)))
                                                                                                                               (car valy)
                                                                                                                               (cdr valy))
                                                                                                                              (fail))
                                                                                                                          (fail)))
                                                                                                                    valx))
                                                                                                                 (car _valy_91)
                                                                                                                 (cdr _valy_91))
                                                                                                                (fail)))
                                                                                                          valx))
                                                                                                       (car valx)
                                                                                                       (cdr valx))
                                                                                                      (fail)))
                                                                                                (car valy)
                                                                                                (cdr valy))
                                                                                               (fail))
                                                                                           (fail)))
                                                                                     valx))
                                                                                  (car _valy_78)
                                                                                  (cdr _valy_78))
                                                                                 (fail)))
                                                                           valx))
                                                                        (car valx)
                                                                        (cdr valx))
                                                                       (fail)))
                                                                 (car valy)
                                                                 (cdr valy))
                                                                (fail))
                                                            (fail)))
                                                      (car vals)
                                                      (cdr vals))
                                                     (fail)))
                                               (lambda
                                                 ()
                                                 ((lambda
                                                    (fail)
                                                    (if (pair? vals)
                                                        ((lambda
                                                           (valx valy)
                                                           (if (equal?
                                                                 valx
                                                                 ':RC)
                                                               (if (pair? valy)
                                                                   ((lambda
                                                                      (valx valy)
                                                                      (if (pair? valx)
                                                                          ((lambda
                                                                             (valx _valy_78)
                                                                             ((lambda
                                                                                (x1)
                                                                                (if (pair? _valy_78)
                                                                                    ((lambda
                                                                                       (valx _valy_83)
                                                                                       ((lambda
                                                                                          (y1)
                                                                                          (if (null? _valy_83)
                                                                                              (if (pair? valy)
                                                                                                  ((lambda
                                                                                                     (valx valy)
                                                                                                     (if (pair? valx)
                                                                                                         ((lambda
                                                                                                            (valx _valy_91)
                                                                                                            ((lambda
                                                                                                               (x2)
                                                                                                               (if (pair? _valy_91)
                                                                                                                   ((lambda
                                                                                                                      (valx _valy_96)
                                                                                                                      ((lambda
                                                                                                                         (y2)
                                                                                                                         (if (null? _valy_96)
                                                                                                                             (if (pair? valy)
                                                                                                                                 ((lambda
                                                                                                                                    (valx valy)
                                                                                                                                    (if (pair? valx)
                                                                                                                                        ((lambda
                                                                                                                                           (valx _valy_104)
                                                                                                                                           ((lambda
                                                                                                                                              (x3)
                                                                                                                                              (if (pair? _valy_104)
                                                                                                                                                  ((lambda
                                                                                                                                                     (valx _valy_109)
                                                                                                                                                     ((lambda
                                                                                                                                                        (y3)
                                                                                                                                                        (if (null? _valy_109)
                                                                                                                                                            (if (null? valy)
                                                                                                                                                                ((lambda
                                                                                                                                                                   (bt bb
                                                                                                                                                                       bx
                                                                                                                                                                       co)
                                                                                                                                                                   (string-append
                                                                                                                                                                     "border-top:"
                                                                                                                                                                     bt
                                                                                                                                                                     "px solid transparent;"
                                                                                                                                                                     "border-left:"
                                                                                                                                                                     "0"
                                                                                                                                                                     "px solid transparent;"
                                                                                                                                                                     "border-right:"
                                                                                                                                                                     bx
                                                                                                                                                                     "px solid "
                                                                                                                                                                     co
                                                                                                                                                                     ";"
                                                                                                                                                                     "border-bottom:"
                                                                                                                                                                     bb
                                                                                                                                                                     "px solid transparent;"))
                                                                                                                                                                 (size-y
                                                                                                                                                                   (- y1
                                                                                                                                                                      y2))
                                                                                                                                                                 (size-y
                                                                                                                                                                   (- y2
                                                                                                                                                                      y3))
                                                                                                                                                                 (size-x
                                                                                                                                                                   (- x1
                                                                                                                                                                      x2))
                                                                                                                                                                 (random-color))
                                                                                                                                                                (fail))
                                                                                                                                                            (fail)))
                                                                                                                                                      valx))
                                                                                                                                                   (car _valy_104)
                                                                                                                                                   (cdr _valy_104))
                                                                                                                                                  (fail)))
                                                                                                                                            valx))
                                                                                                                                         (car valx)
                                                                                                                                         (cdr valx))
                                                                                                                                        (fail)))
                                                                                                                                  (car valy)
                                                                                                                                  (cdr valy))
                                                                                                                                 (fail))
                                                                                                                             (fail)))
                                                                                                                       valx))
                                                                                                                    (car _valy_91)
                                                                                                                    (cdr _valy_91))
                                                                                                                   (fail)))
                                                                                                             valx))
                                                                                                          (car valx)
                                                                                                          (cdr valx))
                                                                                                         (fail)))
                                                                                                   (car valy)
                                                                                                   (cdr valy))
                                                                                                  (fail))
                                                                                              (fail)))
                                                                                        valx))
                                                                                     (car _valy_78)
                                                                                     (cdr _valy_78))
                                                                                    (fail)))
                                                                              valx))
                                                                           (car valx)
                                                                           (cdr valx))
                                                                          (fail)))
                                                                    (car valy)
                                                                    (cdr valy))
                                                                   (fail))
                                                               (fail)))
                                                         (car vals)
                                                         (cdr vals))
                                                        (fail)))
                                                  (lambda
                                                    ()
                                                    (match-failure
                                                      vals))))))))))))))))))))))
                    matcher)
                  args))
               t)))))
(define
  tri->svg
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (pair? vals)
                   ((lambda
                      (valx valy)
                      ((lambda
                         (tag)
                         (if (pair? valy)
                             ((lambda
                                (valx valy)
                                (if (pair? valx)
                                    ((lambda
                                       (valx _valy_77)
                                       ((lambda
                                          (x1)
                                          (if (pair? _valy_77)
                                              ((lambda
                                                 (valx _valy_83)
                                                 ((lambda
                                                    (y1)
                                                    (if (null? _valy_83)
                                                        (if (pair? valy)
                                                            ((lambda
                                                               (valx valy)
                                                               (if (pair? valx)
                                                                   ((lambda
                                                                      (valx _valy_92)
                                                                      ((lambda
                                                                         (x2)
                                                                         (if (pair? _valy_92)
                                                                             ((lambda
                                                                                (valx _valy_98)
                                                                                ((lambda
                                                                                   (y2)
                                                                                   (if (null? _valy_98)
                                                                                       (if (pair? valy)
                                                                                           ((lambda
                                                                                              (valx valy)
                                                                                              (if (pair? valx)
                                                                                                  ((lambda
                                                                                                     (valx _valy_107)
                                                                                                     ((lambda
                                                                                                        (x3)
                                                                                                        (if (pair? _valy_107)
                                                                                                            ((lambda
                                                                                                               (valx _valy_113)
                                                                                                               ((lambda
                                                                                                                  (y3)
                                                                                                                  (if (null? _valy_113)
                                                                                                                      (if (null? valy)
                                                                                                                          (_list_33
                                                                                                                            '<SVG:PATH>
                                                                                                                            ':fill
                                                                                                                            '(random-color)
                                                                                                                            ':stroke
                                                                                                                            ''black
                                                                                                                            ':d
                                                                                                                            (format
                                                                                                                              "M ~a ~a L ~a ~a L ~a ~a Z"
                                                                                                                              (|coord-x'|
                                                                                                                                x1)
                                                                                                                              (|coord-y'|
                                                                                                                                y1)
                                                                                                                              (|coord-x'|
                                                                                                                                x2)
                                                                                                                              (|coord-y'|
                                                                                                                                y2)
                                                                                                                              (|coord-x'|
                                                                                                                                x3)
                                                                                                                              (|coord-y'|
                                                                                                                                y3)))
                                                                                                                          (fail))
                                                                                                                      (fail)))
                                                                                                                valx))
                                                                                                             (car _valy_107)
                                                                                                             (cdr _valy_107))
                                                                                                            (fail)))
                                                                                                      valx))
                                                                                                   (car valx)
                                                                                                   (cdr valx))
                                                                                                  (fail)))
                                                                                            (car valy)
                                                                                            (cdr valy))
                                                                                           (fail))
                                                                                       (fail)))
                                                                                 valx))
                                                                              (car _valy_92)
                                                                              (cdr _valy_92))
                                                                             (fail)))
                                                                       valx))
                                                                    (car valx)
                                                                    (cdr valx))
                                                                   (fail)))
                                                             (car valy)
                                                             (cdr valy))
                                                            (fail))
                                                        (fail)))
                                                  valx))
                                               (car _valy_77)
                                               (cdr _valy_77))
                                              (fail)))
                                        valx))
                                     (car valx)
                                     (cdr valx))
                                    (fail)))
                              (car valy)
                              (cdr valy))
                             (fail)))
                       valx))
                    (car vals)
                    (cdr vals))
                   (fail)))
             (lambda () (match-failure vals))))))
       matcher)
     args)))
(define
  trisort
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (pair? vals)
                   ((lambda
                      (valx valy)
                      (if (pair? valx)
                          ((lambda
                             (valx _valy_72)
                             (if (pair? _valy_72)
                                 ((lambda
                                    (valx _valy_74)
                                    ((lambda
                                       (y1)
                                       (if (null? _valy_74)
                                           (if (pair? valy)
                                               ((lambda
                                                  (valx valy)
                                                  (if (pair? valx)
                                                      ((lambda
                                                         (valx _valy_81)
                                                         (if (pair? _valy_81)
                                                             ((lambda
                                                                (valx _valy_83)
                                                                (if (if (number?
                                                                          valx)
                                                                        (< valx
                                                                           y1)
                                                                        #f)
                                                                    (if (null? _valy_83)
                                                                        (if (null? valy)
                                                                            #t
                                                                            (fail))
                                                                        (fail))
                                                                    (fail)))
                                                              (car _valy_81)
                                                              (cdr _valy_81))
                                                             (fail)))
                                                       (car valx)
                                                       (cdr valx))
                                                      (fail)))
                                                (car valy)
                                                (cdr valy))
                                               (fail))
                                           (fail)))
                                     valx))
                                  (car _valy_72)
                                  (cdr _valy_72))
                                 (fail)))
                           (car valx)
                           (cdr valx))
                          (fail)))
                    (car vals)
                    (cdr vals))
                   (fail)))
             (lambda
               ()
               ((lambda
                  (fail)
                  (if (pair? vals)
                      ((lambda
                         (valx valy)
                         (if (pair? valx)
                             ((lambda
                                (valx _valy_72)
                                ((lambda
                                   (x1)
                                   (if (pair? _valy_72)
                                       ((lambda
                                          (valx _valy_77)
                                          ((lambda
                                             (y1)
                                             (if (null? _valy_77)
                                                 (if (pair? valy)
                                                     ((lambda
                                                        (valx valy)
                                                        (if (pair? valx)
                                                            ((lambda
                                                               (valx _valy_85)
                                                               (if (if (number?
                                                                         valx)
                                                                       (> valx
                                                                          x1)
                                                                       #f)
                                                                   (if (pair? _valy_85)
                                                                       ((lambda
                                                                          (valx _valy_88)
                                                                          (if (if (number?
                                                                                    valx)
                                                                                  (= valx
                                                                                     y1)
                                                                                  #f)
                                                                              (if (null? _valy_88)
                                                                                  (if (null? valy)
                                                                                      #t
                                                                                      (fail))
                                                                                  (fail))
                                                                              (fail)))
                                                                        (car _valy_85)
                                                                        (cdr _valy_85))
                                                                       (fail))
                                                                   (fail)))
                                                             (car valx)
                                                             (cdr valx))
                                                            (fail)))
                                                      (car valy)
                                                      (cdr valy))
                                                     (fail))
                                                 (fail)))
                                           valx))
                                        (car _valy_72)
                                        (cdr _valy_72))
                                       (fail)))
                                 valx))
                              (car valx)
                              (cdr valx))
                             (fail)))
                       (car vals)
                       (cdr vals))
                      (fail)))
                (lambda () ((lambda ___ #f) vals))))))))
       matcher)
     args)))
(define
  split
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (pair? vals)
                   ((lambda
                      (valx valy)
                      ((lambda
                         (vert)
                         (if (pair? valy)
                             ((lambda
                                (valx valy)
                                (if (pair? valx)
                                    ((lambda
                                       (_valx_76 _valy_77)
                                       ((lambda
                                          (x1)
                                          (if (pair? _valy_77)
                                              ((lambda
                                                 (_valx_82 _valy_83)
                                                 ((lambda
                                                    (y1)
                                                    (if (null? _valy_83)
                                                        ((lambda
                                                           (p1)
                                                           (if (pair? valy)
                                                               ((lambda
                                                                  (valx valy)
                                                                  (if (pair? valx)
                                                                      ((lambda
                                                                         (_valx_92
                                                                           _valy_93)
                                                                         ((lambda
                                                                            (x2)
                                                                            (if (pair? _valy_93)
                                                                                ((lambda
                                                                                   (_valx_98
                                                                                     _valy_99)
                                                                                   ((lambda
                                                                                      (y2)
                                                                                      (if (null? _valy_99)
                                                                                          ((lambda
                                                                                             (p2)
                                                                                             (if (pair? valy)
                                                                                                 ((lambda
                                                                                                    (valx valy)
                                                                                                    (if (pair? valx)
                                                                                                        ((lambda
                                                                                                           (_valx_108
                                                                                                             _valy_109)
                                                                                                           ((lambda
                                                                                                              (x3)
                                                                                                              (if (pair? _valy_109)
                                                                                                                  ((lambda
                                                                                                                     (_valx_114
                                                                                                                       _valy_115)
                                                                                                                     ((lambda
                                                                                                                        (y3)
                                                                                                                        (if (null? _valy_115)
                                                                                                                            ((lambda
                                                                                                                               (p3)
                                                                                                                               (if (null? valy)
                                                                                                                                   ((lambda
                                                                                                                                      (a)
                                                                                                                                      ((lambda
                                                                                                                                         (b)
                                                                                                                                         (if vert
                                                                                                                                             (values
                                                                                                                                               x2
                                                                                                                                               (+ y3
                                                                                                                                                  (* a
                                                                                                                                                     (- x2
                                                                                                                                                        x3))))
                                                                                                                                             (values
                                                                                                                                               (/ (- y2
                                                                                                                                                     b)
                                                                                                                                                  a)
                                                                                                                                               y2)))
                                                                                                                                       (- y1
                                                                                                                                          (* a
                                                                                                                                             x1))))
                                                                                                                                    (/ (- y1
                                                                                                                                          y3)
                                                                                                                                       (- x1
                                                                                                                                          x3)))
                                                                                                                                   (fail)))
                                                                                                                             valx)
                                                                                                                            (fail)))
                                                                                                                      _valx_114))
                                                                                                                   (car _valy_109)
                                                                                                                   (cdr _valy_109))
                                                                                                                  (fail)))
                                                                                                            _valx_108))
                                                                                                         (car valx)
                                                                                                         (cdr valx))
                                                                                                        (fail)))
                                                                                                  (car valy)
                                                                                                  (cdr valy))
                                                                                                 (fail)))
                                                                                           valx)
                                                                                          (fail)))
                                                                                    _valx_98))
                                                                                 (car _valy_93)
                                                                                 (cdr _valy_93))
                                                                                (fail)))
                                                                          _valx_92))
                                                                       (car valx)
                                                                       (cdr valx))
                                                                      (fail)))
                                                                (car valy)
                                                                (cdr valy))
                                                               (fail)))
                                                         valx)
                                                        (fail)))
                                                  _valx_82))
                                               (car _valy_77)
                                               (cdr _valy_77))
                                              (fail)))
                                        _valx_76))
                                     (car valx)
                                     (cdr valx))
                                    (fail)))
                              (car valy)
                              (cdr valy))
                             (fail)))
                       valx))
                    (car vals)
                    (cdr vals))
                   (fail)))
             (lambda () (match-failure vals))))))
       matcher)
     args)))
(define
  small?
  (lambda
    args
    ((letrec
       ((matcher
          (lambda
            (vals)
            ((lambda
               (fail)
               (if (pair? vals)
                   ((lambda
                      (valx valy)
                      (if (pair? valx)
                          ((lambda
                             (_valx_71 _valy_72)
                             (if (pair? _valx_71)
                                 ((lambda
                                    (_valx_73 _valy_74)
                                    ((lambda
                                       (x1)
                                       (if (pair? _valy_74)
                                           ((lambda
                                              (_valx_78 _valy_79)
                                              ((lambda
                                                 (y1)
                                                 (if (null? _valy_79)
                                                     ((lambda
                                                        (p1)
                                                        (if (pair? _valy_72)
                                                            ((lambda
                                                               (_valx_85
                                                                 _valy_86)
                                                               (if (pair? _valx_85)
                                                                   ((lambda
                                                                      (_valx_87
                                                                        _valy_88)
                                                                      ((lambda
                                                                         (x2)
                                                                         (if (pair? _valy_88)
                                                                             ((lambda
                                                                                (_valx_92
                                                                                  _valy_93)
                                                                                ((lambda
                                                                                   (y2)
                                                                                   (if (null? _valy_93)
                                                                                       ((lambda
                                                                                          (p2)
                                                                                          (if (pair? _valy_86)
                                                                                              ((lambda
                                                                                                 (_valx_99
                                                                                                   _valy_100)
                                                                                                 (if (pair? _valx_99)
                                                                                                     ((lambda
                                                                                                        (_valx_101
                                                                                                          _valy_102)
                                                                                                        ((lambda
                                                                                                           (x3)
                                                                                                           (if (pair? _valy_102)
                                                                                                               ((lambda
                                                                                                                  (_valx_106
                                                                                                                    _valy_107)
                                                                                                                  ((lambda
                                                                                                                     (y3)
                                                                                                                     (if (null? _valy_107)
                                                                                                                         ((lambda
                                                                                                                            (p3)
                                                                                                                            (if (null? _valy_100)
                                                                                                                                ((lambda
                                                                                                                                   (t)
                                                                                                                                   (if (null? valy)
                                                                                                                                       ((lambda
                                                                                                                                          (dx1 dx2
                                                                                                                                               dx3
                                                                                                                                               dy1
                                                                                                                                               dy2
                                                                                                                                               dy3)
                                                                                                                                          (if (< dx1
                                                                                                                                                 0.01)
                                                                                                                                              (if (< dx2
                                                                                                                                                     0.01)
                                                                                                                                                  (if (< dx3
                                                                                                                                                         0.01)
                                                                                                                                                      (if (< dy1
                                                                                                                                                             0.01)
                                                                                                                                                          (if (< dy2
                                                                                                                                                                 0.01)
                                                                                                                                                              (< dy3
                                                                                                                                                                 0.01)
                                                                                                                                                              #f)
                                                                                                                                                          #f)
                                                                                                                                                      #f)
                                                                                                                                                  #f)
                                                                                                                                              #f))
                                                                                                                                        (abs (- x2
                                                                                                                                                x1))
                                                                                                                                        (abs (- x3
                                                                                                                                                x2))
                                                                                                                                        (abs (- x3
                                                                                                                                                x1))
                                                                                                                                        (abs (- y2
                                                                                                                                                y1))
                                                                                                                                        (abs (- y3
                                                                                                                                                y2))
                                                                                                                                        (abs (- y3
                                                                                                                                                y1)))
                                                                                                                                       (fail)))
                                                                                                                                 valx)
                                                                                                                                (fail)))
                                                                                                                          _valx_99)
                                                                                                                         (fail)))
                                                                                                                   _valx_106))
                                                                                                                (car _valy_102)
                                                                                                                (cdr _valy_102))
                                                                                                               (fail)))
                                                                                                         _valx_101))
                                                                                                      (car _valx_99)
                                                                                                      (cdr _valx_99))
                                                                                                     (fail)))
                                                                                               (car _valy_86)
                                                                                               (cdr _valy_86))
                                                                                              (fail)))
                                                                                        _valx_85)
                                                                                       (fail)))
                                                                                 _valx_92))
                                                                              (car _valy_88)
                                                                              (cdr _valy_88))
                                                                             (fail)))
                                                                       _valx_87))
                                                                    (car _valx_85)
                                                                    (cdr _valx_85))
                                                                   (fail)))
                                                             (car _valy_72)
                                                             (cdr _valy_72))
                                                            (fail)))
                                                      _valx_71)
                                                     (fail)))
                                               _valx_78))
                                            (car _valy_74)
                                            (cdr _valy_74))
                                           (fail)))
                                     _valx_73))
                                  (car _valx_71)
                                  (cdr _valx_71))
                                 (fail)))
                           (car valx)
                           (cdr valx))
                          (fail)))
                    (car vals)
                    (cdr vals))
                   (fail)))
             (lambda () ((lambda ___ #f) vals))))))
       matcher)
     args)))
(define
  decompose-div
  (lambda
    (t)
    (if (small? t)
        (list (cons :GE t))
        ((letrec
           ((matcher
              (lambda
                (vals)
                ((lambda
                   (fail)
                   (if (pair? vals)
                       ((lambda
                          (valx valy)
                          (if (pair? valx)
                              ((lambda
                                 (valx _valy_72)
                                 (if (pair? valx)
                                     ((lambda
                                        (_valx_73 _valy_74)
                                        ((lambda
                                           (x1)
                                           (if (pair? _valy_74)
                                               ((lambda
                                                  (_valx_78 _valy_79)
                                                  ((lambda
                                                     (y1)
                                                     (if (null? _valy_79)
                                                         ((lambda
                                                            (p1)
                                                            (if (pair? _valy_72)
                                                                ((lambda
                                                                   (valx _valy_86)
                                                                   (if (pair? valx)
                                                                       ((lambda
                                                                          (_valx_87
                                                                            _valy_88)
                                                                          ((lambda
                                                                             (x2)
                                                                             (if (pair? _valy_88)
                                                                                 ((lambda
                                                                                    (_valx_92
                                                                                      _valy_93)
                                                                                    ((lambda
                                                                                       (y2)
                                                                                       (if (null? _valy_93)
                                                                                           ((lambda
                                                                                              (p2)
                                                                                              (if (pair? _valy_86)
                                                                                                  ((lambda
                                                                                                     (valx _valy_100)
                                                                                                     (if (pair? valx)
                                                                                                         ((lambda
                                                                                                            (_valx_101
                                                                                                              _valy_102)
                                                                                                            ((lambda
                                                                                                               (x3)
                                                                                                               (if (pair? _valy_102)
                                                                                                                   ((lambda
                                                                                                                      (_valx_106
                                                                                                                        _valy_107)
                                                                                                                      ((lambda
                                                                                                                         (y3)
                                                                                                                         (if (null? _valy_107)
                                                                                                                             ((lambda
                                                                                                                                (p3)
                                                                                                                                (if (null? _valy_100)
                                                                                                                                    (if (null? valy)
                                                                                                                                        (if (= y1
                                                                                                                                               y2)
                                                                                                                                            (if (= x3
                                                                                                                                                   x1)
                                                                                                                                                (list (cons :UL
                                                                                                                                                            t))
                                                                                                                                                (if (= x3
                                                                                                                                                       x2)
                                                                                                                                                    (list (cons :UR
                                                                                                                                                                t))
                                                                                                                                                    (if (> x3
                                                                                                                                                           x2)
                                                                                                                                                        (call-with-values
                                                                                                                                                          (lambda
                                                                                                                                                            ()
                                                                                                                                                            (split #t
                                                                                                                                                                   p1
                                                                                                                                                                   p2
                                                                                                                                                                   p3))
                                                                                                                                                          (lambda
                                                                                                                                                            (x _x_114)
                                                                                                                                                            ((lambda
                                                                                                                                                               (x y)
                                                                                                                                                               (append
                                                                                                                                                                 (decompose-div
                                                                                                                                                                   (sort trisort
                                                                                                                                                                         (list p1
                                                                                                                                                                               p2
                                                                                                                                                                               (_list_33
                                                                                                                                                                                 x
                                                                                                                                                                                 y))))
                                                                                                                                                                 (decompose-div
                                                                                                                                                                   (sort trisort
                                                                                                                                                                         (list p2
                                                                                                                                                                               (_list_33
                                                                                                                                                                                 x
                                                                                                                                                                                 y)
                                                                                                                                                                               p3)))))
                                                                                                                                                             x
                                                                                                                                                             _x_114)))
                                                                                                                                                        (if (< x3
                                                                                                                                                               x1)
                                                                                                                                                            (call-with-values
                                                                                                                                                              (lambda
                                                                                                                                                                ()
                                                                                                                                                                (split #t
                                                                                                                                                                       p2
                                                                                                                                                                       p1
                                                                                                                                                                       p3))
                                                                                                                                                              (lambda
                                                                                                                                                                (x _x_114)
                                                                                                                                                                ((lambda
                                                                                                                                                                   (x y)
                                                                                                                                                                   (append
                                                                                                                                                                     (decompose-div
                                                                                                                                                                       (sort trisort
                                                                                                                                                                             (list p1
                                                                                                                                                                                   p2
                                                                                                                                                                                   (_list_33
                                                                                                                                                                                     x
                                                                                                                                                                                     y))))
                                                                                                                                                                     (decompose-div
                                                                                                                                                                       (sort trisort
                                                                                                                                                                             (list p1
                                                                                                                                                                                   (_list_33
                                                                                                                                                                                     x
                                                                                                                                                                                     y)
                                                                                                                                                                                   p3)))))
                                                                                                                                                                 x
                                                                                                                                                                 _x_114)))
                                                                                                                                                            (list (cons :UC
                                                                                                                                                                        t))))))
                                                                                                                                            (fail))
                                                                                                                                        (fail))
                                                                                                                                    (fail)))
                                                                                                                              valx)
                                                                                                                             (fail)))
                                                                                                                       _valx_106))
                                                                                                                    (car _valy_102)
                                                                                                                    (cdr _valy_102))
                                                                                                                   (fail)))
                                                                                                             _valx_101))
                                                                                                          (car valx)
                                                                                                          (cdr valx))
                                                                                                         (fail)))
                                                                                                   (car _valy_86)
                                                                                                   (cdr _valy_86))
                                                                                                  (fail)))
                                                                                            valx)
                                                                                           (fail)))
                                                                                     _valx_92))
                                                                                  (car _valy_88)
                                                                                  (cdr _valy_88))
                                                                                 (fail)))
                                                                           _valx_87))
                                                                        (car valx)
                                                                        (cdr valx))
                                                                       (fail)))
                                                                 (car _valy_72)
                                                                 (cdr _valy_72))
                                                                (fail)))
                                                          valx)
                                                         (fail)))
                                                   _valx_78))
                                                (car _valy_74)
                                                (cdr _valy_74))
                                               (fail)))
                                         _valx_73))
                                      (car valx)
                                      (cdr valx))
                                     (fail)))
                               (car valx)
                               (cdr valx))
                              (fail)))
                        (car vals)
                        (cdr vals))
                       (fail)))
                 (lambda
                   ()
                   ((lambda
                      (fail)
                      (if (pair? vals)
                          ((lambda
                             (valx valy)
                             (if (pair? valx)
                                 ((lambda
                                    (valx _valy_72)
                                    (if (pair? valx)
                                        ((lambda
                                           (_valx_73 _valy_74)
                                           ((lambda
                                              (x1)
                                              (if (pair? _valy_74)
                                                  ((lambda
                                                     (_valx_78 _valy_79)
                                                     ((lambda
                                                        (y1)
                                                        (if (null? _valy_79)
                                                            ((lambda
                                                               (p1)
                                                               (if (pair? _valy_72)
                                                                   ((lambda
                                                                      (valx _valy_86)
                                                                      (if (pair? valx)
                                                                          ((lambda
                                                                             (_valx_87
                                                                               _valy_88)
                                                                             ((lambda
                                                                                (x2)
                                                                                (if (pair? _valy_88)
                                                                                    ((lambda
                                                                                       (_valx_92
                                                                                         _valy_93)
                                                                                       ((lambda
                                                                                          (y2)
                                                                                          (if (null? _valy_93)
                                                                                              ((lambda
                                                                                                 (p2)
                                                                                                 (if (pair? _valy_86)
                                                                                                     ((lambda
                                                                                                        (valx _valy_100)
                                                                                                        (if (pair? valx)
                                                                                                            ((lambda
                                                                                                               (_valx_101
                                                                                                                 _valy_102)
                                                                                                               ((lambda
                                                                                                                  (x3)
                                                                                                                  (if (pair? _valy_102)
                                                                                                                      ((lambda
                                                                                                                         (_valx_106
                                                                                                                           _valy_107)
                                                                                                                         ((lambda
                                                                                                                            (y3)
                                                                                                                            (if (null? _valy_107)
                                                                                                                                ((lambda
                                                                                                                                   (p3)
                                                                                                                                   (if (null? _valy_100)
                                                                                                                                       (if (null? valy)
                                                                                                                                           (if (= y2
                                                                                                                                                  y3)
                                                                                                                                               (if (= x1
                                                                                                                                                      x2)
                                                                                                                                                   (list (cons :DL
                                                                                                                                                               t))
                                                                                                                                                   (if (= x1
                                                                                                                                                          x3)
                                                                                                                                                       (list (cons :DR
                                                                                                                                                                   t))
                                                                                                                                                       (if (> x1
                                                                                                                                                              x3)
                                                                                                                                                           (call-with-values
                                                                                                                                                             (lambda
                                                                                                                                                               ()
                                                                                                                                                               (split #t
                                                                                                                                                                      p1
                                                                                                                                                                      p3
                                                                                                                                                                      p2))
                                                                                                                                                             (lambda
                                                                                                                                                               (x _x_114)
                                                                                                                                                               ((lambda
                                                                                                                                                                  (x y)
                                                                                                                                                                  (append
                                                                                                                                                                    (decompose-div
                                                                                                                                                                      (sort trisort
                                                                                                                                                                            (list p1
                                                                                                                                                                                  (_list_33
                                                                                                                                                                                    x
                                                                                                                                                                                    y)
                                                                                                                                                                                  p3)))
                                                                                                                                                                    (decompose-div
                                                                                                                                                                      (sort trisort
                                                                                                                                                                            (list (_list_33
                                                                                                                                                                                    x
                                                                                                                                                                                    y)
                                                                                                                                                                                  p2
                                                                                                                                                                                  p3)))))
                                                                                                                                                                x
                                                                                                                                                                _x_114)))
                                                                                                                                                           (if (< x1
                                                                                                                                                                  x2)
                                                                                                                                                               (call-with-values
                                                                                                                                                                 (lambda
                                                                                                                                                                   ()
                                                                                                                                                                   (split #t
                                                                                                                                                                          p1
                                                                                                                                                                          p2
                                                                                                                                                                          p3))
                                                                                                                                                                 (lambda
                                                                                                                                                                   (x _x_114)
                                                                                                                                                                   ((lambda
                                                                                                                                                                      (x y)
                                                                                                                                                                      (append
                                                                                                                                                                        (decompose-div
                                                                                                                                                                          (sort trisort
                                                                                                                                                                                (list p1
                                                                                                                                                                                      (_list_33
                                                                                                                                                                                        x
                                                                                                                                                                                        y)
                                                                                                                                                                                      p2)))
                                                                                                                                                                        (decompose-div
                                                                                                                                                                          (sort trisort
                                                                                                                                                                                (list (_list_33
                                                                                                                                                                                        x
                                                                                                                                                                                        y)
                                                                                                                                                                                      p2
                                                                                                                                                                                      p3)))))
                                                                                                                                                                    x
                                                                                                                                                                    _x_114)))
                                                                                                                                                               (list (cons :DC
                                                                                                                                                                           t))))))
                                                                                                                                               (fail))
                                                                                                                                           (fail))
                                                                                                                                       (fail)))
                                                                                                                                 valx)
                                                                                                                                (fail)))
                                                                                                                          _valx_106))
                                                                                                                       (car _valy_102)
                                                                                                                       (cdr _valy_102))
                                                                                                                      (fail)))
                                                                                                                _valx_101))
                                                                                                             (car valx)
                                                                                                             (cdr valx))
                                                                                                            (fail)))
                                                                                                      (car _valy_86)
                                                                                                      (cdr _valy_86))
                                                                                                     (fail)))
                                                                                               valx)
                                                                                              (fail)))
                                                                                        _valx_92))
                                                                                     (car _valy_88)
                                                                                     (cdr _valy_88))
                                                                                    (fail)))
                                                                              _valx_87))
                                                                           (car valx)
                                                                           (cdr valx))
                                                                          (fail)))
                                                                    (car _valy_72)
                                                                    (cdr _valy_72))
                                                                   (fail)))
                                                             valx)
                                                            (fail)))
                                                      _valx_78))
                                                   (car _valy_74)
                                                   (cdr _valy_74))
                                                  (fail)))
                                            _valx_73))
                                         (car valx)
                                         (cdr valx))
                                        (fail)))
                                  (car valx)
                                  (cdr valx))
                                 (fail)))
                           (car vals)
                           (cdr vals))
                          (fail)))
                    (lambda
                      ()
                      ((lambda
                         (fail)
                         (if (pair? vals)
                             ((lambda
                                (valx valy)
                                (if (pair? valx)
                                    ((lambda
                                       (valx _valy_72)
                                       (if (pair? valx)
                                           ((lambda
                                              (_valx_73 _valy_74)
                                              ((lambda
                                                 (x1)
                                                 (if (pair? _valy_74)
                                                     ((lambda
                                                        (_valx_78 _valy_79)
                                                        ((lambda
                                                           (y1)
                                                           (if (null? _valy_79)
                                                               ((lambda
                                                                  (p1)
                                                                  (if (pair? _valy_72)
                                                                      ((lambda
                                                                         (valx _valy_86)
                                                                         (if (pair? valx)
                                                                             ((lambda
                                                                                (_valx_87
                                                                                  _valy_88)
                                                                                ((lambda
                                                                                   (x2)
                                                                                   (if (pair? _valy_88)
                                                                                       ((lambda
                                                                                          (_valx_92
                                                                                            _valy_93)
                                                                                          ((lambda
                                                                                             (y2)
                                                                                             (if (null? _valy_93)
                                                                                                 ((lambda
                                                                                                    (p2)
                                                                                                    (if (pair? _valy_86)
                                                                                                        ((lambda
                                                                                                           (valx _valy_100)
                                                                                                           (if (pair? valx)
                                                                                                               ((lambda
                                                                                                                  (_valx_101
                                                                                                                    _valy_102)
                                                                                                                  ((lambda
                                                                                                                     (x3)
                                                                                                                     (if (pair? _valy_102)
                                                                                                                         ((lambda
                                                                                                                            (_valx_106
                                                                                                                              _valy_107)
                                                                                                                            ((lambda
                                                                                                                               (y3)
                                                                                                                               (if (null? _valy_107)
                                                                                                                                   ((lambda
                                                                                                                                      (p3)
                                                                                                                                      (if (null? _valy_100)
                                                                                                                                          (if (null? valy)
                                                                                                                                              (if (if (= x1
                                                                                                                                                         x3)
                                                                                                                                                      (if (>= x2
                                                                                                                                                              x1)
                                                                                                                                                          (if (< y2
                                                                                                                                                                 y1)
                                                                                                                                                              (< y3
                                                                                                                                                                 y2)
                                                                                                                                                              #f)
                                                                                                                                                          #f)
                                                                                                                                                      #f)
                                                                                                                                                  (list (cons :LC
                                                                                                                                                              t))
                                                                                                                                                  (if (if (= x1
                                                                                                                                                             x3)
                                                                                                                                                          (if (<= x2
                                                                                                                                                                  x1)
                                                                                                                                                              (if (< y2
                                                                                                                                                                     y1)
                                                                                                                                                                  (< y3
                                                                                                                                                                     y2)
                                                                                                                                                                  #f)
                                                                                                                                                              #f)
                                                                                                                                                          #f)
                                                                                                                                                      (list (cons :RC
                                                                                                                                                                  t))
                                                                                                                                                      (call-with-values
                                                                                                                                                        (lambda
                                                                                                                                                          ()
                                                                                                                                                          (apply split
                                                                                                                                                                 #f
                                                                                                                                                                 t))
                                                                                                                                                        (lambda
                                                                                                                                                          (x _x_114)
                                                                                                                                                          ((lambda
                                                                                                                                                             (x y)
                                                                                                                                                             (append
                                                                                                                                                               (decompose-div
                                                                                                                                                                 (sort trisort
                                                                                                                                                                       (list p1
                                                                                                                                                                             p2
                                                                                                                                                                             (_list_33
                                                                                                                                                                               x
                                                                                                                                                                               y))))
                                                                                                                                                               (decompose-div
                                                                                                                                                                 (sort trisort
                                                                                                                                                                       (list (_list_33
                                                                                                                                                                               x
                                                                                                                                                                               y)
                                                                                                                                                                             p2
                                                                                                                                                                             p3)))))
                                                                                                                                                           x
                                                                                                                                                           _x_114)))))
                                                                                                                                              (fail))
                                                                                                                                          (fail)))
                                                                                                                                    valx)
                                                                                                                                   (fail)))
                                                                                                                             _valx_106))
                                                                                                                          (car _valy_102)
                                                                                                                          (cdr _valy_102))
                                                                                                                         (fail)))
                                                                                                                   _valx_101))
                                                                                                                (car valx)
                                                                                                                (cdr valx))
                                                                                                               (fail)))
                                                                                                         (car _valy_86)
                                                                                                         (cdr _valy_86))
                                                                                                        (fail)))
                                                                                                  valx)
                                                                                                 (fail)))
                                                                                           _valx_92))
                                                                                        (car _valy_88)
                                                                                        (cdr _valy_88))
                                                                                       (fail)))
                                                                                 _valx_87))
                                                                              (car valx)
                                                                              (cdr valx))
                                                                             (fail)))
                                                                       (car _valy_72)
                                                                       (cdr _valy_72))
                                                                      (fail)))
                                                                valx)
                                                               (fail)))
                                                         _valx_78))
                                                      (car _valy_74)
                                                      (cdr _valy_74))
                                                     (fail)))
                                               _valx_73))
                                            (car valx)
                                            (cdr valx))
                                           (fail)))
                                     (car valx)
                                     (cdr valx))
                                    (fail)))
                              (car vals)
                              (cdr vals))
                             (fail)))
                       (lambda () (match-failure vals))))))))))
           matcher)
         (list t)))))
(define
  decompose
  (lambda
    (t)
    (if (small? t)
        (list (cons :GE t))
        ((letrec
           ((matcher
              (lambda
                (vals)
                ((lambda
                   (fail)
                   (if (pair? vals)
                       ((lambda
                          (valx valy)
                          (if (pair? valx)
                              ((lambda
                                 (valx _valy_72)
                                 (if (pair? valx)
                                     ((lambda
                                        (_valx_73 _valy_74)
                                        ((lambda
                                           (x1)
                                           (if (pair? _valy_74)
                                               ((lambda
                                                  (_valx_78 _valy_79)
                                                  ((lambda
                                                     (y1)
                                                     (if (null? _valy_79)
                                                         ((lambda
                                                            (p1)
                                                            (if (pair? _valy_72)
                                                                ((lambda
                                                                   (valx _valy_86)
                                                                   (if (pair? valx)
                                                                       ((lambda
                                                                          (_valx_87
                                                                            _valy_88)
                                                                          ((lambda
                                                                             (x2)
                                                                             (if (pair? _valy_88)
                                                                                 ((lambda
                                                                                    (_valx_92
                                                                                      _valy_93)
                                                                                    ((lambda
                                                                                       (y2)
                                                                                       (if (null? _valy_93)
                                                                                           ((lambda
                                                                                              (p2)
                                                                                              (if (pair? _valy_86)
                                                                                                  ((lambda
                                                                                                     (valx _valy_100)
                                                                                                     (if (pair? valx)
                                                                                                         ((lambda
                                                                                                            (_valx_101
                                                                                                              _valy_102)
                                                                                                            ((lambda
                                                                                                               (x3)
                                                                                                               (if (pair? _valy_102)
                                                                                                                   ((lambda
                                                                                                                      (_valx_106
                                                                                                                        _valy_107)
                                                                                                                      ((lambda
                                                                                                                         (y3)
                                                                                                                         (if (null? _valy_107)
                                                                                                                             ((lambda
                                                                                                                                (p3)
                                                                                                                                (if (null? _valy_100)
                                                                                                                                    (if (null? valy)
                                                                                                                                        (if (if (= y1
                                                                                                                                                   y2)
                                                                                                                                                (= x3
                                                                                                                                                   x1)
                                                                                                                                                #f)
                                                                                                                                            (list (cons :UL
                                                                                                                                                        t))
                                                                                                                                            (if (if (= y1
                                                                                                                                                       y2)
                                                                                                                                                    (= x3
                                                                                                                                                       x2)
                                                                                                                                                    #f)
                                                                                                                                                (list (cons :UR
                                                                                                                                                            t))
                                                                                                                                                (if (if (= y1
                                                                                                                                                           y2)
                                                                                                                                                        (> x3
                                                                                                                                                           x2)
                                                                                                                                                        #f)
                                                                                                                                                    (call-with-values
                                                                                                                                                      (lambda
                                                                                                                                                        ()
                                                                                                                                                        (split #t
                                                                                                                                                               p1
                                                                                                                                                               p2
                                                                                                                                                               p3))
                                                                                                                                                      (lambda
                                                                                                                                                        (x _x_114)
                                                                                                                                                        ((lambda
                                                                                                                                                           (x y)
                                                                                                                                                           (append
                                                                                                                                                             (decompose
                                                                                                                                                               (sort trisort
                                                                                                                                                                     (list p1
                                                                                                                                                                           p2
                                                                                                                                                                           (_list_33
                                                                                                                                                                             x
                                                                                                                                                                             y))))
                                                                                                                                                             (decompose
                                                                                                                                                               (sort trisort
                                                                                                                                                                     (list p2
                                                                                                                                                                           (_list_33
                                                                                                                                                                             x
                                                                                                                                                                             y)
                                                                                                                                                                           p3)))))
                                                                                                                                                         x
                                                                                                                                                         _x_114)))
                                                                                                                                                    (if (if (= y1
                                                                                                                                                               y2)
                                                                                                                                                            (< x3
                                                                                                                                                               x1)
                                                                                                                                                            #f)
                                                                                                                                                        (call-with-values
                                                                                                                                                          (lambda
                                                                                                                                                            ()
                                                                                                                                                            (split #t
                                                                                                                                                                   p2
                                                                                                                                                                   p1
                                                                                                                                                                   p3))
                                                                                                                                                          (lambda
                                                                                                                                                            (x _x_114)
                                                                                                                                                            ((lambda
                                                                                                                                                               (x y)
                                                                                                                                                               (append
                                                                                                                                                                 (decompose
                                                                                                                                                                   (sort trisort
                                                                                                                                                                         (list p1
                                                                                                                                                                               p2
                                                                                                                                                                               (_list_33
                                                                                                                                                                                 x
                                                                                                                                                                                 y))))
                                                                                                                                                                 (decompose
                                                                                                                                                                   (sort trisort
                                                                                                                                                                         (list p1
                                                                                                                                                                               (_list_33
                                                                                                                                                                                 x
                                                                                                                                                                                 y)
                                                                                                                                                                               p3)))))
                                                                                                                                                             x
                                                                                                                                                             _x_114)))
                                                                                                                                                        (if (= y1
                                                                                                                                                               y2)
                                                                                                                                                            (list (cons :UC
                                                                                                                                                                        t))
                                                                                                                                                            (if (if (= y2
                                                                                                                                                                       y3)
                                                                                                                                                                    (= x1
                                                                                                                                                                       x2)
                                                                                                                                                                    #f)
                                                                                                                                                                (list (cons :DL
                                                                                                                                                                            t))
                                                                                                                                                                (if (if (= y2
                                                                                                                                                                           y3)
                                                                                                                                                                        (= x1
                                                                                                                                                                           x3)
                                                                                                                                                                        #f)
                                                                                                                                                                    (list (cons :DR
                                                                                                                                                                                t))
                                                                                                                                                                    (if (if (= y2
                                                                                                                                                                               y3)
                                                                                                                                                                            (> x1
                                                                                                                                                                               x3)
                                                                                                                                                                            #f)
                                                                                                                                                                        (call-with-values
                                                                                                                                                                          (lambda
                                                                                                                                                                            ()
                                                                                                                                                                            (split #t
                                                                                                                                                                                   p1
                                                                                                                                                                                   p3
                                                                                                                                                                                   p2))
                                                                                                                                                                          (lambda
                                                                                                                                                                            (x _x_114)
                                                                                                                                                                            ((lambda
                                                                                                                                                                               (x y)
                                                                                                                                                                               (append
                                                                                                                                                                                 (decompose
                                                                                                                                                                                   (sort trisort
                                                                                                                                                                                         (list p1
                                                                                                                                                                                               (_list_33
                                                                                                                                                                                                 x
                                                                                                                                                                                                 y)
                                                                                                                                                                                               p3)))
                                                                                                                                                                                 (decompose
                                                                                                                                                                                   (sort trisort
                                                                                                                                                                                         (list (_list_33
                                                                                                                                                                                                 x
                                                                                                                                                                                                 y)
                                                                                                                                                                                               p2
                                                                                                                                                                                               p3)))))
                                                                                                                                                                             x
                                                                                                                                                                             _x_114)))
                                                                                                                                                                        (if (if (= y2
                                                                                                                                                                                   y3)
                                                                                                                                                                                (< x1
                                                                                                                                                                                   x2)
                                                                                                                                                                                #f)
                                                                                                                                                                            (call-with-values
                                                                                                                                                                              (lambda
                                                                                                                                                                                ()
                                                                                                                                                                                (split #t
                                                                                                                                                                                       p1
                                                                                                                                                                                       p2
                                                                                                                                                                                       p3))
                                                                                                                                                                              (lambda
                                                                                                                                                                                (x _x_114)
                                                                                                                                                                                ((lambda
                                                                                                                                                                                   (x y)
                                                                                                                                                                                   (append
                                                                                                                                                                                     (decompose
                                                                                                                                                                                       (sort trisort
                                                                                                                                                                                             (list p1
                                                                                                                                                                                                   (_list_33
                                                                                                                                                                                                     x
                                                                                                                                                                                                     y)
                                                                                                                                                                                                   p2)))
                                                                                                                                                                                     (decompose
                                                                                                                                                                                       (sort trisort
                                                                                                                                                                                             (list (_list_33
                                                                                                                                                                                                     x
                                                                                                                                                                                                     y)
                                                                                                                                                                                                   p2
                                                                                                                                                                                                   p3)))))
                                                                                                                                                                                 x
                                                                                                                                                                                 _x_114)))
                                                                                                                                                                            (if (= y2
                                                                                                                                                                                   y3)
                                                                                                                                                                                (list (cons :DC
                                                                                                                                                                                            t))
                                                                                                                                                                                (if (if (= x1
                                                                                                                                                                                           x3)
                                                                                                                                                                                        (if (>= x2
                                                                                                                                                                                                x1)
                                                                                                                                                                                            (if (< y2
                                                                                                                                                                                                   y1)
                                                                                                                                                                                                (< y3
                                                                                                                                                                                                   y2)
                                                                                                                                                                                                #f)
                                                                                                                                                                                            #f)
                                                                                                                                                                                        #f)
                                                                                                                                                                                    (list (cons :LC
                                                                                                                                                                                                t))
                                                                                                                                                                                    (if (if (= x1
                                                                                                                                                                                               x3)
                                                                                                                                                                                            (if (<= x2
                                                                                                                                                                                                    x1)
                                                                                                                                                                                                (if (< y2
                                                                                                                                                                                                       y1)
                                                                                                                                                                                                    (< y3
                                                                                                                                                                                                       y2)
                                                                                                                                                                                                    #f)
                                                                                                                                                                                                #f)
                                                                                                                                                                                            #f)
                                                                                                                                                                                        (list (cons :RC
                                                                                                                                                                                                    t))
                                                                                                                                                                                        (call-with-values
                                                                                                                                                                                          (lambda
                                                                                                                                                                                            ()
                                                                                                                                                                                            (apply split
                                                                                                                                                                                                   #f
                                                                                                                                                                                                   t))
                                                                                                                                                                                          (lambda
                                                                                                                                                                                            (x _x_114)
                                                                                                                                                                                            ((lambda
                                                                                                                                                                                               (x y)
                                                                                                                                                                                               (append
                                                                                                                                                                                                 (decompose
                                                                                                                                                                                                   (sort trisort
                                                                                                                                                                                                         (list p1
                                                                                                                                                                                                               p2
                                                                                                                                                                                                               (_list_33
                                                                                                                                                                                                                 x
                                                                                                                                                                                                                 y))))
                                                                                                                                                                                                 (decompose
                                                                                                                                                                                                   (sort trisort
                                                                                                                                                                                                         (list (_list_33
                                                                                                                                                                                                                 x
                                                                                                                                                                                                                 y)
                                                                                                                                                                                                               p2
                                                                                                                                                                                                               p3)))))
                                                                                                                                                                                             x
                                                                                                                                                                                             _x_114)))))))))))))))
                                                                                                                                        (fail))
                                                                                                                                    (fail)))
                                                                                                                              valx)
                                                                                                                             (fail)))
                                                                                                                       _valx_106))
                                                                                                                    (car _valy_102)
                                                                                                                    (cdr _valy_102))
                                                                                                                   (fail)))
                                                                                                             _valx_101))
                                                                                                          (car valx)
                                                                                                          (cdr valx))
                                                                                                         (fail)))
                                                                                                   (car _valy_86)
                                                                                                   (cdr _valy_86))
                                                                                                  (fail)))
                                                                                            valx)
                                                                                           (fail)))
                                                                                     _valx_92))
                                                                                  (car _valy_88)
                                                                                  (cdr _valy_88))
                                                                                 (fail)))
                                                                           _valx_87))
                                                                        (car valx)
                                                                        (cdr valx))
                                                                       (fail)))
                                                                 (car _valy_72)
                                                                 (cdr _valy_72))
                                                                (fail)))
                                                          valx)
                                                         (fail)))
                                                   _valx_78))
                                                (car _valy_74)
                                                (cdr _valy_74))
                                               (fail)))
                                         _valx_73))
                                      (car valx)
                                      (cdr valx))
                                     (fail)))
                               (car valx)
                               (cdr valx))
                              (fail)))
                        (car vals)
                        (cdr vals))
                       (fail)))
                 (lambda () (match-failure vals))))))
           matcher)
         (list t)))))
