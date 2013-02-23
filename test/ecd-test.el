;; -*- compile-command: "emacs --script ecd-test.el" -*-

(setq load-path (cons ".." load-path))
(setq load-path (cons "." load-path))

(require 'ert)

(require 'ecd)
(setq ecd-list '((?x . "~/Desktop")))
(setq ecd-debug ?x)

(ert-deftest test-ecd ()
  (should (ecd)))

(ert-run-tests-batch t)
