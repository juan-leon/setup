(use-package projectile
  :ensure t
  :preface
  (global-set-key (kbd "C-p") nil)
  (setq projectile-keymap-prefix (kbd "C-p"))
  :diminish projectile-mode
  :init
  (setq projectile-keymap-prefix         (kbd "C-p")
        projectile-switch-project-action 'projectile-dired
        projectile-tags-command          "ctags-exuberant -Re -f \"%s\" %s")
  :config
  (projectile-mode))

(use-package projectile-ripgrep
  :ensure t
  :after projectile
  :bind (:map projectile-command-map ([?0] . projectile-ripgrep)))
