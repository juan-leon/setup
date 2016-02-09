(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(fset 'yes-or-no-p 'y-or-n-p)

(defadvice x-set-selection (after replicate-selection (type data) activate)
  "Different applications use different data sources"
  (if (equal type 'CLIPBOARD)
      (x-set-selection 'PRIMARY data)))

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
        ("anzu"        . anzu-mode)
        ("back-button" . back-button-mode)
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



(and (fboundp 'cycle-spacing) (global-set-key (kbd "M-SPC") 'cycle-spacing))



(setq projectile-make-test-cmd "tools/runUnitTests")

(add-hook 'comint-mode-hook (lambda () (ws-trim-mode 0)))




(defun open-test-file ()
  (interactive)
  (let* ((lang (completing-read "Language: " '("py" "php" "sh" "ruby")))
         (filename
          (replace-regexp-in-string
           "\n$" "" (shell-command-to-string (concat "test-file " lang)))))
    (find-file filename)))



(use-package discover-my-major
  :ensure t
  :bind ("C-h C-m" . discover-my-major))

(use-package server
  :init (setq server-window 'switch-to-buffer-other-frame)
  :defer 5
  :config (unless (server-running-p)
            (server-start)))


(use-package key-chord
  :ensure t
  :config
  (key-chord-mode 1)
  (key-chord-define-global "º1" 'ace-jump-line-mode)
  (key-chord-define-global "<z" 'ace-jump-char-mode)
  (key-chord-define-global "zx" 'ace-jump-word-mode))

(use-package ace-jump-mode
  :ensure t
  :defer t
  :config
  (setq ace-jump-mode-scope 'frame))

(use-package avy
  :ensure t
  :bind ([(super ?j)] . avy-goto-word-1))
