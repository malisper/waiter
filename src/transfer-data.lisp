(in-package :waiter)

(defmethod transfer-data :around (data form)
  (when (and (typep form 'iter-form)
             (eql (name-of data) (iter-of form)))
    (setf (expand? form) t)
    (call-next-method))
  form)

(defmethod transfer-data progn (data (form terminate-form))
  (setf (end-tag-of form) (end-tag-of data)))
