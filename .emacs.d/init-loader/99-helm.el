(use-package helm
  :ensure t
  :defer t)

(use-package helm-mode
  :defer t
  :diminish helm-mode)

(use-package helm-config  ;; used by help-dash, used by counsel-dash
  :demand
  :bind (([(super y)] . helm-show-kill-ring))
  :init
  (setq helm-M-x-fuzzy-match           t
        helm-buffers-fuzzy-matching    t
        helm-full-frame                t
        helm-ff-skip-boring-files      t
        helm-buffer-max-length         80
        helm-echo-input-in-header-line t))

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
        projectile-completion-system 'ivy
        ivy-initial-inputs-alist nil
        magit-completing-read-function 'ivy-completing-read
        ivy-re-builders-alist '((counsel-dash . ivy--regex-ignore-order)
                                (t . ivy--regex-plus))
        ivy-height-alist '((counsel-dash . 48)
                           (counsel-dash-at-point . 48))))

(use-package swiper
  :ensure t
  :bind (([(control ?s)] . swiper)))

(use-package counsel
  :ensure t
  :bind (([(meta ?x)] . counsel-M-x)
         ([(control ?x) (control ?f)] . counsel-find-file)
         ([(control ?.)] . counsel-imenu)
         ([(super b)] . counsel-bookmark)
         ([(super y)] . counsel-yank-pop)))

(use-package ivy-hydra
  :ensure t
  :defer
  :commands hydra-ivy/body)

(use-package counsel-projectile
  :ensure t
  :after projectile
  :bind (([(super ?q)] . counsel-projectile)
         ([(super kp-5)] . counsel-projectile)))

;; counsel-M-x is a lot nicer when smex is installed
(use-package smex
  :ensure t
  :init (setq smex-save-file (concat user-emacs-directory ".smex-items"))
  :config (smex-auto-update 60))

(use-package counsel-dash
  :ensure t
  :defer t
  :bind (([(super return)] . counsel-dash-at-point)
         ([(super shift return)] . counsel-dash))
  :config
  (setq counsel-dash-browser-func
        (lambda (url)
          (other-window 1)
          (xwidget-browse-url-no-reuse url)))
  (defun counsel-dash-at-point ()
    (interactive)
    (counsel-dash (thing-at-point 'symbol)))
  ;; fixme check if present and install them
  ;; fixme be smart regarding t mode of buffer
  (counsel-dash-activate-docset "Emacs_Lisp")
  (counsel-dash-activate-docset "MySQL")
  (counsel-dash-activate-docset "PHP")
  (counsel-dash-activate-docset "Python_2")
  (counsel-dash-activate-docset "Bash"))


 (defadvice projectile-switch-project (around be-fuzzy (arg) activate)
   "Use fuzzy matching"
   (let ((ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
         (ivy-height 32))
     ad-do-it))
