;; symbols.lisp
;; Run in SBCL:  sbcl --script learning/lisp/symbols.lisp
;; Or paste into a Racket/Common Lisp REPL.
;; This is Common Lisp syntax.

(defpackage :symbols-lab
  (:use :cl))
(in-package :symbols-lab)

;; A symbol is an object. A string is a different object that only looks similar.
(defparameter *word* 'entangle)          ; symbol
(defparameter *lookalike* "entangle")    ; string

(format t "symbol: ~s  type: ~a~%" *word* (type-of *word*))
(format t "string: ~s  type: ~a~%~%" *lookalike* (type-of *lookalike*))

;; Misspelling makes a *different* symbol. No fuzzy match. That is the lesson.
(defparameter *misspelled* 'entagle)     ; the typo from the chat
(format t "same symbol? ~a~%" (eq *word* *misspelled*))
(format t "eq is identity for symbols interned in the same package.~%~%")

;; Code is a list of symbols (and other atoms). Homoiconicity:
(defparameter *form* '(measure alice spin-up))
(format t "form: ~s~%" *form)
(format t "head (operator): ~s~%" (first *form*))
(format t "args: ~s~%~%" (rest *form*))

;; Quote stops evaluation. Eval turns the list back into work.
;; We do not eval random lists here; we just look at the shape.
(defun wrap-pair (a b)
  "A cartoon of a joint state: one list, two addresses."
  (list 'joint a b))

(format t "joint: ~s~%" (wrap-pair 'alice 'bob))
(format t "joint misspelled: ~s~%~%" (wrap-pair *word* *misspelled*))

;; Tiny ritual that stays honest: bind two names to one structure.
(defparameter *pair*
  (list :state 'singlet
        :left  'alice
        :right 'bob
        :note  "one object, two addresses — not a radio"))

(format t "pair: ~s~%" *pair*)
(format t "done.~%")
