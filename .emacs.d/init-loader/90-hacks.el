(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))


(use-package php-mode
  :ensure t
  :defer t
  :config
  ;; Monkey patch function to avoid buffer modified file flag mistake
  (defun php-syntax-propertize-function (start end) nil)
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



(and (fboundp 'cycle-spacing) (global-set-key (kbd "M-SPC") 'cycle-spacing))




(defun open-test-file ()
  (interactive)
  (let* ((lang (completing-read "Language: " '("py" "php" "sh" "ruby" "go")))
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

(use-package hydra
  :ensure t
  :commands defhydra hydra-diff/body
  :bind ([(control ?=)] . hydra-diff/body)
  :config
  (defhydra hydra-zoom (global-map "<f2>")
    ("+" text-scale-increase "in")
    ("-" text-scale-decrease "out"))

  (defhydra hydra-diff (:color pink :hint nil)
    ("b" ediff-buffers "buffers" :color blue)
    ("f" ediff-files "files" :color blue)
    ("d" diff "diff" :color blue)
    ("w" compare-windows "windows" :color blue)
    ("v" vc-diff "versioned" :color blue)))

(use-package powerline
  :ensure t
  :config (powerline-center-theme))

(use-package dumb-jump
  :ensure t
  :bind ([(control meta ?.)] . dumb-jump-go)
  :config
  (dumb-jump-mode 1)
  (nconc dumb-jump-find-rules
         '((:type "type" :language "php"
                  :regex "class\\s*JJJ\\s*"
                  :tests ("class test")))))
