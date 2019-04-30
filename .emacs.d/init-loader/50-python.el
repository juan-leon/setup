(defun juanleon/copy-import ()
  (interactive)
  (projectile-with-default-dir (projectile-project-root)
    (let ((command (format
                    "rg -g '*.py' --no-filename -N -w '^from\\b.*\\bimport\\b.*\\b%s' | head -1"
                    (symbol-at-point))))
      (kill-new (shell-command-to-string command)))))


(defun juanleon/python-mode-setup ()
  ;; (jedi:setup) fixme: use (file-remote-p) and figure out what fails
  (setq fill-column 79))


(defun juanleon/workon (env)
  (interactive "sPython env name: ")
  (let ((interpreter (format "%s/.envs/%s/bin/python" (getenv "HOME") env)))
    (setq python-shell-interpreter interpreter)
    ;; Use ipython iif virtualenv has it
    (setq python-shell-interpreter-args
          (if (eq 0 (call-process interpreter nil nil nil "-m" "pip" "show" "-qqq" "ipython"))
              "-m IPython --simple-prompt -i" "-i"))))


(use-package python
  :mode ("\\.py\\'" . python-mode)
  :bind (:map python-mode-map ([(super f5)] . juanleon/copy-import))
  :config
  (juanleon/workon "py37")
  (add-hook 'python-mode-hook #'juanleon/python-mode-setup))


(use-package jedi
  :disabled
  :ensure t
  :config
  (setq jedi:tooltip-method nil
        jedi:environment-root "/home/juanleon/.jedienv"
        jedi:environment-virtualenv
        '("virtualenv" "-p" "python3.7" "--system-site-packages" "--quiet")))
