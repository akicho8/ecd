;;; ecd.el --- Easy Change Directory

;; Copyright (C) 2013,2014  Free Software Foundation, Inc.

;; Author: akicho8 <akicho8@gmail.com>
;; Keywords: eshell, dired

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; For Example:
;;
;;   (require 'ecd)
;;   (global-unset-key "\M-c")
;;   (global-set-key (kbd "M-c") 'ecd)
;;
;;   (setq ecd-list
;;         '((?/ . "/")
;;           (?~ . "~/")
;;           (?d . "~/Downloads")
;;           (?e . "~/.emacs.d")))
;;
;;   On eshell mode, type M-c e
;;
;;     $ pushd ~/.emacs.d
;;
;;   On other mode, type M-c e
;;
;;     M-x eshell
;;     $ pushd ~/.emacs.d
;;     M-x dired-jump

;;; Code:

(require 'eshell)
(require 'dired-x)

(defvar ecd-list
  '(
    (?/ . "/")
    (?~ . "~/")
    (?d . "~/Downloads")
    (?e . "~/.emacs.d")
    )
  "*Char and directory pair list")

(defvar ecd-debug nil "*for debug")

(defun ecd (&optional num)
  "Easy Change Directory"
  (interactive "p")
  (let (ch dir before-majar-mode minibuffer-active)
    (setq minibuffer-active (active-minibuffer-window))
    (setq before-majar-mode major-mode)
    (when (get-buffer "*ecd*")
      (kill-buffer "*ecd*"))
    (switch-to-buffer "*ecd*")
    (dolist (e ecd-list)
      (insert (format "%c: %s\n" (car e) (cdr e))))
    (goto-char (point-min))
    (when ecd-debug
      (setq ch ecd-debug))
    (unless ch
      (setq ch (read-char (format "cd ? " default-directory))))
    (setq dir (cdr (assq ch ecd-list)))
    (when dir
      (if (and (= num 1) (not minibuffer-active))
          (progn
            (eshell)
            (goto-char (point-max))
            (eshell-bol)
            (unless (eobp)
              (kill-line))
            (insert (concat "pushd " dir))
            (eshell-send-input)
            (unless (eq before-majar-mode 'eshell-mode)
              (dired-jump)))
        (kill-new dir)))
    (when (get-buffer "*ecd*")
      (kill-buffer "*ecd*"))
    (when minibuffer-active
      (select-window (minibuffer-window)))))

(provide 'ecd)
;;; ecd.el ends here
