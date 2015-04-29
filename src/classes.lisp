(in-package :waiter)

(defclass iter-form (walked-form)
  ((iter :accessor iter-of :initarg :iter :initform *current-iter*)
   (expand :accessor expand? :initform nil)))

(defclass terminate-form (iter-form)
  ((end-tag :accessor end-tag-of :initform nil)))

(defclass with-form (iter-form)
  ((var :accessor var-of :initarg :var)
   (val :accessor val-of :initarg :val :initform nil)))
