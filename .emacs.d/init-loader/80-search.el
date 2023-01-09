(use-package grep
  :defer t
  :bind (([(super g)] . grep)
         ([(super i)] . rgrep)))


(use-package ripgrep
  :ensure t
  :defer t
  :config (setq ripgrep-arguments (list "-M 200")))


(use-package wgrep
  :ensure t
  :commands wgrep-setup
  :init
  (add-hook 'grep-setup-hook #'wgrep-setup)
  (setq wgrep-auto-save-buffer t
        wgrep-enable-key "e"))


;; Nice wrapper around rg, for those few non-projectile direds
(use-package deadgrep
  :ensure t
  :commands deadgrep)


(use-package xref
  :bind (([(meta return)] . xref-find-definitions)
         ([(control ?.)]  . xref-find-apropos)
         ([(meta ?.)]     . xref-find-definitions)))


(use-package occur-x
  :ensure t
  :config (add-hook 'occur-mode-hook 'turn-on-occur-x-mode))
