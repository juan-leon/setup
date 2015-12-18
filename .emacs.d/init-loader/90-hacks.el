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
        ("hideshow"    . hs-minor-mode)))


(defun tasks ()
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

(add-hook 'php-mode-hook (lambda ()
                           (local-set-key [(?º)] (command (insert "$")))))


(key-chord-mode 1)
(key-chord-define-global "º1" 'ace-jump-line-mode)
(key-chord-define-global "<z" 'ace-jump-char-mode)
(key-chord-define-global "zx" 'ace-jump-word-mode)
(setq ace-jump-mode-scope 'frame)

(setq jedi:tooltip-method nil)

(and (fboundp 'cycle-spacing) (global-set-key (kbd "M-SPC") 'cycle-spacing))



(defun dired-at-other-repo ()
  (interactive)
  (with-temp-buffer
    (cd "~/www")
    (ido-dired)))

(global-set-key [(control meta ?')] 'dired-at-other-repo)



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

