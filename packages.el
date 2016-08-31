;;; packages.el --- crystal layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Juan Edi <jedi@Juans-MacBook-Pro.local>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `crystal-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `crystal/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `crystal/pre-init-PACKAGE' and/or
;;   `crystal/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst crystal-packages
  '(
    (crystal-mode :location (recipe :fetcher github :repo "dotmilk/emacs-crystal-mode"))
    )
  )

(defun crystal/format-file ()
  (when (equal 'crystal-mode major-mode)
    (let ((output-buffer "*crystal formatter*"))
      (when (get-buffer output-buffer) (kill-buffer output-buffer))
      (get-buffer-create output-buffer)
      (let ((exit-status (call-process-shell-command (format "crystal tool format %s" buffer-file-name) nil output-buffer t)))
        (if (eq 0 exit-status)
            (revert-buffer t t)
          (popwin:popup-buffer output-buffer))))))

(defun crystal/init-crystal-mode ())

(defun crystal/post-init-crystal-mode ()
  ;; TODO: this should be optional
  ;; TODO: register hook only for crystal files?
  (add-hook 'after-save-hook #'crystal/format-file))

;;; packages.el ends here
