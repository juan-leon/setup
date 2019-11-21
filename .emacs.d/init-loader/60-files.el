(use-package files
  :config
  (setq auto-save-default      nil
        backup-directory-alist `(("" . ,(concat user-emacs-directory "/autosaved/")))
        confirm-kill-emacs     'y-or-n-p ; "Fast fingers protection"
        require-final-newline  t))


(use-package tramp
  :bind (([(control ?x) (control ?r)] . juanleon/sudo-powerup))
  :config
  ;; Speed up things
  (setq remote-file-name-inhibit-cache nil
        tramp-completion-reread-directory-timeout nil
        vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)"
                                     vc-ignore-dir-regexp
                                     tramp-file-name-regexp))

  (defun juanleon/sudo-powerup ()
    (interactive)
    (if buffer-file-name
        (let ((point (point)))
          (find-alternate-file
           (if (tramp-tramp-file-p buffer-file-name)
               (progn
                 (string-match "^/\\w*:" buffer-file-name)
                 (replace-match "/sudo:" nil nil buffer-file-name))
             (concat "/sudo::" buffer-file-name)))
          (goto-char point)))))


(use-package desktop
  :config
  (setq desktop-load-locked-desktop nil
        desktop-modes-not-to-save '(tags-table-mode dired-mode))
  (desktop-save-mode 1))


(use-package saveplace
  :config
  (setq save-place-file (concat user-emacs-directory "history/places"))
  (save-place-mode 1))


(use-package bookmark
  :bind (([(super meta b)] . bookmark-bmenu-list)
         ([(super B)]      . bookmark-set)))
