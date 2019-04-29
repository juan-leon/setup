(defun juanleon/delete-trailing-blank-lines ()
  "Deletes all blank lines at the end of the file."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))


(defun juanleon/copy-import ()
  (interactive)
  (projectile-with-default-dir (projectile-project-root)
    (let ((command (format
                    "rg -g '*.py' --no-filename -N -w '^from\\b.*\\bimport\\b.*\\b%s' | head -1"
                    (symbol-at-point))))
      (kill-new (shell-command-to-string command)))))


(defun juanleon/workon (env)
  (interactive "sPython env name: ")
  (let ((interpreter (format "%s/.envs/%s/bin/python" (getenv "HOME") env)))
    (setq python-shell-interpreter interpreter)
    ;; Use ipython iif virtualenv has it
    (setq python-shell-interpreter-args
          (if (eq 0 (call-process interpreter nil nil nil "-m" "pip" "show" "-qqq" "ipython"))
              "-m IPython --simple-prompt -i" "-i"))))

(juanleon/workon "py37")


(use-package jedi-core
  :ensure t
  :config (setq jedi:tooltip-method nil))


(add-hook 'python-mode-hook
          (lambda ()
            ;; (jedi:setup) tramp issue
            (setq tab-width 4)
            (add-hook 'before-save-hook 'juanleon/delete-trailing-blank-lines nil 'local)
            (local-set-key [(super f5)] 'juanleon/copy-import)
            (setq fill-column 79)))
