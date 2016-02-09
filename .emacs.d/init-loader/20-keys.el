
;;;; Global keys

;; Emacs functions
(global-set-key [(insert)]                  'yank)
(global-set-key [(super insert)]            'overwrite-mode)
(global-set-key [(super a)]                 'align)
(global-set-key [(super A)]                 'align-regexp)
(global-set-key [(control f11)]             'kmacro-start-macro-or-insert-counter)
(global-set-key [(control f12)]             'kmacro-end-or-call-macro)
(global-set-key [(super y)]                 'browse-kill-ring)
(global-set-key [(control delete)]          'kill-whole-line)
(global-set-key [(meta up)]                 'backward-list)
(global-set-key [(meta down)]               'forward-list)
(global-set-key [(meta left)]               'subword-backward)
(global-set-key [(meta right)]              'subword-forward)
(global-set-key [(meta ?g)]                 'goto-line)
(global-set-key [(super m)]                 'man)
(global-set-key [(meta return)]             'find-tag)
(global-set-key [(control ?.)]              'tags-apropos)
(global-set-key [(super f)]                 'auto-fill-mode)
(global-set-key [(menu)]                    'menu-bar-open)
(global-set-key [(control ?ç)]              'new-frame)
(global-set-key [(control kp-1)]            'toggle-window-dedicated)
(global-set-key [(meta f4)]                 'sql-connect)
(global-set-key [(control c) ?l]            'org-store-link)
(global-set-key [(control c) ?a]            'org-agenda)
(global-set-key [(super o)]                 'org-iswitchb)
(global-set-key [(super z)]                 'shell)
(global-set-key [(super g)]                 'grep)
(global-set-key [(super i)]                 'rgrep)
(global-set-key [(super l)]                 'locate)
(global-set-key [(super L)]                 'locate-with-filter)
(global-set-key [(super b)]                 'bookmark-bmenu-list)
(global-set-key [(super B)]                 'bookmark-set)
(global-set-key [(pause)]                   'delete-other-windows)
(global-set-key [remap list-buffers]        'ibuffer)
(global-set-key [(control meta return)]     'ff-find-other-file)
(global-set-key [(control f3)   ]           'ff-find-other-file)
(global-set-key [(super ?+)]                'imenu-add-menubar-index)
(global-set-key [(control f4)]              'calendar)
(global-set-key [(f12)]                     'gdb)
(global-set-key [(control x) ?b]            'ido-switch-buffer)
(global-set-key [(meta kp-5)]               'ido-switch-buffer)
(global-set-key [(meta kp-begin)]           'ido-switch-buffer)
(global-set-key [(control l)]               'recenter)
(global-set-key [C-tab]                     'complete-tag)
(global-set-key (kbd "<C-S-s-up>")          'buf-move-up)
(global-set-key (kbd "<C-S-s-down>")        'buf-move-down)
(global-set-key (kbd "<C-S-s-left>")        'buf-move-left)
(global-set-key (kbd "<C-S-s-right>")       'buf-move-right)
(global-set-key [(super ?\")]               'swap-quotes)


(global-set-key [(control backspace)] (command (kill-line 0)))
(global-set-key [(super r)   ]        (command (revert-buffer nil t)))
(global-set-key [(control menu)]      (command
                                       (menu-bar-mode (if menu-bar-mode 0 1))))
(global-set-key [(super ?9)]
                (command
                 (if (not (equal ispell-local-dictionary juanleon/secondary-dictionary))
                     (ispell-change-dictionary juanleon/secondary-dictionary)
                   (ispell-change-dictionary juanleon/main-dictionary))))

(define-key emacs-lisp-mode-map [(f8)]
  (command (byte-compile-file (buffer-file-name))))

(mapc #'(lambda (arg) (global-set-key arg 'hippie-expand))
      '([(super tab)] [(meta ?º)] [(meta VoidSymbol)] [(control VoidSymbol)]))

;; Fast bookmarks
(global-set-key [(control meta ?1)] (command (find-file init-loader-directory)))
(global-set-key [(control meta ?2)] (command (find-file "~/www")))
(global-set-key [(control meta ?3)] (command (find-file "~/cases")))
(global-set-key [(control meta ?4)] (command (find-file "/var/log/")))
(global-set-key [(control meta ?5)] (command (find-file "~/www/iats/code")))
(global-set-key [(control meta ?6)] (command (find-file "~/hacks")))

;; Changes in the default emacs behaviour
(global-set-key [(control z)]             'undo)             ; I really hate to minimize emacs:
(global-set-key [(control x) ?k]          'kill-this-buffer) ; No more "¿which buffer?"
(global-set-key [(control x) (control k)] 'kill-this-buffer) ; No more "no keyboard macro defined"
(global-set-key [(control x) (control z)] 'shell)            ; fixme: reuse this


;; My randon functions
(global-set-key [(super f2)]                'toggle-truncate-lines)
(global-set-key [(control ~)]               'toggle-theme)
(global-set-key [(control return)]          'find-anything-at-point)
(global-set-key [(super up)]                'prev-function-name-face)
(global-set-key [(super down)]              'next-function-name-face)
(global-set-key [(super ?\;)]               'leon/comment-or-uncomment-region)
(global-set-key [(control ?x) (control ?c)] 'close-frame)
(global-set-key [(super t)]                 'tmux-window-here)
(global-set-key [(super f1)]                'leon/toggle-underscore-syntax)
(global-set-key [(control ?x) (control ?r)] 'sudo-powerup)
(global-set-key [(control pause)]           'toggle-split)
(global-set-key [(super backspace)]         'squealer-last-error)

;; Functions for loaded packages
(global-set-key [(super s)]             'sr-speedbar-toggle)
(global-set-key (kbd "C-S-<mouse-1>")   'mc/add-cursor-on-click)
(global-set-key [(super ?1)]            'er/expand-region)
(global-set-key (kbd "C-c C-c M-x")     'execute-extended-command)
(global-set-key [(super f12)]           'ctags-create-or-update-tags-table)
(global-set-key [(super ?-)]            'goto-last-change)
(global-set-key [(super ?_)]            'goto-last-change-reverse)
(global-set-key [(super ?ñ)]            'er/expand-region)


;;;; Local maps
(define-key isearch-mode-map [(control t)]    'isearch-toggle-case-fold)
(define-key isearch-mode-map [(control up)]   'isearch-ring-retreat)
(define-key isearch-mode-map [(control down)] 'isearch-ring-advance)


(eval-after-load "shell"
  '(progn
     (define-key shell-mode-map [(meta kp-up)] 'shell-rename)
     (define-key shell-mode-map [(meta kp-8)]  'shell-rename)))

(add-hook 'ido-mode-hook
          (lambda ()
            (define-key ido-file-completion-map [(shift left)]  'ido-prev-work-file)
            (define-key ido-file-completion-map [(shift right)] 'ido-next-work-file)
            (define-key ido-file-completion-map [(shift up)]    'ido-prev-work-directory)
            (define-key ido-file-completion-map [(shift down)]  'ido-next-work-directory)
            (define-key ido-file-completion-map [(~)]           (command (insert "~/")))))

(global-set-key [(super shift z)] 'browse-zeal)
(global-set-key [(super return)] 'browse-zeal-fast)

(add-hook 'java-mode-hook (lambda ()
                            (local-set-key [(f12)] 'browse-javadoc)))

(add-hook 'php-mode-hook (lambda ()
                            (local-set-key [(f12)] 'browse-php)))

(add-hook 'prog-mode-hook (lambda ()
                            (local-set-key [(f3)]      'hs-show-block)
                            (local-set-key [(meta f3)] 'hs-hide-block)))


(defvar compare-map
  (let ((map (make-sparse-keymap)))
    (define-key map "b" 'ediff-buffers)
    (define-key map "f" 'ediff-files)
    (define-key map "d" 'diff)
    (define-key map "w" 'compare-windows)
    (define-key map "v" 'vc-diff)
    map))
(global-set-key [(control ?=)] compare-map)

