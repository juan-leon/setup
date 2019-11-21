(use-package server
  :if window-system
  :init
  (setq server-window 'switch-to-buffer-other-frame)
  (defun juanleon/server-be-done ()
    "Finish server edit sessions and frame"
    (interactive)
    (progn
      (server-edit)
      (server-edit)
      (delete-frame)))
  :defer 5
  :bind (([(super ?#)] . juanleon/server-be-done))
  :config
  (unless (server-running-p) (server-start)))


(use-package atomic-chrome
  :if window-system
  :ensure t
  :init (atomic-chrome-start-server)
  :config (setq atomic-chrome-default-major-mode 'markdown-mode))
