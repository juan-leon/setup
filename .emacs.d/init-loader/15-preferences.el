;; Enable niceties
(mapc (lambda (mode) (funcall mode 1))
      '(column-number-mode auto-image-file-mode show-paren-mode size-indication-mode))


(fset 'yes-or-no-p 'y-or-n-p)

(setq-default
 indent-tabs-mode                nil
 tab-width                       4
 fill-column                     80
 truncate-lines                  t)

(setq
 disabled-command-function       nil ; Warnings already read
 garbage-collection-messages     t
 inhibit-startup-screen          t
 initial-scratch-message         nil
 message-log-max                 2500
 scroll-step                     1
 scroll-conservatively           1
 scroll-preserve-screen-position 'in-place
 text-scale-mode-step            1.1
 warning-suppress-types          '((undo discard-info)))


(defun juanleon/minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun juanleon/minibuffer-exit-hook ()
  (setq gc-cons-threshold (* 10 1024 1024)))

;; Trick to feel emacs more responsive when using minibuffer (specially with ivy
;; and long candidate lists)
(add-hook 'minibuffer-setup-hook #'juanleon/minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'juanleon/minibuffer-exit-hook)


(use-package simple
  :bind (([(control backspace)] . kill-line-0) ; It lives in my fingers
         ([(insert)] . yank)
         ([(super insert)] . overwrite-mode)
         ([(control delete)] . kill-whole-line)
         ([(super f)] . auto-fill-mode)
         ([(meta ?g)] . goto-line)
         ([(meta ? )] . cycle-spacing)
         ;; Changes in the default emacs behaviour
         ([(control z)] . undo)
         ([(control x) (control k)] . juanleon/kill-this-buffer)
         ([(control x) ?k] . juanleon/kill-this-buffer))
  :init
  (add-hook 'text-mode-hook 'turn-on-auto-fill)
  (setq kill-do-not-save-duplicates t
        kill-ring-max 100
        track-eol t
        undo-ask-before-discard nil)
  (defun kill-line-0 ()
    (interactive)
    (kill-line 0))

  (defun juanleon/kill-this-buffer ()
    (interactive)
    (cond
     ((window-minibuffer-p) (abort-recursive-edit))
     (t (kill-buffer (current-buffer))))))

(when (eq system-type 'darwin)
  (global-set-key [(home)] 'move-beginning-of-line)
  (global-set-key [(end)] 'end-of-line)
  (global-set-key [(shift hyper help)] 'yank))
