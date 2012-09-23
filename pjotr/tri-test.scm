(def (read-model f) (with-input-from-file f (delay
 (let loop ((ts '()))
    (let* ((p1 (read))
	   (_ (read-char))
	   (p2 (read))
	   (_ (read-char))
	   (p3 (read)))
      (if (eof-object? p1) (reverse ts)
	  (loop (cons (map string->point `(,p1 ,p2 ,p3)) ts))
      ))
   ))))


(def ts (read-model "tri.txt"))

;"{0,0}","{0.5,0}","{0,1}"
;(pp (decompose '((1 2) (2 3) (3 4))))
;(pp (map (fn x => (sort trisort x)) ts))
(pp (fold append '()
       (map decompose
	  (map normalize
	     (map [sort trisort <>] ts)))))

; "{0,0}","{5,5}","{10,10}"
; "{0,0}","{-5,5}","{-10,10}"
; "{0,0}","{1,0}","{-1,1}"

'(pp (normalizes (list (translate 1 -1 `(:UL (0 .5) (1 .5) (0 0)))
	(translate 2 -1 `(:UC (0 1) (1 1) (0.75 0)))
        (translate 3 -1 `(:UR (0 1) (.5 1) (.5 0)))
	(translate 1 -2 `(:DL (0 .4) (0 0) (1 0)))
	(translate 2 -2 `(:DC (0.15 1) (0 0) (1 0)))
	(translate 3 -2 `(:DR (1 .3) (0 0) (1 0)))
	(translate 1 -3 `(:LC (0 1) (.4 0.5) (0 0)))
	(translate 2 -3 `(:RC (1 1) (0 0.5) (1 0)))
	)))

(define (<DIV> _ style) (string-append "<div style='" style "'/>"))

'(for-each (fn x => (display x)(newline))
   (map (fn x => (eval (apply tri->div 0 0 x)))
      (normalizes (reverse (decompose
	(sort trisort
	   `((0 0) (100 100) (50 30)))))
	 )))

(let ([divs (map (lambda (x) (eval (apply tri->div 0 0 x)))
    (reverse (normalizes (fold append '()
      (map decompose
	(map (lambda (x) (sort trisort x))
	   (read-model "/home/pjotr/scheme/TweakedPot.txt")))
      ))))])
   (pp (length divs))
   (with-output-to-file "TweakedPot.divs" (delay
	(for-each (fn x => (display x)(newline)) divs)))
   )

