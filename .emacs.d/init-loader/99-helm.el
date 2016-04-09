(use-package helm
  :ensure t
  :defer t)

(use-package helm-mode
  :defer t
  :diminish helm-mode)

(use-package helm-config
  :demand
  :bind (([(meta kp-5)]     . helm-mini)
         ([(meta kp-begin)] . helm-mini)
         ([(super h)] . helm-resume)
         ([(super b)] . helm-bookmarks)
         ([(super +)] . helm-semantic-or-imenu)
         ([(super y)] . helm-show-kill-ring)
         ([(super m)] . helm-man-woman))
  :init
  (setq helm-M-x-fuzzy-match           t
        helm-buffers-fuzzy-matching    t
        helm-full-frame                t
        helm-ff-skip-boring-files      t
        helm-echo-input-in-header-line t)
        ;; helm-always-two-windows         t
        ;; helm-split-window-default-side 'left
  :config
  (helm-mode 1)
  (global-set-key (kbd "M-x")     'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files))

(use-package helm-files
  :defer t
  :config
  (defun juanleon/call-ido-from-helm (&optional no-op)
    (call-interactively 'ido-find-file))
  (defun juanleon/call-dired-from-helm (&optional file)
    (dired-jump nil file))
  (define-key helm-find-files-map [(control f)]
    (lambda ()
      (interactive)
      (helm-exit-and-execute-action 'juanleon/call-ido-from-helm)))
  (define-key helm-find-files-map [(control d)]
    (lambda ()
      (interactive)
      (helm-exit-and-execute-action 'juanleon/call-dired-from-helm))))

