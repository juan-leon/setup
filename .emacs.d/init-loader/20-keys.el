
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
(global-set-key [(meta return)]    'xref-find-definitions)
(global-set-key [(control ?.)]     'tags-apropos)
(global-set-key [(super f)]        'auto-fill-mode)
(global-set-key [(menu)]           'menu-bar-open)
(global-set-key [(control ?ç)]     'make-frame)
(global-set-key [(control ?')]     'make-frame)
(global-set-key [(control kp-1)]   'toggle-window-dedicated)
(global-set-key [(super z)]        'shell)
(global-set-key [(super g)]        'grep)
(global-set-key [(super i)]        'rgrep)
(global-set-key [(super l)]        'locate)
(global-set-key [(super L)]        'locate-with-filter)
(global-set-key [(pause)]          'delete-other-windows)
(global-set-key [(control f3)]     'ff-find-other-file)
(global-set-key [(f12)]            'gdb)
(global-set-key [(meta ? )]        'cycle-spacing)
(global-set-key [(super ?#)]       'juanleon/done-with-file)
(global-set-key (kbd "M-SPC")      'cycle-spacing)


(global-set-key [(control backspace)] (command (kill-line 0)))
(global-set-key [(control menu)] 'menu-bar-mode)

(define-key emacs-lisp-mode-map [(f8)]
  (command (byte-compile-file (buffer-file-name))))

;; Changes in the default emacs behaviour
(global-set-key [(control z)]             'undo)
(global-set-key [(control x) ?k]          'kill-this-buffer)
(global-set-key [(control x) (control k)] 'kill-this-buffer)
(global-set-key [(control x) (control z)] 'shell)            ; fixme: reuse this


;; My randon functions
(global-set-key [(super ?\;)]               'juanleon/comment-or-uncomment-region)
(global-set-key [(control ?x) (control ?c)] 'close-frame)    ; No accidental emacs kills
(global-set-key [(super t)]                 'tmux-window-here)
(global-set-key [(control ?x) (control ?r)] 'sudo-powerup)
(global-set-key [(control pause)]           'toggle-split)
(global-set-key [(super control backspace)] 'squealer/last-error)
(global-set-key [(super backspace)]         'squealer/list)
(global-set-key [(meta ?.)]                 'juanleon/find-tag-at-point)

(when (eq system-type 'darwin)
  (global-set-key [(home)] 'move-beginning-of-line)
  (global-set-key [(end)] 'end-of-line)
  (global-set-key [(shift hyper help)] 'yank))


(use-package bookmark
  :bind (([(super meta b)] . bookmark-bmenu-list)
         ([(super B)] . bookmark-set)))

(use-package golden-ratio
  :ensure t
  :commands golden-ratio-mode)

(use-package ibuffer
  :bind ([remap list-buffers] . ibuffer)
  :custom
  (ibuffer-formats '((mark modified read-only
                           " " (name 42 42)
                           " " (size 9 9 :right)
                           " " (mode 21 21 :left :elide)
                           " " filename-and-process)
                     (mark " " (name 30 -1) " " filename))))

(use-package markdown-mode
  :ensure t
  :defer t
  :custom (markdown-gfm-additional-languages '("bash")))


(use-package helpful
  :ensure t
  :bind (([(control ?h) ?f]  . helpful-callable)
         ([(control ?h) ?v]  . helpful-variable)
         ([(control ?h) ?k]  . helpful-key)
         ([(control return)] . helpful-at-point)))
