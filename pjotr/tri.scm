#! /usr/bin/env bgl
(module tri
   (library srfi1)
   (cond-expand (bigloo-eval (import (helpers "helpers.scm"))))
   (export string->point
           tri->svg
	   decompose
	   trisort
	   normalize
	   random-color
	   tri->div
	   translate
	   normalizes
	   coord-x coord-y
	   min-x min-y
	   min-xs min-ys))

(load "synrules.sch")
(load "dodger.sch")
(load "cases.scm")
(load "debug.scm")
(load "forall.scm")
(load "helpers.scm")

; "{x,y}" format
(def (string->point s)
   (map string->number
      (string-split
	 (substring s 1 (- (string-length s) 1)) ", ")
      ))

; 24-bit depth
(def (random-color)
   (apply string-append "#"
      (map (fn _ => (integer->string/padding (random 256) 2 16))
	 (iota 3))
      ))

(def zx 600)
(def zy 300)
(def (sizex x) (* x zx))
(def (sizey y) (* y zy))
(def (size-x x) (number->string (sizex x)))
(def (size-y y) (number->string (sizey y)))
(def (coord-x x) (number->string (+ 160 (sizex x))))
(def (coord-y y) (number->string (- 350 (sizey y))))
(def (coord-x' x) (number->string (+ 0 (* x 100))))
(def (coord-y' y) (number->string (- 100 (* y 100))))

(def translate (fn. dx dy [tag (x1 y1) (x2 y2) (x3 y3)] ->
		          [,tag (,(+ x1 dx) ,(+ y1 dy))
			        (,(+ x2 dx) ,(+ y2 dy))
			        (,(+ x3 dx) ,(+ y3 dy))]
			  ))

(def maxx (fn x2 (x1 _) => (max x1 x2)))
(def minx (fn x2 (x1 _) => (min x1 x2)))
(def maxy (fn y2 (_ y1) => (max y1 y2)))
(def miny (fn y2 (_ y1) => (min y1 y2)))

(def flip (fn. f x y => (f y x)))

; hop doesn't know +inf.0 and -inf.0
(def-syntax +inf0 10000);+inf.0)
(def-syntax -inf0 -10000);-inf.0)

(def min-x [fold (flip minx) +inf0 <>])
(def max-x [fold (flip maxx) -inf0 <>])
(def min-y [fold (flip miny) +inf0 <>])
(def max-y [fold (flip maxy) -inf0 <>])

; srfi1's fold-left is flipped
(def normalize (fn t =>
  (let ([mx (min-x t)]
	[my (min-y t)]
	[xm (max-x t)]
	[ym (max-y t)])
     (let ([rx (- xm mx)]
	   [ry (- ym my)])
	(map (fn (x y) -> (,(/ (- x mx) rx)
			   ,(/ (- y my) ry)))
	   t)
	))))

(def (min-xs ts) (reduce min +inf0 (map min-x (map cdr ts))))
(def (max-xs ts) (reduce max -inf0 (map max-x (map cdr ts))))
(def (min-ys ts) (reduce min +inf0 (map min-y (map cdr ts))))
(def (max-ys ts) (reduce max -inf0 (map max-y (map cdr ts))))

(def (normalizes ts)
  (let ([mx (min-xs ts)]
	[my (min-ys ts)]
	[xm (max-xs ts)]
	[ym (max-ys ts)])
     ;(printf "~a ~a ~a ~a~n" mx my xm ym)
     (let ([rx (- xm mx)]
	   [ry (- ym my)])
	((zip-with cons)
	 (map car ts)
	 (map (compose
		 [map (fn (x y) -> (,(/ (- x mx) rx)
				    ,(/ (- y my) ry)))
		    <>]
		 cdr) ts)
	 )
	)))

(def (tri->div ax ay . t) `(<DIV> style: ,(string-append
  "width:0;"
  "height:0;"
  "position:absolute;"
  "left:" (coord-x (+ ax (min-x (cdr t)))) "px;"
  "top:"  (coord-y (+ ay (max-y (cdr t)))) "px;"
  (apply (fn
  || GE: points ... -> "" ; hide non-representable triangles
  || UL: (x1 y1) (x2 y2) (x3 y3) =>
     (let ([bx (size-x (/ (- x2 x1) 2))]
	    [by (size-y (/ (- y1 y3) 2))]
	    [co (random-color)])
	 (string-append
	"border-top:" by "px solid " co ";"
	"border-left:" bx "px solid " co ";"
	"border-right:" bx "px solid transparent;"
	"border-bottom:" by "px solid transparent;"
	))
  || UR: (x1 y1) (x2 y2) (x3 y3) =>
     (let ([bx (size-x (/ (- x2 x1) 2))]
	    [by (size-y (/ (- y1 y3) 2))]
	    [co (random-color)])
	 (string-append
	"border-top:" by "px solid " co ";"
	"border-left:" bx "px solid transparent;"
	"border-right:" bx "px solid " co ";"
	"border-bottom:" by "px solid transparent;"
	))
  || UC: (x1 y1) (x2 y2) (x3 y3) =>
     (let ([br (size-x (- x2 x3))]
	    [bl (size-x (- x3 x1))]
	    [by (size-y (- y1 y3))]
	    [co (random-color)])
	 (string-append
	"border-top:" by "px solid " co ";"
	"border-left:" bl "px solid transparent;"
	"border-right:" br "px solid transparent;"
	"border-bottom:" "0" "px solid transparent;"
	))
  || DL: (x1 y1) (x2 y2) (x3 y3) =>
     (let ([bx (size-x (/ (- x3 x2) 2))]
	    [by (size-y (/ (- y1 y2) 2))]
	    [co (random-color)])
	 (string-append
	"border-top:" by "px solid transparent;"
	"border-left:" bx "px solid " co ";"
	"border-right:" bx "px solid transparent;"
	"border-bottom:" by "px solid " co ";"
	))
  || DR: (x1 y1) (x2 y2) (x3 y3) =>
     (let ([bx (size-x (/ (- x3 x2) 2))]
	    [by (size-y (/ (- y1 y2) 2))]
	    [co (random-color)])
	 (string-append
	"border-top:" by "px solid transparent;"
	"border-left:" bx "px solid transparent;"
	"border-right:" bx "px solid " co ";"
	"border-bottom:" by "px solid " co ";"
	))
  || DC: (x1 y1) (x2 y2) (x3 y3) =>
     (let ([br (size-x (- x3 x1))]
	    [bl (size-x (- x1 x2))]
	    [by (size-y (- y1 y3))]
	    [co (random-color)])
	 (string-append
	"border-top:" "0" "px solid transparent;"
	"border-left:" bl "px solid transparent;"
	"border-right:" br "px solid transparent;"
	"border-bottom:" by "px solid " co ";"
	))     
  || LC: (x1 y1) (x2 y2) (x3 y3) =>
     (let ([bt (size-y (- y1 y2))]
	    [bb (size-y (- y2 y3))]
	    [bx (size-x (- x2 x1))]
	    [co (random-color)])
	 (string-append
	"border-top:" bt "px solid transparent;"
	"border-left:" bx "px solid " co ";"
	"border-right:" "0" "px solid transparent;"
	"border-bottom:" bb  "px solid transparent;"
	))     
  || RC: (x1 y1) (x2 y2) (x3 y3) =>
     (let ([bt (size-y (- y1 y2))]
	    [bb (size-y (- y2 y3))]
	    [bx (size-x (- x1 x2))]
	    [co (random-color)])
	 (string-append
	"border-top:" bt "px solid transparent;"
	"border-left:" "0" "px solid transparent;"
	"border-right:" bx "px solid " co ";"
	"border-bottom:" bb  "px solid transparent;"
	))
  ) t))))

; SVG can handle any triangles
(def tri->svg (fn tag (x1 y1) (x2 y2) (x3 y3) ->
  (<SVG:PATH> fill: (random-color) stroke: 'black
   d: ,(format "M ~a ~a L ~a ~a L ~a ~a Z"
       (coord-x' x1) (coord-y' y1)
       (coord-x' x2) (coord-y' y2)
       (coord-x' x3) (coord-y' y3))
     )))

; sort on y-coordinate, and then on x-coordinate
(def trisort (fun (_ y1) (_ [_ < y1]) => #true
               || (x1 y1) ([_ > x1] [_ = y1]) => #true))

; always split from the p2
(def split (fn vert ((x1 y1) as p1) ((x2 y2) as p2) ((x3 y3) as p3) =>
   (let* ([a (/ (- y1 y3) (- x1 x3))]
	  [b (- y1 (* a x1))])
      ;(printf "~a ~a ~a a=~a b=~a~n" p1 p2 p3 a b)
      (if vert (values x2 (+ y3 (* a (- x2 x3))))
	       (values (/ (- y2 b) a) y2))
      )))

(def small? (fun ([((x1 y1) as p1) ((x2 y2) as p2) ((x3 y3) as p3)] as t) =>
	;(printf "~a ~a ~a ~a ~a ~a~n" x1 x2 x3 y1 y2 y3)
	(let ([dx1 (abs (- x2 x1))]
	      [dx2 (abs (- x3 x2))]
	      [dx3 (abs (- x3 x1))]
	      [dy1 (abs (- y2 y1))]
	      [dy2 (abs (- y3 y2))]
	      [dy3 (abs (- y3 y1))])
	   ;(printf "~a ~a ~a ~a ~a ~a~n" dx1 dx2 dx3 dy1 dy2 dy3)
	   (and (< dx1 0.01) (< dx2 0.01) (< dx3 0.01)
		(< dy1 0.01) (< dy2 0.01) (< dy3 0.01)
		))))
	      
(def (decompose t) ; and tag
 (if (small? t) (list (cons GE: t))
   (cases t || [((x1 y1) as p1) ((x2 y2) as p2) ((x3 y3) as p3)] =>
      (cond
	 ; top
	 ((and (= y1 y2) [= x3 x1]) (list (cons UL: t))) ; UL
	 ((and (= y1 y2) [= x3 x2]) (list (cons UR: t))) ; UR
	 ((and (= y1 y2) [> x3 x2])
	  (let-values ([(x y) (split #true p1 p2 p3)])
	     (append ;'TOP
		(decompose (sort trisort (list p1 p2 `(,x ,y))))
		(decompose (sort trisort (list p2 `(,x ,y) p3))))
	     ))
	 ((and (= y1 y2) [< x3 x1])
	  (let-values ([(x y) (split #true p2 p1 p3)])
	     (append ;'TOP
		(decompose (sort trisort (list p1 p2 `(,x ,y))))
		(decompose (sort trisort (list p1 `(,x ,y) p3))))
	     ))
	 ;((= y1 y2) (list (cons UC: t))) ; UC
	 ((= y1 y2)
 	  (let-values ([(x y) (split #true p1 p3 p2)])
	     (append ;'BOT
		(decompose (sort trisort (list p1 `(,x ,y) p3)))
		(decompose (sort trisort (list `(,x ,y) p3 p2))))
	     ))
	 ; bot
	 ((and (= y2 y3) [= x1 x2]) (list (cons DL: t))) ; DL
	 ((and (= y2 y3) [= x1 x3]) (list (cons DR: t))) ; DR
	 ((and (= y2 y3) [> x1 x3])
	  (let-values ([(x y) (split #true p1 p3 p2)])
	     (append ;'BOT
		(decompose (sort trisort (list p1 `(,x ,y) p3)))
		(decompose (sort trisort (list `(,x ,y) p2 p3))))
	     ))
	 ((and (= y2 y3) [< x1 x2])
	  (let-values ([(x y) (split #true p1 p2 p3)])
	     (append ;'BOT
		(decompose (sort trisort (list p1 `(,x ,y) p2)))
		(decompose (sort trisort (list `(,x ,y) p2 p3))))
	     ))
	 #;((= y2 y3) (list (cons DC: t))) ; DC we are done
	 ((= y2 y3) 
 	  (let-values ([(x y) (split #true p2 p1 p3)])
	     (append ;'BOT
		(decompose (sort trisort (list p1 p2 `(,x ,y))))
		(decompose (sort trisort (list p1 `(,x ,y) p3))))
	     ))
	 ([and (= x1 x3) (>= x2 x1) (< y2 y1) (< y3 y2)] (list (cons LC: t)))     ; LC
	 ([and (= x1 x3) (<= x2 x1) (< y2 y1) (< y3 y2)] (list (cons RC: t)))     ; RC
	 (else (let-values ([(x y) (apply split #false t)])
		  ;(printf "~a: ~a ~b~n" t a b)
		  (append ;orig: t
		     (decompose (sort trisort (list p1 p2 `(,x ,y))))
		     (decompose (sort trisort (list `(,x ,y) p2 p3)))
		     ))
	       )))
   ))

(cond-expand (bigloo-eval (load "tri-test.scm")))
