;; For shorter keybindings
(defmacro command (&rest body)
  `(lambda ()
     (interactive)
     ,@body))

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default
 indent-tabs-mode                nil
 tab-width                       4
 fill-column                     80
 truncate-lines                  t)

(setq
 align-to-tab-stop               nil
 auto-save-default               nil
 backup-directory-alist          `(("" . ,(concat user-emacs-directory "/autosaved/")))
 confirm-kill-emacs              'y-or-n-p ; "Fast fingers protection"
 disabled-command-function       nil ; Warnings already read
 garbage-collection-messages     t
 inhibit-startup-message         t
 initial-scratch-message         nil
 jit-lock-stealth-time           5
 jit-lock-stealth-nice           0.25
 kill-do-not-save-duplicates     t
 kill-ring-max                   100
 Man-notify-method               'pushy
 message-log-max                 2500
 nxml-child-indent               tab-width
 require-final-newline           t
 search-ring-max                 32
 scroll-step                     1
 scroll-conservatively           1
 scroll-preserve-screen-position 'in-place
 split-height-threshold          140
 text-scale-mode-step            1.1
 track-eol                       t
 undo-ask-before-discard         nil
 use-dialog-box                  nil
 visible-bell                    t
 warning-suppress-types          '((undo discard-info))
 whitespace-line-column          100)

(setq display-time-world-list '(("America/Argentina/Buenos_Aires" "Buenos Aires")
                                ("UTC" "UTC")
                                ("Europe/Madrid" "Madrid")))

(use-package desktop
  :config
  (setq desktop-load-locked-desktop nil)
  (desktop-save-mode 1))

(use-package wrap-region
  :ensure t
  :diminish wrap-region-mode
  :config
  (wrap-region-global-mode t)
  (wrap-region-add-wrapper "`" "`" "q" '(markdown-mode ruby-mode))
  (wrap-region-add-wrapper "```\n" "```" "Q" '(markdown-mode))
  (wrap-region-add-wrapper "`" "`"))

(use-package saveplace
  :custom (save-place-file (concat user-emacs-directory "history/places"))
  :config (save-place-mode 1))

(use-package buffer-move
  :ensure t
  :bind (([(control shift super up)]    . buf-move-up)
         ([(control shift super down)]  . buf-move-down)
         ([(control shift super left)]  . buf-move-left)
         ([(control shift super right)] . buf-move-right)))

(use-package ws-butler
  :ensure t
  :diminish ws-butler-mode
  :init
  (add-hook 'prog-mode-hook #'ws-butler-mode)
  (add-hook 'text-mode-hook #'ws-butler-mode))

(use-package uniquify
  :custom (uniquify-buffer-name-style 'post-forward-angle-brackets))

(use-package ediff
  :defer t
  :init (setq-default ediff-ignore-similar-regions t)
  :custom
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-diff-options          " -bB "))

(use-package winner
  :config
  (winner-mode 1)
  (define-key winner-mode-map [(super prior)] 'winner-undo)
  (define-key winner-mode-map [(super next)]  'winner-redo))

(use-package bm
  :ensure t
  :defer t
  :bind (([(control Scroll_Lock)] . bm-toggle)
         ([(shift Scroll_Lock)]   . bm-previous)
         ([(Scroll_Lock)]         . bm-next)))

;; Fast switching buffers in same window
(use-package buffer-stack
  :ensure t
  :bind (([(meta kp-4)]     . buffer-stack-up)
         ([(meta kp-left)]  . buffer-stack-up)
         ([(meta kp-6)]     . buffer-stack-down)
         ([(meta kp-right)] . buffer-stack-down)
         ([(meta kp-2)]     . buffer-stack-bury)
         ([(meta kp-down)]  . buffer-stack-bury)
         ([(meta kp-8)]     . buffer-stack-untrack)
         ([(meta kp-up)]    . buffer-stack-untrack))
  :config
  (add-to-list 'buffer-stack-untracked "*Backtrace*")
  (defvar buffer-stack-mode)
  (defun buffer-op-by-mode (op &optional mode)
    (let ((buffer-stack-filter 'buffer-stack-filter-by-mode)
          (buffer-stack-mode (or mode major-mode)))
      (funcall op)))
  (defun buffer-stack-filter-by-mode (buffer)
    (with-current-buffer buffer
      (equal major-mode buffer-stack-mode)))
  (global-set-key [(meta kp-7)] (command (buffer-op-by-mode 'buffer-stack-up)))
  (global-set-key [(meta kp-9)] (command (buffer-op-by-mode 'buffer-stack-down)))
  (global-set-key [(meta kp-3)] (command (buffer-op-by-mode 'buffer-stack-down 'dired-mode)))
  (global-set-key [(meta kp-1)] (command (buffer-op-by-mode 'buffer-stack-up 'dired-mode))))

(use-package rotate
  :ensure t
  :bind (([(super home)] . rotate-layout)
         ([(super end)]  . rotate-window)))

(use-package windmove
  :bind (([(control next)]     . windmove-down)
         ([(control prior)]    . windmove-up)
         ([(control kp-6)]     . windmove-right)
         ([(control kp-4)]     . windmove-left)
         ([(control kp-right)] . windmove-right)
         ([(control kp-left)]  . windmove-left))
  :config
  (defadvice windmove-do-window-select (around silent-windmove activate)
    "Do not beep when no suitable window is found."
    (condition-case () ad-do-it (error nil))))

(use-package yascroll
  :ensure t
  :config (global-yascroll-bar-mode 1))

(use-package expand-region
  :ensure t
  :bind (([(super ?1)] . er/expand-region)
         ([(super ?ñ)] . er/expand-region)))

(use-package goto-chg
  :ensure t
  :bind (([(super ?-)]. goto-last-change)
         ([(super ?_)]. goto-last-change-reverse)))

(use-package back-button
  :ensure t
  :diminish back-button-mode
  :config (back-button-mode 1))

(use-package ag
  :ensure t
  :commands ag ag-regexp)

(defun juanleon/switch-buffer-or-window ()
  (interactive)
  (if (one-window-p)
          (ivy-switch-buffer)
        (switch-window)))

(use-package switch-window
  :ensure t
  :commands switch-window
  :bind (([(control tab)] . juanleon/switch-buffer-or-window)
         ([(control insert)] . juanleon/switch-buffer-or-window)
         ([(control shift tab)] . switch-window-then-swap-buffer)
         ([(control iso-lefttab)] . switch-window-then-swap-buffer))
         :custom (switch-window-shortcut-style 'qwerty))

(defun juanleon/minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun juanleon/minibuffer-exit-hook ()
  (setq gc-cons-threshold (* 10 1024 1024)))

(add-hook 'minibuffer-setup-hook #'juanleon/minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'juanleon/minibuffer-exit-hook)

(use-package python-switch-quotes
  :ensure t
  :bind ([(control c) ?'] . python-switch-quotes))
