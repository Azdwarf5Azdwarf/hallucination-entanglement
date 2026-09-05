;; symbols.lisp
;; Run in SBCL:  sbcl --script learning/lisp/symbols.lisp
;; Or paste into a Common Lisp REPL.
;; Common Lisp syntax — symbols first, science later.

(defpackage :symbols-lab
  (:use :cl))
(in-package :symbols-lab)

;; A symbol is an object. A string only looks similar.
(defparameter *word* 'entangle)
(defparameter *lookalike* "entangle")

(format t "symbol: ~s  type: ~a~%" *word* (type-of *word*))
(format t "string: ~s  type: ~a~%~%" *lookalike* (type-of *lookalike*))

;; Misspelling interned a *different* symbol. No fuzzy match.
(defparameter *misspelled* 'entagle)
(format t "same symbol? ~a~%" (eq *word* *misspelled*))
(format t "eq tests identity. 'entangle and 'entagle are two objects.~%~%")

;; Code is a list of symbols. Homoiconicity: the form is data.
(defparameter *form* '(measure alice spin-up))
(format t "form: ~s~%" *form*)
(format t "head (operator): ~s~%" (first *form*))
(format t "args: ~s~%~%" (rest *form*))

(defun wrap-pair (a b)
  "Cartoon of a joint state: one list, two addresses."
  (list 'joint a b))

(format t "joint: ~s~%" (wrap-pair 'alice 'bob))
(format t "joint misspelled: ~s~%~%" (wrap-pair *word* *misspelled*))

(defparameter *pair*
  (list :state 'singlet
        :left  'alice
        :right 'bob
        :note  "one object, two addresses — not a radio"))

(format t "pair: ~s~%" *pair*)
(format t "done.~%")
