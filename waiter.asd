(in-package :asdf-user)

(defsystem "waiter"
  :description "Implementation of iter using cl-walker."
  :version "0.1"
  :author "malisper"
  :depends-on ("alexandria" "cl-walker")
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "core")
                             (:file "classes")
                             (:file "walker-handlers")
                             (:file "unwalker-handlers")
                             (:file "collect-data")
                             (:file "transfer-data")
                             (:file "mapping")
                             (:file "macros")))))
