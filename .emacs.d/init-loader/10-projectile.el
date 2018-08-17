(use-package projectile
  :ensure t
  :preface
  (global-set-key (kbd "C-p") nil)
  (define-key projectile-mode-map (kbd "C-p") 'projectile-command-map)
  :diminish projectile-mode
  :bind (([(control meta ?')] . projectile-switch-project)
         ([(control meta ?-)] . projectile-switch-project))
  :init
  (setq projectile-switch-project-action 'magit-status ;; or projectile-dired?
        projectile-tags-command          "ctags-exuberant -Re -f \"%s\" %s")
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
  :config
  (setq ripgrep-arguments (list "-M 200")))
