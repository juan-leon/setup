
(global-set-key [(f2)] nil)

;;;; Global keys

;; Emacs functions
(global-set-key [(insert)]         'yank)
(global-set-key [(super insert)]   'overwrite-mode)
(global-set-key [(super a)]        'align)
(global-set-key [(super A)]        'align-regexp)
(global-set-key [(control f11)]    'kmacro-start-macro-or-insert-counter)
(global-set-key [(control f12)]    'kmacro-end-or-call-macro)
(global-set-key [(super y)]        'browse-kill-ring)
(global-set-key [(control delete)] 'kill-whole-line)
(global-set-key [(meta up)]        'backward-list)
(global-set-key [(meta down)]      'forward-list)
(global-set-key [(meta ?g)]        'goto-line)
(global-set-key [(super m)]        'man)
(global-set-key [(meta return)]    'find-tag)
(global-set-key [(control ?.)]     'tags-apropos)
(global-set-key [(super f)]        'auto-fill-mode)
(global-set-key [(menu)]           'menu-bar-open)
(global-set-key [(control ?ç)]     'make-frame)
(global-set-key [(control kp-1)]   'toggle-window-dedicated)
(global-set-key [(super z)]        'shell)
(global-set-key [(super g)]        'grep)
(global-set-key [(super i)]        'rgrep)
(global-set-key [(super l)]        'locate)
(global-set-key [(super L)]        'locate-with-filter)
(global-set-key [(pause)]          'delete-other-windows)
(global-set-key [(control f3)]     'ff-find-other-file)
(global-set-key [(f12)]            'gdb)
(global-set-key [(control l)]      'recenter)
(global-set-key [(super ?\")]      'swap-quotes)
(global-set-key [(meta ? )]        'cycle-spacing)


(and (fboundp 'cycle-spacing) (global-set-key (kbd "M-SPC") 'cycle-spacing))


(global-set-key [(control backspace)] (command (kill-line 0)))
(global-set-key [(super r)]           (command (revert-buffer nil t)))
(global-set-key [(control menu)]      (command (menu-bar-mode (if menu-bar-mode 0 1))))

(define-key emacs-lisp-mode-map [(f8)]
  (command (byte-compile-file (buffer-file-name))))

(mapc #'(lambda (arg) (global-set-key arg 'hippie-expand))
      '([(super tab)] [(meta ?º)] [(meta ?`)] [(meta VoidSymbol)] [(control VoidSymbol)]))

;; Fast bookmarks
(global-set-key [(control meta ?1)] (command (find-file init-loader-directory)))
(global-set-key [(control meta ?2)] (command (find-file "~/www")))
(global-set-key [(control meta ?3)] (command (find-file "~/cases")))
(global-set-key [(control meta ?4)] (command (find-file "/var/log/")))
(global-set-key [(control meta ?5)] (command (find-file "~/www/iats/code")))
(global-set-key [(control meta ?6)] (command (find-file "~/hacks")))

;; Changes in the default emacs behaviour
(global-set-key [(control z)]             'undo)
(global-set-key [(control x) ?k]          'kill-this-buffer)
(global-set-key [(control x) (control k)] 'kill-this-buffer)
(global-set-key [(control x) (control z)] 'shell)            ; fixme: reuse this


;; My randon functions
(global-set-key [(super f2)]                'toggle-truncate-lines)
(global-set-key [(control return)]          'find-anything-at-point)
(global-set-key [(super up)]                'prev-function-name-face)
(global-set-key [(super down)]              'next-function-name-face)
(global-set-key [(super ?\;)]               'leon/comment-or-uncomment-region)
(global-set-key [(control ?x) (control ?c)] 'close-frame)
(global-set-key [(super t)]                 'tmux-window-here)
(global-set-key [(super f1)]                'leon/toggle-underscore-syntax)
(global-set-key [(control ?x) (control ?r)] 'sudo-powerup)
(global-set-key [(control pause)]           'toggle-split)
(global-set-key [(super control backspace)] 'squealer/last-error)
(global-set-key [(super backspace)]         'squealer/list)
(global-set-key [(super return)]            'juanleon/browse-zeal)
(global-set-key [(super f5)]                'juanleon/copy-import)
(global-set-key (kbd "C-S-<mouse-1>")       'mc/add-cursor-on-click)
(global-set-key (kbd "C-c C-c M-x")         'execute-extended-command)
(global-set-key [(meta ?.)]                 'juanleon/find-tag-at-point)

(when (eq system-type 'darwin)
  (global-set-key [(home)] 'move-beginning-of-line)
  (global-set-key [(end)] 'end-of-line)
  (global-set-key [(shift hyper help)] 'yank))


(use-package bookmark
  :bind (([(super meta b)] . bookmark-bmenu-list)
         ([(super B)] . bookmark-set)))

(use-package subword
  :bind (([(meta left)]  . subword-backward)
         ([(meta right)] . subword-forward)))

(use-package golden-ratio
  :ensure t
  :bind ([(super ?8)] . golden-ratio-mode)
  :diminish golden-ratio-mode)

(use-package ibuffer
  :bind ([remap list-buffers] . ibuffer))

(use-package markdown-mode
  :ensure t
  :defer t)

(use-package multiple-cursors
  :ensure t
  :bind ([(control shift mouse-1)] . mc/add-cursor-on-click))

