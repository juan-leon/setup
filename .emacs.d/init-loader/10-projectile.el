(use-package projectile
  :ensure t
  :demand
  :bind-keymap ("C-p" . projectile-command-map)
  :bind (([(control meta ?')] . projectile-switch-project)
         ([(control meta ?-)] . projectile-switch-project))
  :config
  (setq projectile-switch-project-action (lambda ()
                                           (if (magit-git-repo-p (projectile-project-root))
                                               (magit-status)
                                             (projectile-dired)))
        projectile-tags-command "ctags-exuberant -Re -f \"%s\" %s")
  (projectile-mode))


(use-package projectile-ripgrep
  :ensure t
  :after projectile
  :bind (:map projectile-command-map ([?0] . projectile-ripgrep)))
