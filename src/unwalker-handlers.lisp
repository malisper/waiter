(in-package :waiter)

(defunwalker-handler terminate-form (end-tag)
  `(go ,end-tag))

;; We should be able to just remove the with.
(defunwalker-handler with-form ()
  nil)
