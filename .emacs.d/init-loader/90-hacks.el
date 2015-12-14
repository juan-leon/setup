(setenv "PATH" "/home/juanleon/bin/git/bin:$PATH" t)
(fset 'yes-or-no-p 'y-or-n-p)

(defadvice x-set-selection (after replicate-selection (type data) activate)
  "Different applications use different data sources"
  (if (equal type 'CLIPBOARD)
      (x-set-selection 'PRIMARY data)))

(defadvice windmove-do-window-select (around silent-windmove activate)
  "Do not beep when no suitable window is found."
  (condition-case () ad-do-it (error nil)))


(eval-after-load "comint"
  '(defadvice comint-previous-input (around move-free (arg) activate)
     "No more 'Not at command line'"
     (if (comint-after-pmark-p)
         (progn
           ad-do-it)
       (backward-paragraph arg))))

;;; Uncluttering modeline:

(mapc (lambda (x)
        (eval-after-load (car x)
          `(diminish (quote ,(cdr x)))))
      '(("autorevert"  . auto-revert-mode)
        ("ws-trim"     . ws-trim-mode)
        ("anzu"        . anzu-mode)
        ("back-button" . back-button-mode)
        ("button-lock" . button-lock-mode)
        ("button-lock" . button-lock-mode)
        ;; ("magit" . magit-auto-revert-mode)
        ("hideshow"    . hs-minor-mode)))


(defun tasks ()
  "Toggle vertical/horizontal window split."
  (interactive)
  (delete-other-windows)
  (split-window-right)
  (other-window 1)
  (find-file "~/org/good-news.org")
  (split-window-vertically)
  (find-file "~/org/tomorrow.org")
  (split-window-vertically)
  (find-file "~/org/today.org")
  (other-window 2)
  (split-window-vertically)
  (find-file "~/org/pending.org"))

(global-set-key [(super ?º)] 'tasks)
(setq projectile-globally-ignored-files nil)
(global-set-key [(super ?k)] 'projectile-ack)

(add-hook 'php-mode-hook (lambda ()
                           (local-set-key [(?º)] (command (insert "$")))))



(setq popwin:special-display-config
  '(;; Emacs
    ("*git-repositories*" :width 60)))

(require 'popwin)
(require 'button)
(popwin-mode 1)
(setq git-repositories
      (list
       "~/www/debhelpers"
       "~/www/githooktools"
       "~/www/iats/code"
       "~/www/iatsadmin"
       "~/www/iatsgit"
       "~/www/iatsgithooks"
       "~/www/iatsqa"
       "~/www/iatsreqs"
       "~/www/iatstesttools"
       "~/www/iatstools"
       "~/www/mergequeue"
       "~/www/sibyl"
       "~/www/squealer"
       "~/www/vagrant"
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

(key-chord-mode 1)
(key-chord-define-global "º1" 'ace-jump-line-mode)
(key-chord-define-global "<z" 'ace-jump-char-mode)
(key-chord-define-global "zx" 'ace-jump-word-mode)
(setq ace-jump-mode-scope 'frame)

(setq jedi:tooltip-method nil)

(and (fboundp 'cycle-spacing) (global-set-key (kbd "M-SPC") 'cycle-spacing))

(desktop-save-mode 1)


(defun dired-at-other-repo ()
  (interactive)
  (with-temp-buffer
    (cd "~/www")
    (ido-dired)))

(global-set-key [(control meta ?')] 'dired-at-other-repo)



(defun recreate-tags()
  (interactive)
  (projectile-with-default-dir (projectile-project-root)
    (ctags-create-or-update-tags-table)))

(global-set-key [(super T)] 'recreate-tags)


(setq projectile-make-test-cmd "tools/runUnitTests")

(add-hook 'comint-mode-hook (lambda () (ws-trim-mode 0)))

(add-hook 'git-commit-mode-hook (lambda () (flyspell-mode 1)))




(defun open-test-file ()
  (interactive)
  (let* ((lang (completing-read "Language: " '("py" "php" "sh" "ruby")))
         (filename
          (replace-regexp-in-string
           "\n$" "" (shell-command-to-string (concat "test-file " lang)))))
    (find-file filename)))


(add-hook 'inferior-python-mode-hook
          (lambda nil
            (load-theme-buffer-local 'tango-dark (current-buffer))))

(add-hook 'shell-mode-hook
          (lambda nil
            (load-theme-buffer-local leon-dark-theme (current-buffer))))

(add-hook 'sql-interactive-mode
          (lambda nil
            (load-theme-buffer-local 'tango-dark (current-buffer))))


(global-set-key [(super ?-)] 'goto-last-change)
(global-set-key [(super ?_)] 'goto-last-change-reverse)
(global-set-key [(super ?ñ)] 'er/expand-region)
(global-set-key [(super ?j)] 'avy-goto-word-1)
(global-anzu-mode)
