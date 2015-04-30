(in-package :waiter)

(defmethod collect-data :around (data form)
  (when (and (typep form 'iter-form)
             (eql (name-of data) (iter-of form)))
    (call-next-method))
  form)

(defmethod collect-data progn (data (form with-form))
  (setf (vars-of data)
        (append1 (list (var-of form)
                       (unwalk-form (val-of form)))
                 (vars-of data))))

(defmethod collect-data progn (data (form finally-form))
  (setf (finally-of data)
        (append (finally-of data) (unwalk-form (body-of form)))))

(defmethod collect-data progn (data (form initially-form))
  (setf (initially-of data)
        (append (initially-of data) (unwalk-form (body-of form)))))
