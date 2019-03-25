(use-package python
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :init
  (add-hook 'python-mode-hook
            (lambda ()
              ;; (jedi:setup) tramp issue
              (setq tab-width 4)
              (add-hook 'before-save-hook 'juanleon/delete-trailing-blank-lines nil 'local)
              (setq fill-column 79)))
  (defun juanleon/workon (env)
    (interactive "sPython env name: ")
    (let ((interpreter (format "%s/.envs/%s/bin/python" (getenv "HOME") env)))
      (setq python-shell-interpreter interpreter)
      ;; Use ipython iif virtualenv has it
      (setq python-shell-interpreter-args
            (if (eq 0 (call-process interpreter nil nil nil "-m" "pip" "show" "-qqq" "ipython"))
                "-m IPython --simple-prompt -i" "-i"))))
  (juanleon/workon "py37"))

(use-package jedi-core
  :ensure t
  :custom (jedi:tooltip-method nil))
