;; For shorter keybindings
(defmacro command (&rest body)
  `(lambda ()
     (interactive)
     ,@body))

(global-set-key [(f2)] nil)



(setq-default
 indent-tabs-mode                   nil
 tab-width                          4
 fill-column                        80
 case-fold-search                   nil
 search-ring-update                 t
 save-place                         t
 truncate-lines                     t)

(setq
 align-to-tab-stop                  nil
 auto-save-default                  nil
 backup-directory-alist             `(("" . ,(concat user-emacs-directory "/autosaved/")))
 browse-url-browser-function        'browse-url-chromium
 calendar-week-start-day            1
 calendar-mark-holidays-flag        t
 comint-input-ignoredups            t
 comint-use-prompt-regexp           nil  ; Weird bugs otherwise
 confirm-kill-emacs                 'y-or-n-p ; "Fast fingers protection"
 disabled-command-function          nil ; Warnings already read
 garbage-collection-messages        t
 ido-case-fold                      nil
 ido-enable-tramp-completion        nil
 ido-save-directory-list-file       (concat user-emacs-directory "history/ido")
 ido-auto-merge-delay-time          20
 ido-slow-ftp-host-regexps          '(".")
 ido-read-file-name-non-ido         '(dired-create-directory)
 inhibit-startup-message            t
 initial-scratch-message            nil
 isearch-allow-scroll               t
 jit-lock-stealth-time              5
 jit-lock-stealth-nice              0.25
 kill-do-not-save-duplicates        t
 kill-ring-max                      100
 major-mode                         'text-mode
 Man-notify-method                  'pushy
 message-log-max                    2500
 nxml-child-indent                  tab-width
 recentf-save-file                  (concat user-emacs-directory ".recentf")
 require-final-newline              t
 save-place-file                    (concat user-emacs-directory "history/places")
 search-ring-max                    32
 scroll-step                        1
 scroll-conservatively              1
 scroll-preserve-screen-position    'in-place
 text-scale-mode-step               1.1
 track-eol                          t
 undo-ask-before-discard            nil
 visible-bell                       t
 warning-suppress-types             '((undo discard-info))
 whitespace-line-column             100
 x-select-enable-primary            t
 x-select-enable-clipboard          t
 yascroll:delay-to-hide             nil)

(setq ibuffer-formats '((mark modified read-only
                              " " (name 35 35)
                              " " (size 9 9 :right)
                              " " (mode 18 18 :left :elide)
                              " " filename-and-process)
                        (mark " " (name 30 -1) " " filename)))


(column-number-mode       1)
(recentf-mode             1)
(auto-image-file-mode     1)
(show-paren-mode          1)
(size-indication-mode     1)
(file-name-shadow-mode    1)
(temp-buffer-resize-mode  1)
(global-yascroll-bar-mode 1)
(ido-mode                 1)
(ido-everywhere           1)
(flx-ido-mode             1)
(back-button-mode         1)
(electric-pair-mode       1)
(global-anzu-mode         1)
; fixme (desktop-save-mode        1)


(require 'saveplace)
(require 'scroll-in-place)
(require 'buffer-move)



(use-package ws-trim
  :ensure t
  :diminish ws-trim-mode
  :init (setq ws-trim-level 1
              ws-trim-method-hook '(ws-trim-trailing ws-trim-leading))
  :config (global-ws-trim-mode 1))

(use-package uniquify
  :init (setq-default uniquify-buffer-name-style 'post-forward-angle-brackets))


(use-package ediff
  :defer t
  :init
  (setq-default ediff-ignore-similar-regions t)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain
        ediff-split-window-function 'split-window-horizontally
        ediff-diff-options          " -bB "))


(use-package smex
  :ensure t
  :init (setq smex-save-file (concat user-emacs-directory ".smex-items"))
  :bind (([(meta x)] . smex)
         ([(meta X)] . smex-major-mode-commands))
  :config (smex-auto-update 60))

(use-package winner
  :config
  (winner-mode 1)
  (define-key winner-mode-map [(super prior)] 'winner-undo)
  (define-key winner-mode-map [(super next)]  'winner-redo))


(use-package ack-and-a-half
  :commands ack-and-a-half)

(use-package bm
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
  :init
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

