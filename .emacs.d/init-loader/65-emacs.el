(use-package helpful
  :ensure t
  :bind (([(control ?h) ?f]  . helpful-callable)
         ([(control ?h) ?v]  . helpful-variable)
         ([(control ?h) ?k]  . helpful-key)
         ([(control return)] . helpful-at-point)))


(use-package which-key
  :ensure t
  :config (which-key-mode 1))


(use-package discover-my-major
  :ensure t
  :bind ("C-h C-m" . discover-my-major))


(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))
