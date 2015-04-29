(in-package :waiter)

(defmacro defmap (class &rest accessors)
  "Define which accessors to use to continue mapping on when mapping
   over CLASS with map-ast."
  `(defmethod map-ast progn (visitor (form ,class))
     ,@(loop for accessor in accessors
             collect `(map-ast visitor (,accessor form)))))

(defmap with-form val-of)
