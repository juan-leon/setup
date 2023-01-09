(use-package projectile
  :ensure t
  :demand
  :bind-keymap ("C-p" . projectile-command-map)
  :bind (([(control meta ?')] . projectile-switch-project)
         ([(control meta ?-)] . projectile-switch-project)
         :map projectile-command-map ([?0] . projectile-ripgrep))
  :config
  (setq projectile-switch-project-action (lambda ()
                                           (if (magit-git-repo-p (projectile-project-root))
                                               (magit-status)
                                             (projectile-dired)))
        projectile-tags-command "ctags-exuberant -Re -f \"%s\" %s"
        ;; I'd rather maintain a ~/.ignore file with ".git", since rg honors .gitignore too
        projectile-globally-ignored-directories '())
  (projectile-mode))
