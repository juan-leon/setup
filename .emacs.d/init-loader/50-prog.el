
(setq fixme-mode-warning-words '("FIXME" "TODO" "fixme" "HACK" "NOCOMMIT"))

(add-hook 'prog-mode-hook (lambda ()
                            (subword-mode  1)
                            (fixme-mode    1)
                            (hs-minor-mode 1)))


(defun delete-trailing-blank-lines ()
  "Deletes all blank lines at the end of the file."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))


(add-hook 'python-mode-hook (lambda ()
                              (jedi:setup)
                              (setq tab-width 4)
                              (add-hook 'before-save-hook 'delete-trailing-blank-lines nil 'local)
                              (setq fill-column 79)))

(eval-after-load "cc-mode"
  '(progn
     (defun leon/c-mode-setup ()
       (setq indicate-empty-lines t)
       (c-toggle-electric-state t)
       (c-toggle-hungry-state t)
       (setq c-basic-offset 4)
       (setq ff-search-directories '("." "include" "../include")))
     (add-hook 'c-mode-common-hook 'leon/c-mode-setup)
     (add-hook 'java-mode-hook (lambda ()
                                 (setq c-basic-offset 4
                                       tab-width 4
                                       indent-tabs-mode t)))
    (when (require 'xcscope nil t)
      (cscope-setup))
     (when (require 'ctags nil t)
       (setq tags-revert-without-query t)
       (setq ctags-command
             "find . -name  '*.[ch]' -o -name '*.java' -o -name '*.el' -o -name '*.php' -o -name '*.js' -o -name '*.py' | xargs etags"))
     (when (require 'etags-table nil t)
       (setq etags-table-search-up-depth 20))
     (c-set-offset 'case-label '+)
     (c-set-offset 'substatement-open 0)))

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(add-to-list 'auto-mode-alist '("\\.pp\\'" . puppet-mode))
(add-to-list 'auto-mode-alist '("\\.js.template\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(setq projectile-switch-project-action 'projectile-dired
      projectile-mode-line '(:eval (format " P[%s]" (projectile-project-name)))
      projectile-tags-command "ctags-exuberant -Re -f \"%s\" %s")
(projectile-global-mode)

;; fixme flymake fails more often than not (add-hook 'php-mode-hook 'flymake-mode)
(add-hook 'php-mode-hook '(lambda () (setq require-final-newline t)))

;; fixed!
; (eval-after-load "php-mode"
;   '(progn
;      (c-add-style
;       "pear"
;       '((c-basic-offset . 4)
;         (c-offsets-alist . ((block-open . -)
;                             (block-close . 0)
;                             (topmost-intro-cont . (first c-lineup-cascaded-calls
;                                                          php-lineup-arglist-intro))
;                             (brace-list-intro . +)
;                             (case-label . +)
;                             (brace-list-entry . c-lineup-cascaded-calls)
;                             (arglist-close . php-lineup-arglist-close)
;                             (arglist-intro . php-lineup-arglist-intro)
;                             (knr-argdecl . [0])
;                             (statement-cont . (first c-lineup-cascaded-calls +))))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Compilation

(setq compilation-scroll-output t
      next-error-highlight-no-select 2.0
      next-error-highlight 'fringe-arrow)

(add-hook 'compilation-finish-functions 'notify-compilation-end)

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Debugging


(eval-after-load "gdb-mi"
  '(add-hook 'gdb-mode-hook
             (lambda ()
               (setq comint-input-ring-file-name (concat user-emacs-directory "history/gdb"))
               (comint-read-input-ring t)
               (add-hook 'kill-buffer-hook 'comint-write-input-ring nil t))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Git


(add-to-list 'load-path "/usr/share/git-core/emacs" t)
(autoload 'git-blame-mode "git-blame" nil t)

(eval-after-load "magit"
  '(progn
     (setq magit-save-some-buffers nil
           magit-completing-read-function 'magit-ido-completing-read
           magit-diff-refine-hunk nil)
     (add-hook 'commit-mode-hook
               (lambda ()
                 (flyspell-mode 1)
                 (setq fill-column 70)))
     (autoload 'magit-rockstar "magit-rockstar" nil t)
     (autoload 'magit-reshelve "magit-rockstar" nil t)
     (magit-define-popup-action 'magit-rebase-popup
       ?R "Rockstar" 'magit-rockstar)
     (magit-define-popup-action 'magit-commit-popup
       ?n "Reshelve" 'magit-reshelve)
     (defun magit-copy-buffer-revision (beg end &optional region)
       (interactive (list (mark) (point)
                          (prefix-numeric-value current-prefix-arg)))
       (kill-ring-save beg end region))
     (setq magit-push-always-verify nil)
     (setq git-commit-summary-max-length 70)))

; (add-hook 'git-commit-kill-buffer-hook
;           '(lambda ()
;              (make-local-variable 'server-done-hook)
;              (remove-hook 'server-done-hook 'delete-frame t)))
