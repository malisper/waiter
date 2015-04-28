(in-package :waiter)

(defmethod collect-data :around (data form)
  (when (and (typep form 'iter-form)
             (eql (name-of data) (iter-of form)))
    (call-next-method))
  form)

(defmethod collect-data progn (data (form with-form))
  (nconc1 (list (var-of form)
                (unwalk-form (val-of form)))
          (vars-of data)))
