(in-package :waiter)

(defmacro collect (expr &optional (into 'into) (var (gensym)))
  (assert (equal into 'into))
  (with-unique-names (head tail)
    `(progn (with ,head = (list nil))
            (with ,tail = ,head)
            (with ,var = nil)
            (setf ,tail (setf (cdr ,tail) (list ,expr)))
            (setf ,var (cdr ,head)))))

;; Currently this is meant to only go up.
(defmacro for (var &optional (from 'from) lower (to 'to) (upper (1- lower)))
  (assert (eql from 'from))
  (assert (eql to 'to))
  `(progn (with ,var = ,(1- lower))
          (until (= ,var ,upper))
          (incf ,var)))

(defmacro until (expr)
  `(when ,expr
     (terminate)))

(defmacro while (expr)
  `(until (not ,expr)))
