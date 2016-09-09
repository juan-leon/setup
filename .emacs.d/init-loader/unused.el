;; Deactivated stuff.  Mostly things that need some polishing to be worth it
;; using it.


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
