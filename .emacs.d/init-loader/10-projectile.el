(use-package projectile
  :ensure t
  :preface (setq projectile-keymap-prefix (kbd "C-p"))
  :diminish projectile-mode
  :init
  (setq projectile-keymap-prefix         (kbd "C-p")
        projectile-switch-project-action 'projectile-dired
        projectile-tags-command          "ctags-exuberant -Re -f \"%s\" %s")
  :config
  (projectile-global-mode))
