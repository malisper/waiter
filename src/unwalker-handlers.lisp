(in-package :waiter)

(defunwalker-handler while-form (cond end-tag)
  `(unless ,(unwalk-form cond)
     (go ,end-tag)))

;; We should be able to just remove the with.
(defunwalker-handler with-form ()
  nil)
