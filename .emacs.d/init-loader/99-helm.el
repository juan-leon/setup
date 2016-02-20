(use-package helm
  :ensure t
  :defer t)

(use-package helm-config
  :defer nil
  :bind (([(meta kp-5)]     . helm-mini)
         ([(meta kp-begin)] . helm-mini)
         ([(super b)] . helm-bookmarks)
         ([(super +)] . helm-semantic-or-imenu)
         ([(super y)] . helm-show-kill-ring)
         ([(super m)] . helm-man-woman))
  :init
  (setq helm-M-x-fuzzy-match t
        helm-buffers-fuzzy-matching t
        helm-always-two-windows t
        helm-split-window-default-side 'left)
  :config
  (helm-mode 1)
  (global-set-key (kbd "M-x")     'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files))

(use-package helm-files
  :defer t
  :config
  (defun juanleon/call-ido-ff (&optional no-op)
    (interactive)
    (call-interactively 'ido-find-file))
  (helm-add-action-to-source "Fallback find-file"
                             'juanleon/call-ido-ff
                             helm-find-files-actions)
  (define-key helm-map (kbd "C-f")
    (lambda () (interactive)
      (helm-exit-and-execute-action 'juanleon/call-ido-ff))))
