(use-package tramp
  :config
  ;; Speed up things
  (setq remote-file-name-inhibit-cache nil
        tramp-completion-reread-directory-timeout nil
        vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)"
                                     vc-ignore-dir-regexp
                                     tramp-file-name-regexp)))


(use-package desktop
  :config
  (setq desktop-load-locked-desktop nil)
  (desktop-save-mode 1))


(use-package saveplace
  :custom (save-place-file (concat user-emacs-directory "history/places"))
  :config (save-place-mode 1))


(use-package bookmark
  :bind (([(super meta b)] . bookmark-bmenu-list)
         ([(super B)]      . bookmark-set)))
