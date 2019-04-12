;; Enable niceties
(mapc (lambda (mode) (funcall mode 1))
      '(column-number-mode auto-image-file-mode show-paren-mode size-indication-mode))


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
 recenter-positions              '(top middle bottom)
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

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

(defun juanleon/minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun juanleon/minibuffer-exit-hook ()
  (setq gc-cons-threshold (* 10 1024 1024)))

;; Trick to feel emacs more responsive when using minibuffer (specially with ivy
;; and long candidate lists)
(add-hook 'minibuffer-setup-hook #'juanleon/minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'juanleon/minibuffer-exit-hook)





(use-package ediff
  :defer t
  :init (setq-default ediff-ignore-similar-regions t)
  :custom
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-diff-options          " -bB "))


(use-package bm
  :ensure t
  :defer t
  :bind (([(control Scroll_Lock)] . bm-toggle)
         ([(shift Scroll_Lock)]   . bm-previous)
         ([(Scroll_Lock)]         . bm-next)))




(use-package back-button
  :ensure t
  :config (back-button-mode 1))

(use-package ag
  :ensure t
  :commands ag ag-regexp)



(use-package projectile-ripgrep
  :ensure t
  :after projectile
  :bind (:map projectile-command-map ([?0] . projectile-ripgrep)))



(use-package deadgrep
  :ensure t
  :commands deadgrep)


;; Cleaner modeline
(use-package minions
  :ensure t
  :config
  (minions-mode 1)
  (setq minions-mode-line-lighter "@"))
