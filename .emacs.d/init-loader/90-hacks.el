(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))


(use-package php-mode
  :ensure t
  :defer t
  :config
  (define-key php-mode-map [(?º)]  (command (insert "$"))))


(use-package comint
  :defer t
  :config
  (setq comint-input-ignoredups  t
        comint-use-prompt-regexp nil)  ; Weird bugs otherwise
  (define-key comint-mode-map [(super up)]  'helm-comint-input-ring)
  (defadvice comint-previous-input (around move-free (arg) activate)
    "No more 'Not at command line'"
    (if (comint-after-pmark-p)
        (progn
          ad-do-it)
      (backward-paragraph arg)))
  (add-hook 'comint-mode-hook (lambda () (ws-trim-mode 0))))


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


(and (fboundp 'cycle-spacing) (global-set-key (kbd "M-SPC") 'cycle-spacing))




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
