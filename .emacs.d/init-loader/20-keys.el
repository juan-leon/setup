
(global-set-key [(f2)] nil)

;;;; Global keys

;; Emacs functions
(global-set-key [(insert)]         'yank)
(global-set-key [(super insert)]   'overwrite-mode)
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
(global-set-key [(super g)]        'grep)
(global-set-key [(super i)]        'rgrep)
(global-set-key [(super l)]        'locate)
(global-set-key [(super L)]        'locate-with-filter)
(global-set-key [(control f3)]     'ff-find-other-file)
(global-set-key [(meta ? )]        'cycle-spacing)


(global-set-key [(control backspace)] (command (kill-line 0)))


;; Changes in the default emacs behaviour
(global-set-key [(control z)]             'undo)
(global-set-key [(control x) ?k]          'kill-this-buffer)
(global-set-key [(control x) (control k)] 'kill-this-buffer)


;; My randon functions
(global-set-key [(super ?\;)]               'juanleon/comment-or-uncomment-region)
(global-set-key [(super t)]                 'juanleon/tmux-window-here)
(global-set-key [(control ?x) (control ?r)] 'juanleon/sudo-powerup)
(global-set-key [(meta ?.)]                 'juanleon/find-tag-at-point)

(when (eq system-type 'darwin)
  (global-set-key [(home)] 'move-beginning-of-line)
  (global-set-key [(end)] 'end-of-line)
  (global-set-key [(shift hyper help)] 'yank))


(use-package bookmark
  :bind (([(super meta b)] . bookmark-bmenu-list)
         ([(super B)]      . bookmark-set)))


(use-package ibuffer
  :bind ([remap list-buffers] . ibuffer)
  :custom
  (ibuffer-formats '((mark modified read-only
                           " " (name 42 42)
                           " " (size 9 9 :right)
                           " " (mode 21 21 :left :elide)
                           " " filename-and-process)
                     (mark " " (name 30 -1) " " filename))))


