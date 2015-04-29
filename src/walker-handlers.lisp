(in-package :waiter)

(defiter-handler with (form parent env)
  (with-form-object (with 'with-form parent)
    (setf (var-of with) (second form))
    (setf (val-of with) (walk-form (fourth form)))))

(defiter-handler terminate (form parent env)
  (with-form-object (terminate 'terminate-form form)))
