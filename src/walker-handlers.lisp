(in-package :waiter)

(defiter-handler while (form parent env)
  (with-form-object (while 'while-form parent)
    (setf (cond-of while) (walk-form (cadr form) while env))))

(defiter-handler with (form parent env)
  (with-form-object (with 'with-form parent)
    (setf (var-of with) (second form))
    (setf (val-of with) (walk-form (fourth form)))))
