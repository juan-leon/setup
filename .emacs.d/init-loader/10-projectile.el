(use-package projectile
  :ensure t
  :preface
  (global-set-key (kbd "C-p") nil)
  (define-key projectile-mode-map (kbd "C-p") 'projectile-command-map)
  :bind (([(control meta ?')] . projectile-switch-project)
         ([(control meta ?-)] . projectile-switch-project))
  :custom
  ;; TODO: create defun to use projectile-dired if not a git repo
  (projectile-switch-project-action 'magit-status)
  (projectile-tags-command "ctags-exuberant -Re -f \"%s\" %s")
  :config
  (projectile-mode)
  (define-key projectile-mode-map (kbd "C-p") 'projectile-command-map))

(use-package projectile-ripgrep
  :ensure t
  :after projectile
  :bind (:map projectile-command-map ([?0] . projectile-ripgrep)))

(use-package ripgrep
  :ensure t
  :defer t
  :custom (ripgrep-arguments (list "-M 200")))
