(in-package :waiter)

(defiter-handler with (form parent env)
  (with-form-object (with 'with-form parent)
    (setf (var-of with) (second form))
    (setf (val-of with) (walk-form (fourth form)))))

(defiter-handler terminate (form parent env)
  (with-form-object (terminate 'terminate-form form)))

(defiter-handler initially (form parent env)
  (with-form-object (initially 'initially-form parent)
    (setf (body-of initially) (walk-form `(progn ,@(cdr form))))))

(defiter-handler finally (form parent env)
  (with-form-object (finally 'finally-form parent)
    (setf (body-of finally) (walk-form `(progn ,@(cdr form))))))
