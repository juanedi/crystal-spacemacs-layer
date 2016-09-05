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

;;; Code:

(defconst crystal-packages
  '(
    (crystal-mode :location (recipe :fetcher github :repo "dotmilk/emacs-crystal-mode"))
    popwin
    company
    )
  )

(defvar crystal--format-buffer-name "*crystal formatter*")

(defun crystal--format-output-buffer ()
  (when (get-buffer crystal--format-buffer-name)
    (kill-buffer crystal--format-buffer-name))
  (popwin:get-buffer crystal--format-buffer-name :create))

(defun crystal--run-formatter (buffer-file-name output-buffer)
  (call-process-shell-command (format "crystal tool format %s" buffer-file-name) nil output-buffer t))

(defun crystal--format-file ()
  (when (and (configuration-layer/package-usedp 'popwin)
             (equal 'crystal-mode major-mode))
    (let ((output-buffer (crystal--format-output-buffer)))
      (let ((exit-status (crystal--run-formatter buffer-file-name output-buffer)))
        (if (eq 0 exit-status)
            (revert-buffer t t)
          (popwin:popup-buffer output-buffer))))))

(defun crystal/pre-init-popwin ()
  (spacemacs|use-package-add-hook popwin
    :post-config
    (push '("*crystal formatter*" :tail t :noselect t) popwin:special-display-config)))

(defun crystal/init-crystal-mode ())

(defun crystal/post-init-crystal-mode ()
  (add-hook 'after-save-hook #'crystal--format-file))

(defun crystal/post-init-company ()
  (spacemacs|add-company-hook crystal-mode))

;;; packages.el ends here
