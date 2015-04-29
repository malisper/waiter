(in-package :waiter)

(defparameter *iter-handlers* (make-hash-table))
(defparameter *current-iter* nil "The name of the current iter block.")

(defun find-iter-handler (form)
  "Look up the handler for an iterate clause."
  (and (listp form) (gethash (car form) *iter-handlers*)))

(defun (setf find-iter-handler) (val sym)
  "Set the iter-handler for the given symbol."
  (setf (gethash sym *iter-handlers*) val))

(defmacro defiter-handler (type (form parent lexenv) &body body)
  "Define an iter handler for cl-walker."
  `(setf (find-iter-handler ',type)
         (lambda (,form ,parent ,lexenv)
           (declare (ignorable ,form ,parent ,lexenv))
           ,@body)))

(defun nconc1 (x xs)
  "Nconcs the single element X onto the end of XS."
  (nconc xs (list x)))

(defun orf (&rest fns)
  "Returns the result of FNS or'd together. They are called lazily."
  (lambda (&rest args)
    (some (lambda (f) (apply f args))
          fns)))

(defun add-block (&optional condition)
  "Invoke the add-block restart."
  (declare (ignore condition))
  (invoke-restart 'add-block))

(defun walk-iter-forms (exps)
  "Walk over the iter forms."
  (handler-bind ((return-from-unknown-block #'add-block))
    (with-walker-configuration
        (:undefined-reference-handler nil
         :find-walker-handler
           ;; We want to use the previous handler if we do not know
           ;; how to handle it.
           (orf #'find-iter-handler
                (cl-walker::find-walker-handler-of
                   cl-walker::*walker-context*)))
      (walk-form `(progn ,@exps)))))

(defgeneric collect-data (data form)
  (:documentation "Collect the data from FORM into DATA. This
                   implements the first pass made over the code.")
  (:method-combination progn)
  (:method progn (x y)))

(defgeneric transfer-data (data form)
  (:documentation "Transfer the data from DATA into FORM. This
                   implements the second pass made over the code.")
  (:method-combination progn)
  (:method progn (x y)))

(defun process-iter-forms (forms)
  "Process the iterate forms and return an iter-data object containing
   the information."
  (let ((result (make-instance 'iter-data)))
    (map-ast (lambda (form) (collect-data result form)) forms)
    (map-ast (lambda (form) (transfer-data result form)) forms)
    result))

(defclass iter-data ()
  ((name :accessor name-of
         :initarg :name
         :initform *current-iter*)
   (vars :accessor vars-of
         :initarg :vars
         ;; By having a list here, it is possible to nconc onto the
         ;; end of it.
         :initform (list (gensym "IGNORE")))
   (result :accessor result-of
           :initarg :result
           :initform '())
   (finally :accessor finally-of
            :initarg :finally
            :initform '())
   (end-tag :accessor end-tag-of
            :initarg :end-tag
            :initform (gensym "END"))
   (start-tag :accessor start-tag-of
              :initarg :start-tag
              :initform (gensym "START"))
   (initially :accessor initially-of
              :initarg :initially
              :initform '())))

(defmacro iter (&rest exps)
  (let* ((*current-iter* (if (symbolp (car exps)) (pop exps) nil))
         (form (walk-iter-forms exps))
         (data (process-iter-forms form)))
    `(block ,(name-of data)
       (let* ,(vars-of data)
         (declare (ignorable ,@(mapcar #'ensure-car (vars-of data))))
         (tagbody
           ,@(remove nil
               `(,(initially-of data)
                 ,(start-tag-of data)
                 ,(unwalk-form form)
                 (go ,(start-tag-of data))
                 ,(end-tag-of data)
                 ,(finally-of data)
                 (return-from ,(name-of data)
                 ,(result-of data)))))))))
