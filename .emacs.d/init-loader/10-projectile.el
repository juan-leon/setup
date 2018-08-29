(use-package projectile
  :ensure t
  :demand
  :preface
  (global-set-key (kbd "C-p") nil)
  :bind (([(control meta ?')] . projectile-switch-project)
         ([(control meta ?-)] . projectile-switch-project))
  :custom
  (projectile-switch-project-action (lambda ()
                                      (if (magit-git-repo-p (projectile-project-root))
                                          (magit-status)
                                        (projectile-dired))))
  (projectile-tags-command "ctags-exuberant -Re -f \"%s\" %s")
  :config
  (define-key projectile-mode-map (kbd "C-p") 'projectile-command-map)
  (projectile-mode))

(use-package projectile-ripgrep
  :ensure t
  :after projectile
  :bind (:map projectile-command-map ([?0] . projectile-ripgrep)))

(use-package ripgrep
  :ensure t
  :defer t
  :custom (ripgrep-arguments (list "-M 200")))
