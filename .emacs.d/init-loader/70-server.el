(use-package server
  :if window-system
  :init (setq server-window 'switch-to-buffer-other-frame)
  :defer 5
  :config (unless (server-running-p)
            (server-start)))


(use-package atomic-chrome
  :if window-system
  :ensure t
  :commands atomic-chrome-start-server
  :init (atomic-chrome-start-server))
