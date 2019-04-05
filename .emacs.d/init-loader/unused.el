;; Deactivated stuff.  Mostly things that need some polishing to be worth it
;; using it or things I do not use anymore but I do not discard using again.


;; load-theme-buffer-local is not polished enough to be worth using it

(add-hook 'inferior-python-mode-hook
          (lambda nil
            (load-theme-buffer-local 'tango-dark (current-buffer))))
(add-hook 'shell-mode-hook
          (lambda nil
            (load-theme-buffer-local leon-dark-theme (current-buffer))))
(add-hook 'sql-interactive-mode
          (lambda nil
            (load-theme-buffer-local 'tango-dark (current-buffer))))



;; This is nice, and I leave here as example, but always end using
;; 'dired-at-other-repo

(setq popwin:special-display-config
  '(("*git-repositories*" :width 60)))

(require 'popwin)
(require 'button)
(popwin-mode 1)
(setq git-repositories
      (list
       "~/www/debhelpers"
       "~/www/githooktools"
       "~/www/iats/code"
       "~/www/iatsadmin"
       "~/www/iatsgithooks"
       "~/www/iatsreqs"
       "~/www/iatstesttools"
       "~/www/iatstools"
       "~/www/mergequeue"
       "~/www/sibyl"
       "~/www/squealer"
       "~/www/vagrant"
       "~/repos/git"
       )
      )

(defun select-git-repository-from-list()
  (interactive)
  (with-output-to-temp-buffer "*git-repositories*"
    (with-current-buffer "*git-repositories*"
      (dolist (repo git-repositories)
        (insert-text-button repo 'action `(lambda (x) (delete-window) (magit-status ,repo)))
        (newline)))))
(global-set-key (kbd "C-c \\") 'select-git-repository-from-list)


;; Useful, but I am using projectile for most of the stuff I need tags for.

(defun recreate-tags()
  (interactive)
  (projectile-with-default-dir (projectile-project-root)
    (ctags-create-or-update-tags-table)))

(global-set-key [(super T)] 'recreate-tags)


;; I am not using gdb nowadays

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


(eval-after-load "gdb-mi"
  '(add-hook 'gdb-mode-hook
             (lambda ()
               (setq comint-input-ring-file-name (concat user-emacs-directory "history/gdb"))
               (comint-read-input-ring t)
               (add-hook 'kill-buffer-hook 'comint-write-input-ring nil t))))


;; I am not using java/maven nowadays



(global-set-key [(meta f5)]
                (command (java-compile "pom.xml" "mvn clean install")))
(global-set-key [(meta f6)]
                (command (java-compile "build.xml" "ant undeploy ; mvn clean install && ant deploy")))
(global-set-key [(meta f7)]
                (command (java-compile "pom.xml" "mvn install")))
(global-set-key [(meta f8)]
                (command (java-compile "build.xml" "ant undeploy ; mvn install && ant deploy")))

;; Remove maven false positives
(add-hook 'compilation-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
               '(("^\\[?INFO.*"
                  (0 '(face nil font-lock-face nil
                       compilation-message nil help-echo nil mouse-face nil) t))
                 ("^	.*)$"
                  (0 '(face nil font-lock-face nil
                            compilation-message nil help-echo nil mouse-face nil) t)))
               'append)))



;; This is fixed, but my faith on PHP mode is not great
(eval-after-load "php-mode"
  '(progn
     (c-add-style
      "pear"
      '((c-basic-offset . 4)
        (c-offsets-alist . ((block-open . -)
                            (block-close . 0)
                            (topmost-intro-cont . (first c-lineup-cascaded-calls
                                                         php-lineup-arglist-intro))
                            (brace-list-intro . +)
                            (case-label . +)
                            (brace-list-entry . c-lineup-cascaded-calls)
                            (arglist-close . php-lineup-arglist-close)
                            (arglist-intro . php-lineup-arglist-intro)
                            (knr-argdecl . [0])
                            (statement-cont . (first c-lineup-cascaded-calls +))))))))


;; Never got used to speedbar

(global-set-key [(super s)] 'sr-speedbar-toggle)
(setq sr-speedbar-right-side nil)



;; Zeal and helm-dash are better
(add-hook 'java-mode-hook (lambda ()
                            (local-set-key [(f12)] 'browse-javadoc)))
(add-hook 'php-mode-hook (lambda ()
                            (local-set-key [(f12)] 'browse-php)))

(defun browse-javadoc ()
  (interactive)
  (let ((class (thing-at-point 'word)))
    (save-excursion
      (save-restriction
        (goto-char (point-min))
        (if (re-search-forward (concat "^import\s+\\(.*\\." class  "\\);$") nil t)
            (let ((url (concat "http://www.google.es/search?q=javadoc+"
                               (match-string 1)
                               "+overview+frames&btnI=")))
              (browse-url url))
          (message "No class at point"))))))

(defun browse-php (arg)
  (interactive (list (read-from-minibuffer "Enter symbol: " (thing-at-point 'word))))
  (browse-url (concat "http://us.php.net/manual-lookup.php?scope=quickref&pattern=" arg)))


;; Replaced by wrap-region, that is more easily configurable and matches the
;; main use I had for elec-pair
(use-package elec-pair
  :config
  (electric-pair-mode -1))


;; syntax tables look good; no need for custom code
(defun extended-word-at-point ()
  (let ((underscore-syntax (if (= (char-syntax ?_) ?_) "_" "w"))
        (dash-syntax (if (= (char-syntax ?-) ?_) "_" "w")))
    (modify-syntax-entry ?_ "w")
    (modify-syntax-entry ?- "w")
    (prog1
        (thing-at-point 'symbol)
      (modify-syntax-entry ?_ underscore-syntax)
      (modify-syntax-entry ?- dash-syntax))))


;; Replaced by squealer-mode
(defun squealer-last-error (&optional arg)
  (interactive "p")
  (or arg (setq arg 1))
  (let ((buf (get-buffer-create "*squealer*"))
        (inhibit-read-only t))
    (switch-to-buffer buf)
    (erase-buffer)
    (shell-command
     (format "echo \"SELECT description, stack FROM reportFullText ORDER BY reportId DESC LIMIT 1 OFFSET %d\" | mysql -u root squealer --pager=cat -r -s" (1- arg))
     buf
     buf)
    (compilation-mode)
    (make-local-variable 'compilation-error-regexp-alist)
    (add-to-list 'compilation-error-regexp-alist '("^#[0-9] \\[\\(/[^ ]*?\\):\\([0-9]+\\)\\]" 1 2))
    (add-to-list 'compilation-error-regexp-alist '("^#[0-9]+ \\(/[^ ]*?\\)(\\([0-9]+\\)):" 1 2))
    (add-to-list 'compilation-error-regexp-alist '("\\(/[^ ]*?\\):\\([0-9]+\\)$" 1 2))))


;; #+ORGTBL: SEND sample orgtbl-to-gfm
;; | mirror | before | after | 100 after / before - 100 |   |
;; |--------+--------+-------+--------------------------+---|
;; |      2 |     12 |    63 |                     425. |   |
;; |      6 |     17 |    35 |                105.88235 |   |
;; |      1 |     23 |    28 |                21.739130 |   |
;; |      3 |     53 |   124 |                133.96226 |   |
;; |      5 |     53 |    93 |                75.471698 |   |
;; |      4 |     55 |   106 |                92.727273 |   |
;; #+TBLFM: $4=100*($3/$2-1)


;; # BEGIN RECEIVE ORGTBL sample
;; | mirror | before | after | 100 after / before - 100 |  |
;; |--:|--:|--:|--:|---|
;; | 2 | 12 | 63 | 425. |  |
;; | 6 | 17 | 35 | 105.88235 |  |
;; | 1 | 23 | 28 | 21.739130 |  |
;; | 3 | 53 | 124 | 133.96226 |  |
;; | 5 | 53 | 93 | 75.471698 |  |
;; | 4 | 55 | 106 | 92.727273 |  |
;; # END RECEIVE ORGTBL sample


(defun orgtbl-to-gfm (table params)
  "Convert the Orgtbl mode TABLE to GitHub Flavored Markdown."
  (let* ((alignment (mapconcat (lambda (x) (if x "|--:" "|---"))
                               org-table-last-alignment ""))
         (params2
          (list :splice t
                :hline (concat alignment "|")
                :lstart "| " :lend " |" :sep " | ")))
    (orgtbl-to-generic table (org-combine-plists params2 params))))

;; counsel-dash is not my preferred solution
(defun juanleon/browse-zeal (symbol lang)
  (interactive (list
                (thing-at-point 'symbol)
                (cond
                 ((eq major-mode 'emacs-lisp-mode) "emacs")
                 ((eq major-mode 'js-mode) "javascript")
                 ((eq major-mode 'php-mode) "php")
                 ((eq major-mode 'python-mode) "python")
                 ((eq major-mode 'sql-mode) "mysql")
                 ((eq major-mode 'go-mode) "go")
                 ((eq major-mode 'sql-interactive-mode) "mysql")
                 ((eq major-mode 'sh-mode) "bash")
                 ((eq major-mode 'html-mode) "html")
                 ((eq major-mode 'ruby-mode) "ruby")
                 ((eq major-mode 'css-mode) "css"))
                ))
  (start-process "zeal" nil "zeal" "--query" (concat lang ":" symbol)))



;; I rarely used that anymore, replace bindings by move-line

(global-set-key [(super up)]                'prev-function-name-face)
(global-set-key [(super down)]              'next-function-name-face)

(defun next-function-name-face ()
  "Point to next `font-lock-function-name-face' text."
  (interactive)
  (let ((pos (point)))
    (if (eq (get-text-property pos 'face) 'font-lock-function-name-face)
        (setq pos (or (next-property-change pos) (point-max))))
    (setq pos (text-property-any pos (point-max) 'face
                                 'font-lock-function-name-face))
    (if pos
        (goto-char pos)
      (goto-char (point-max)))))

(defun prev-function-name-face ()
  "Point to previous `font-lock-function-name-face' text."
  (interactive)
  (let ((pos (point)))
    (if (eq (get-text-property pos 'face) 'font-lock-function-name-face)
        (setq pos (or (previous-property-change pos) (point-min))))
    (setq pos (previous-property-change pos))
    (while (and pos (not (eq (get-text-property pos 'face)
                             'font-lock-function-name-face)))
      (setq pos (previous-property-change pos)))
    (if pos
        (progn
          (setq pos (previous-property-change pos))
          (goto-char (or (and pos (1+ pos)) (point-min))))
      (goto-char (point-min)))))



;; subWord mode made me use this less and less, I suspect

(global-set-key [(super f1)]                'leon/toggle-underscore-syntax)

;; This way is easy to choose if "_" is a word separator
(defun leon/toggle-underscore-syntax ()
  "Switch the char _ in-word behaviour."
  (interactive)
  (modify-syntax-entry ?_ (if (= (char-syntax ?_) ?_) "w" "_"))
  (message (concat "\"_\" is " (if (= (char-syntax ?_) ?_) "symbol" "word"))))


;; packages disabled for a long timer

(use-package ctags
  :ensure t
  :disabled
  :bind ([(super f12)] . ctags-create-or-update-tags-table)
  :config
  (setq etags-table-search-up-depth 20
        tags-revert-without-query t)
  (setq ctags-command
        "find . -name  '*.[ch]' -o -name '*.java' -o -name '*.el' -o -name '*.php' -o -name '*.js' -o -name '*.py' | xargs etags"))

(use-package powerline
  :ensure t
  :disabled  ;; Incompatible with minions
  :config (powerline-center-theme))

(use-package ws-trim
  :ensure t
  :disabled  ;; Trying ws-butler
  :diminish ws-trim-mode
  :init (setq ws-trim-level 1
              ws-trim-method-hook '(ws-trim-trailing ws-trim-leading))
  :config (global-ws-trim-mode 1))

(use-package undo-tree
  :ensure t
  :disabled  ;; Using DO not play nice with undo in region
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t))

(use-package paradox
  :ensure t
  :commands paradox-list-packages
  :config
  (setq paradox-column-width-package 30)
  (setq paradox-display-download-count t))


;; I only use xwidget for dash

;; by default, xwidget reuses previous xwidget window,
;; thus overriding your current website, unless a prefix argument
;; is supplied
;;
;; This function always opens a new website in a new window
(defun xwidget-browse-url-no-reuse (url &optional new-session)
  (interactive (browse-url-interactive-arg "URL: "))
  (xwidget-webkit-browse-url url t))


;; ivy/counsel are fulfilling what they promise
(use-package ido
  :ensure t
  :defer nil
  :bind (([(control x) ?b] . ido-switch-buffer))
  :custom
  (ido-case-fold                nil)
  (ido-enable-tramp-completion  nil)
  (ido-save-directory-list-file (concat user-emacs-directory "history/ido"))
  (ido-auto-merge-delay-time    20)
  (ido-read-file-name-non-ido   '(dired-create-directory))
  :config
  (ido-mode 0))

(use-package flx-ido
  :ensure t
  :config (flx-ido-mode 1))

  (setq org-completion-use-ido t)


;; ivy/counsel are fulfilling what they promise
(use-package helm
  :ensure t
  :disabled
  :defer t)

(use-package helm-mode
  :defer t
  :disabled
  :diminish helm-mode)

(use-package helm-config  ;; used by helm-dash, used by counsel-dash
  :demand
  :disabled
  :init
  (setq helm-M-x-fuzzy-match           t
        helm-buffers-fuzzy-matching    t
        helm-full-frame                t
        helm-ff-skip-boring-files      t
        helm-buffer-max-length         80
        helm-echo-input-in-header-line t))


;; I don't use rope since a long time ago...
(defun use-ropemacs ()
  (interactive)
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/pymacs")
  (require 'pymacs)
  (pymacs-load "ropemacs" "rope-")
  (setq ropemacs-confirm-saving 'nil))

;; I am not using cmus nowadays... spotify got me
(defun cmus-increase-vol ()
  (interactive)
  (cmus-commmand "-v +10%"))

(defun cmus-decrease-vol ()
  (interactive)
  (cmus-commmand "-v -10%"))

(defun cmus-pause ()
  (interactive)
  (cmus-commmand "-u"))

(defun cmus-next ()
  (interactive)
  (cmus-commmand "-n"))

(defun cmus-replay ()
  (interactive)
  (cmus-commmand "-r"))

(defun cmus-commmand (command)
  (if (/= 0 (shell-command (concat "cmus-remote " command) nil "*cmus-error*"))
      (message "cmus error")))

  (defhydra hydra-cmus ()
    "CMUS control"
    ("+" cmus-increase-vol "+vol")
    ("-" cmus-decrease-vol "-vol")
    ("p" cmus-pause "pause" :exit t)
    ("n" cmus-next "next" :exit t)
    ("r" cmus-replay "replay" :exit t)
    ("q" nil "do nothing" :exit t)))

([(control f9)]  . hydra-cmus/body))
