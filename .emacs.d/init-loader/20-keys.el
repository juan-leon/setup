
(global-set-key [(f2)] nil)  ;; I am not a 2C user

;;;; Global keys

;; Emacs functions
(global-set-key [(meta up)]        'backward-list)
(global-set-key [(meta down)]      'forward-list)
(global-set-key [(meta return)]    'xref-find-definitions)
(global-set-key [(control ?.)]     'tags-apropos)


;; My randon functions
(global-set-key [(super t)]                 'juanleon/tmux-window-here)
(global-set-key [(control ?x) (control ?r)] 'juanleon/sudo-powerup)
(global-set-key [(meta ?.)]                 'juanleon/find-tag-at-point)

(when (eq system-type 'darwin)
  (global-set-key [(home)] 'move-beginning-of-line)
  (global-set-key [(end)] 'end-of-line)
  (global-set-key [(shift hyper help)] 'yank))


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


(use-package man
  :bind (([(super m)] . man))
  :config (setq Man-notify-method 'pushy))
