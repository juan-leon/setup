;; For shorter keybindings
(defmacro command (&rest body)
  `(lambda ()
     (interactive)
     ,@body))

(global-set-key [(f2)] nil)

;;;; Global keys

;; Emacs functions
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
(global-set-key [(control next)]            'windmove-down)
(global-set-key [(control prior)]           'windmove-up)
(global-set-key [(control kp-6)]            'windmove-right)
(global-set-key [(control kp-4)]            'windmove-left)
(global-set-key [(control kp-right)]        'windmove-right)
(global-set-key [(control kp-left)]         'windmove-left)
(global-set-key [(pause)]                   'delete-other-windows)
(global-set-key [remap list-buffers]        'ibuffer)
(global-set-key [(control meta return)]     'ff-find-other-file)
(global-set-key [(control f3)   ]           'ff-find-other-file)
(global-set-key [(super ?+)]                'imenu-add-menubar-index)
(global-set-key [(control f4)]              'calendar)
(global-set-key [(f8)]                      'compile)
(global-set-key [(control f6)]              'recompile)
(global-set-key [(super f7)]                'previous-error)
(global-set-key [(super f8)]                'next-error)
(global-set-key [(super kp-8)]              'previous-error)
(global-set-key [(super kp-2)]              'next-error)
(global-set-key [(super meta f7)]           'previous-error-no-select)
(global-set-key [(super meta f8)]           'next-error-no-select)
(global-set-key [(f12)]                     'gdb)
(global-set-key [(control x) ?b]            'ido-switch-buffer)
(global-set-key [(meta kp-5)]               'ido-switch-buffer)
(global-set-key [(meta kp-begin)]           'ido-switch-buffer)
(global-set-key [(super home)]              'rotate-layout)
(global-set-key [(super end)]               'rotate-window)
(global-set-key [(control l)]               'recenter)
(global-set-key [(control ?x) (control ?d)] 'dired-jump)
(global-set-key [C-tab]                     'complete-tag)


(global-set-key [(control backspace)] (command (kill-line 0)))
(global-set-key [(super r)   ]        (command (revert-buffer nil t)))
(global-set-key [(control f8)]        (command
                                       (let ((buf (get-buffer "*compilation*")))
                                         (and buf (switch-to-buffer buf)))))
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

;; Changes in the default emacs behaviour
(global-set-key [(control z)]             'undo)             ; I really hate to minimize emacs:
(global-set-key [(control x) ?k]          'kill-this-buffer) ; No more "¿which buffer?"
(global-set-key [(control x) (control k)] 'kill-this-buffer) ; No more "no keyboard macro defined"
(global-set-key [(control x) (control z)] 'shell)            ; fixme: reuse this
;; (global-set-key [(meta o)]                'subword-downcase)
;; (global-set-key [(meta h)]                'left-char)        ; VI movement with Meta
;; (global-set-key [(meta j)]                'next-line)
;; (global-set-key [(meta k)]                'previous-line)
;; (global-set-key [(meta l)]                'right-char)


;; My randon functions
(global-set-key [(super f2)]                'toggle-truncate-lines)
(global-set-key [(control ~)]               'toggle-theme)
(global-set-key [(control return)]          'find-anything-at-point)
(global-set-key [(super up)]                'prev-function-name-face)
(global-set-key [(super down)]              'next-function-name-face)
(global-set-key [(super ?\;)]               'leon/comment-or-uncomment-region)
(global-set-key [(control ?x) (control ?c)] 'close-frame)
(global-set-key [(super t)]                 'tmux-window-here)
(global-set-key [(control meta ?0)]         'dired-at-repo)
(global-set-key [(super f1)]                'leon/toggle-underscore-syntax)
(global-set-key [(control ?x) (control ?r)] 'sudo-powerup)
(global-set-key [(super u)]                 'dired-recursive-by-extension)
(global-set-key [(super U)]                 'dired-recursive-by-extension-no-target)
(global-set-key [(control pause)]           'toggle-split)
(global-set-key [(super backspace)]         'squealer-last-error)


(global-set-key [(meta f5)]
                (command (java-compile "pom.xml" "mvn clean install")))
(global-set-key [(meta f6)]
                (command (java-compile "build.xml" "ant undeploy ; mvn clean install && ant deploy")))
(global-set-key [(meta f7)]
                (command (java-compile "pom.xml" "mvn install")))
(global-set-key [(meta f8)]
                (command (java-compile "build.xml" "ant undeploy ; mvn install && ant deploy")))

;; Functions for loaded packages
(global-set-key [(super s)]             'sr-speedbar-toggle)
(global-set-key (kbd "C-S-<mouse-1>")   'mc/add-cursor-on-click)
(global-set-key [(super ?1)]            'er/expand-region)
(global-set-key (kbd "M-x")             'smex)
(global-set-key (kbd "M-X")             'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x")     'execute-extended-command)
(global-set-key [(super ?0)]            'magit-status)
(global-set-key [(super ?q)]            'magit-status)
(global-set-key [(control Scroll_Lock)] 'bm-toggle)
(global-set-key [(shift Scroll_Lock)]   'bm-previous)
(global-set-key [(Scroll_Lock)]         'bm-next)
(global-set-key [(super f12)]           'ctags-create-or-update-tags-table)

;;;; Local maps
(define-key isearch-mode-map [(control t)]    'isearch-toggle-case-fold)
(define-key isearch-mode-map [(control up)]   'isearch-ring-retreat)
(define-key isearch-mode-map [(control down)] 'isearch-ring-advance)

(eval-after-load "winner"
  '(progn
     (define-key winner-mode-map [(super prior)] 'winner-undo)
     (define-key winner-mode-map [(super next)]  'winner-redo)))

(eval-after-load "help-mode"
  '(progn
     (define-key help-mode-map [backspace]    'help-go-back)
     (define-key help-mode-map [(meta left)]  'help-go-back)
     (define-key help-mode-map [(meta right)] 'help-go-forward)))

(eval-after-load "magit"
  '(progn
     (define-key magit-status-mode-map [(control ?c) (control ?r)]
       (command (magit-git-command "create-review" (magit-get-top-dir))))
     (define-key magit-status-mode-map [backspace] 'magit-in-supermodule)))

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

(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map [?r] 'wdired-change-to-wdired-mode)
     (define-key dired-mode-map [?U] 'dired-unmark-backward)
     (define-key dired-mode-map [?a] 'leon/dired-hide-hidden)
     (define-key dired-mode-map [f2] 'dired-efap)
     (define-key dired-mode-map [down-mouse-1] 'dired-efap-click)
     (define-key dired-mode-map [(control return)] 'dired-find-alternate-file)
     (define-key dired-mode-map [(backspace)] 'dired-jump)
     (define-key dired-mode-map [(control backspace)] 'dired-unmark-backward)))

(global-set-key [(super shift z)] 'browse-zeal)
(global-set-key [(super return)] 'browse-zeal-fast)

(setq projectile-keymap-prefix (kbd "C-p"))

(add-hook 'java-mode-hook (lambda ()
                            (local-set-key [(f12)] 'browse-javadoc)))

(add-hook 'php-mode-hook (lambda ()
                            (local-set-key [(f12)] 'browse-php)))

(add-hook 'prog-mode-hook (lambda ()
                            (local-set-key [(f3)]      'hs-show-block)
                            (local-set-key [(meta f3)] 'hs-hide-block)))

;; Fast switching buffers in same window
(if (require 'buffer-stack nil t)
    (progn
      (add-to-list 'buffer-stack-untracked "*Backtrace*")
      (global-set-key [(meta kp-4)]     'buffer-stack-up)
      (global-set-key [(meta kp-left)]  'buffer-stack-up)
      (global-set-key [(meta kp-6)]     'buffer-stack-down)
      (global-set-key [(meta kp-right)] 'buffer-stack-down)
      (global-set-key [(meta kp-2)]     'buffer-stack-bury)
      (global-set-key [(meta kp-down)]  'buffer-stack-bury)
      (global-set-key [(meta kp-8)]     'buffer-stack-untrack)
      (global-set-key [(meta kp-up)]    'buffer-stack-untrack)
      (defvar buffer-stack-mode)
      (defun buffer-op-by-mode (op &optional mode)
        (let ((buffer-stack-filter 'buffer-stack-filter-by-mode)
              (buffer-stack-mode (or mode major-mode)))
          (funcall op)))
      (defun buffer-stack-filter-by-mode (buffer)
        (with-current-buffer buffer
          (equal major-mode buffer-stack-mode)))
      (global-set-key [(meta kp-7)]
                      (command (buffer-op-by-mode 'buffer-stack-up)))
      (global-set-key [(meta kp-9)]
                      (command (buffer-op-by-mode 'buffer-stack-down)))
      (global-set-key [(meta kp-3)]
                      (command (buffer-op-by-mode 'buffer-stack-down 'dired-mode)))
      (global-set-key [(meta kp-1)]
                      (command (buffer-op-by-mode 'buffer-stack-up 'dired-mode))))
  (progn
    (global-set-key [(meta kp-4)]     'bury-buffer)
    (global-set-key [(meta kp-6)]     'bury-buffer)
    (global-set-key [(meta kp-left)]  'bury-buffer)
    (global-set-key [(meta kp-right)] 'bury-buffer)))

(defvar compare-map
  (let ((map (make-sparse-keymap)))
    (define-key map "b" 'ediff-buffers)
    (define-key map "f" 'ediff-files)
    (define-key map "d" 'diff)
    (define-key map "w" 'compare-windows)
    (define-key map "v" 'vc-diff)
    map))
(global-set-key [(control ?=)] compare-map)

(eval-after-load "gdb-mi"
  '(progn
     (global-set-key [(f5)]      'leon/gud-print)
     (global-set-key [(meta f5)] 'leon/gud-print-ref)
     (global-set-key [(f6)]      'leon/gud-up)
     (global-set-key [(meta f6)] 'leon/gud-down)
     (global-set-key [(f7)]      'leon/gud-next)
     (global-set-key [(meta f7)] 'leon/gud-step)
     (gud-def leon/gud-print      "print %e"   nil)
     (gud-def leon/gud-print-ref  "print * %e" nil)
     (gud-def leon/gud-next       "next"       nil)
     (gud-def leon/gud-step       "step"       nil)
     (gud-def leon/gud-cont       "cont"       nil)
     (gud-def leon/gud-run        "run"        nil)
     (gud-def leon/gud-up         "up"         nil)
     (gud-def leon/gud-down       "down"       nil)
     (add-hook 'gdb-mode-hook
               (lambda ()
                 (local-set-key  [(f4)]      'gdb-many-windows)
                 (local-set-key  [(meta f4)] 'gdb-restore-windows)
                 (local-set-key  [(f8)]      'leon/gud-cont)
                 (local-set-key  [(meta f8)] 'leon/gud-run)))))
