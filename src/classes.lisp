(in-package :waiter)

(defclass iter-form (walked-form)
  ((iter :accessor iter-of :initarg :iter :initform *current-iter*)
   (expand :accessor expand? :initform nil)))

(defclass terminate-mixin ()
  ((end-tag :accessor end-tag-of :initform nil)))

(defclass while-form (iter-form terminate-mixin)
  ((cond :accessor cond-of :initarg :cond)))

(defclass with-form (iter-form)
  ((var :accessor var-of :initarg :var)
   (val :accessor val-of :initarg :val :initform nil)))
