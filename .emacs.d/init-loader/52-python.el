(use-package python
             :ensure t
             :mode ("\\.py\\'" . python-mode)
             :interpreter ("python" . python-mode)
             :init
             (add-hook 'python-mode-hook
                       (lambda ()
                         ;; (jedi:setup) tramp issue
                         (setq tab-width 4)
                         (add-hook 'before-save-hook 'juanleon/delete-trailing-blank-lines nil 'local)
                         (setq fill-column 79))))

(use-package jedi-core
             :ensure t
             :init
             (setq jedi:tooltip-method nil))
