(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))


(use-package php-mode
  :ensure t
  :defer t
  :config
  ;; Monkey patch function to avoid buffer modified file flag bug
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



(defun open-test-file ()
  (interactive)
  (let* ((lang (completing-read "Language: " '("py" "php" "sh" "ruby" "go" "perl")))
         (filename
          (replace-regexp-in-string
           "\n$" "" (shell-command-to-string (concat "test-file " lang)))))
    (find-file filename)))



(use-package discover-my-major
  :ensure t
  :bind ("C-h C-m" . discover-my-major))

(use-package server
  :if window-system
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
  :bind (([(super ?j)] . avy-goto-word-1)
         ([(super ?k)] . avy-goto-word-timer)))


(use-package hydra
  :ensure t
  :commands defhydra hydra-diff/body hydra-cmus/body
  :bind (([(control ?=)]  . hydra-diff/body)
         ([(control f7)]  . hydra-next-error/body)
         ([(control f10)] . hydra-toggle/body)
         ([(control f9)]  . hydra-cmus/body))
  :config
  (defhydra hydra-zoom (global-map "<f2>")
    ("+" text-scale-increase "in")
    ("-" text-scale-decrease "out"))

  (defhydra hydra-diff ()
    "Show diffs"
    ("b" ediff-buffers "buffers" :color blue)
    ("f" ediff-files "files" :color blue)
    ("d" diff "diff" :color blue)
    ("w" compare-windows "windows" :color blue)
    ("v" vc-diff "versioned" :color blue))

  (defhydra hydra-next-error ()
    "Error Selection"
    ("j" next-error "next" :bind nil)
    ("n" next-error "next" :bind nil)
    ("k" previous-error "previous" :bind nil)
    ("p" previous-error "previous" :bind nil)
    ("l" juanleon/goto-compilation-buffer "list-errors" :exit t)
    ("q" nil "quit" :exit t))

  (defhydra eos/hydra-toggle nil
    "Toggle stuff"
    ("d" toggle-debug-on-error "debug-on-error" :exit t)
    ("D" toggle-debug-on-quit "debug-on-quit" :exit t)
    ("g" golden-ratio-mode "golden-ratio" :exit t)
    ("F" auto-fill-mode "auto-fill" :exit t)
    ("l" toggle-truncate-lines "truncate-lines" :exit t)
    ("r" read-only-mode "read-only" :exit t)
    ("h" hl-line-mode "hl-line" :exit t)
    ("q" nil :exit t))

  (defhydra hydra-cmus ()
    "CMUS control"
    ("+" cmus-increase-vol "+vol")
    ("-" cmus-decrease-vol "-vol")
    ("p" cmus-pause "pause" :exit t)
    ("n" cmus-next "next" :exit t)
    ("r" cmus-replay "replay" :exit t)
    ("q" nil "do nothing" :exit t)))

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

(use-package toml-mode
  :ensure t
  :defer t
  :mode ("\\.toml\\'" . toml-mode))


(defun fill-or-unfill ()
  "Like `fill-paragraph', but unfill if used twice."
  (interactive)
  (let ((fill-column
         (if (eq last-command 'fill-or-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (call-interactively #'fill-paragraph)))

(global-set-key [remap fill-paragraph] #'fill-or-unfill)

;; This allows linting correctly files with no shebang (libraries), since I
;; always use bash
(add-hook 'sh-mode-hook (lambda () (sh-set-shell "bash")))
