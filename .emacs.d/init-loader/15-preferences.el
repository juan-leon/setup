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
 case-fold-search                nil
 search-ring-update              t
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
 isearch-allow-scroll            t
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

(setq ibuffer-formats '((mark modified read-only
                              " " (name 35 35)
                              " " (size 9 9 :right)
                              " " (mode 18 18 :left :elide)
                              " " filename-and-process)
                        (mark " " (name 30 -1) " " filename)))


(column-number-mode      1)
(auto-image-file-mode    1)
(show-paren-mode         1)
(size-indication-mode    1)
(file-name-shadow-mode   1)
(temp-buffer-resize-mode 1)

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
  :init
  (setq save-place-file (concat user-emacs-directory "history/places"))
  :config
  (save-place-mode 1))

(use-package buffer-move
  :ensure t
  :bind (([(control shift super up)]    . buf-move-up)
         ([(control shift super down)]  . buf-move-down)
         ([(control shift super left)]  . buf-move-left)
         ([(control shift super right)] . buf-move-right)))

(use-package ws-trim
  :ensure t
  :disabled  ;; Trying ws-butler
  :diminish ws-trim-mode
  :init (setq ws-trim-level 1
              ws-trim-method-hook '(ws-trim-trailing ws-trim-leading))
  :config (global-ws-trim-mode 1))

(use-package ws-butler
  :ensure t
  :diminish ws-butler-mode
  :init
  (add-hook 'prog-mode-hook #'ws-butler-mode)
  (add-hook 'text-mode-hook #'ws-butler-mode))


(use-package uniquify
  :init (setq-default uniquify-buffer-name-style 'post-forward-angle-brackets))


(use-package ediff
  :defer t
  :init
  (setq-default ediff-ignore-similar-regions t)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain
        ediff-split-window-function 'split-window-horizontally
        ediff-diff-options          " -bB "))

(use-package winner
  :config
  (winner-mode 1)
  (define-key winner-mode-map [(super prior)] 'winner-undo)
  (define-key winner-mode-map [(super next)]  'winner-redo))


(use-package ack-and-a-half
  :commands ack-and-a-half)

(use-package bm
  :ensure t
  :defer t
  :bind (([(control Scroll_Lock)] . bm-toggle)
         ([(shift Scroll_Lock)]   . bm-previous)
         ([(Scroll_Lock)]         . bm-next)))

(use-package help-mode
  :defer t
  :config
  (define-key help-mode-map [backspace]    'help-go-back)
  (define-key help-mode-map [(meta left)]  'help-go-back)
  (define-key help-mode-map [(meta right)] 'help-go-forward))


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
  :init
  (setq yascroll:delay-to-hide nil)
  :config
  (global-yascroll-bar-mode 1))


(use-package ido
  :ensure t
  :defer nil
  :bind (([(control x) ?b] . ido-switch-buffer))
  ;; ([(meta kp-5)]    . ido-switch-buffer)
  ;; ([(meta kp-begin)]. ido-switch-buffer))
  :init
  (setq ido-case-fold                nil
        ido-enable-tramp-completion  nil
        ido-save-directory-list-file (concat user-emacs-directory "history/ido")
        ido-auto-merge-delay-time    20
        ido-slow-ftp-host-regexps    '(".")
        ido-read-file-name-non-ido   '(dired-create-directory))
  :config
  (ido-mode 1)
  (ido-everywhere 1))

(use-package flx-ido
  :ensure t
  :config (flx-ido-mode 1))


(use-package expand-region
  :ensure t
  :bind (([(super ?1)] . er/expand-region)
         ([(super ?ñ)] . er/expand-region)))

(use-package goto-chg
  :ensure t
  :bind (([(super ?-)]. goto-last-change)
         ([(super ?_)]. goto-last-change-reverse)))


(use-package anzu
  :ensure t
  :diminish anzu-mode
  :config
  (global-anzu-mode 1)
  (define-key isearch-mode-map [(control t)]    'isearch-toggle-case-fold)
  (define-key isearch-mode-map [(control up)]   'isearch-ring-retreat)
  (define-key isearch-mode-map [(control down)] 'isearch-ring-advance)
  (add-hook 'isearch-mode-end-hook
            (lambda () (if interprogram-cut-function
                           (funcall interprogram-cut-function isearch-string)))))

(use-package back-button
  :ensure t
  :diminish back-button-mode
  :config (back-button-mode 1))


(use-package undo-tree
  :ensure t
  :disabled  ;; Using DO not play nice with undo in region
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t))

(use-package ag
  :ensure t
  :commands ag ag-regexp)

(defun juanleon/switch-buffer-or-window ()
  (interactive)
  (if (one-window-p)
          (helm-mini)
        (switch-window)))

(use-package switch-window
  :ensure t
  :commands switch-window
  :bind (([(control tab)] . juanleon/switch-buffer-or-window)
         ([(control insert)] . juanleon/switch-buffer-or-window)
         ([(control shift tab)] . switch-window-then-swap-buffer)
         ([(control iso-lefttab)] . switch-window-then-swap-buffer))
  :init (setq switch-window-shortcut-style 'qwerty))

(defun juanleon/minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun juanleon/minibuffer-exit-hook ()
  (setq gc-cons-threshold (* 10 1024 1024)))

(add-hook 'minibuffer-setup-hook #'juanleon/minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'juanleon/minibuffer-exit-hook)

(use-package python-switch-quotes
  :ensure t
  :bind ([(control c) ?'] . python-switch-quotes))
