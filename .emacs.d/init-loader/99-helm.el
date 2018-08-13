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
        helm-buffer-max-length         80
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

(use-package helm-dash
  :ensure t
  :defer t
  ;; not quite like this: (setq helm-dash-browser-func 'eww)
  :bind (([(super return)] . helm-dash-at-point)
         ([(super shift return)] . helm-dash))
  :config
  (setq helm-dash-browser-func
      (lambda (url)
        (other-window 1)
        (xwidget-browse-url-no-reuse url)))
  (helm-dash-activate-docset "Emacs_Lisp")
  (helm-dash-activate-docset "MySQL")
  (helm-dash-activate-docset "PHP")
  (helm-dash-activate-docset "Python_2")
  (helm-dash-activate-docset "Bash"))


(use-package helm-projectile
  :ensure t)

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :bind (([(control ?c) (control ?r)] . ivy-resume)
         ([(meta kp-5)]     . ivy-switch-buffer)
         ([(meta kp-begin)] . ivy-switch-buffer)
         ([(control ?c) ?v] . ivy-push-view)
         ([(control ?c) ?V] . ivy-pop-view)
         :map ivy-minibuffer-map
         ([(control ?w)] . ivy-yank-word)
         ([(control ?a)] . ivy-yank-symbol)
         )
  :config
  (ivy-mode 1)
  (setq ivy-height 16
        ivy-use-virtual-buffers t
        ivy-count-format "%d/%d "
        magit-completing-read-function 'ivy-completing-read))

(use-package swiper
  :ensure t
  :bind (([(control ?s)] . swiper)))

(use-package counsel
  :ensure t
  :bind (([(meta ?x)] . counsel-M-x)
         ([(control ?x) (control ?f)] . counsel-find-file)
         ([(control ?.)] . counsel-imenu)
         ([(super y)] . counsel-yank-pop)))

(use-package ivy-hydra
  :ensure t
  :defer
  :commands hydra-ivy/body)


(use-package smex
  :ensure t
  :init (setq smex-save-file (concat user-emacs-directory ".smex-items"))
  :config (smex-auto-update 60))
