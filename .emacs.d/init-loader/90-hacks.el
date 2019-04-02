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
  (define-key php-mode-map [(?`)]  (command (insert "$")))
  (define-key php-mode-map [(control ?.)]  nil))


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
      (backward-paragraph arg))))

(defun open-test-file (lang)
  (interactive (let ((ivy-sort-functions-alist nil))
                 (list (completing-read
                        "Language: " '("py" "sh" "php" "ruby" "go" "perl")))))
  (let ((filename
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

(use-package avy
  :ensure t
  :custom
  (avy-keys '(up down left right))
  (avy-lead-faces '(avy-lead-face
                    avy-lead-face-0
                    avy-lead-face
                    avy-lead-face-0
                    avy-lead-face
                    avy-lead-face-0))
  :bind (([(super ?j)] . avy-goto-word-1)
         ([(super ?k)] . avy-goto-char-timer)
         ([(super ?l)] . avy-goto-line)))


(use-package hydra
  :ensure t
  :commands defhydra hydra-diff/body hydra-cmus/body
  :bind (([(control ?=)]  . hydra-diff/body)
         ([(control f7)]  . hydra-next-error/body)
         ([(control f10)] . hydra-toggle/body)
         ([(control f3)]  . hydra-zoom/body)
         ([(control f9)]  . hydra-cmus/body))

  :config
  (defhydra hydra-zoom nil
    "Change text size"
    ("+" text-scale-increase "in")
    ("-" text-scale-decrease "out"))

  (defhydra hydra-diff nil
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

  (defhydra hydra-toggle nil
    "Toggle stuff"
    ("d" toggle-debug-on-error "debug-on-error" :exit t)
    ("D" toggle-debug-on-quit "debug-on-quit" :exit t)
    ("g" golden-ratio-mode "Golden-ratio" :exit t)
    ("F" auto-fill-mode "Auto-fill" :exit t)
    ("l" toggle-truncate-lines "Truncate lines" :exit t)
    ("r" read-only-mode "Read-only" :exit t)
    ("s" flyspell-mode "FlySpell" :exit t)
    ("S" flyspell-prog-mode "FlySpell prog" :exit t)
    ("h" hl-line-mode "Highlight lines" :exit t)
    ("n" display-line-numbers-mode "Line numbers" :exit t)
    ("w" whitespace-mode "whitespace" :exit t)
    ("q" nil :exit t))

  (defhydra hydra-cmus ()
    "CMUS control"
    ("+" cmus-increase-vol "+vol")
    ("-" cmus-decrease-vol "-vol")
    ("p" cmus-pause "pause" :exit t)
    ("n" cmus-next "next" :exit t)
    ("r" cmus-replay "replay" :exit t)
    ("q" nil "do nothing" :exit t)))

(use-package minions
  :ensure t
  :config
  (minions-mode 1)
  (setq minions-mode-line-lighter "@"))

(use-package dumb-jump
  :ensure t
  :bind ([(control meta ?.)] . dumb-jump-go)
  :config
  (dumb-jump-mode 1))

(use-package toml-mode
  :ensure t
  :defer t
  :mode ("\\.toml\\'" . toml-mode))

(use-package copy-as-format
  :ensure t
  :commands copy-as-format
  :custom (copy-as-format-default "gitlab"))

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


(use-package sdcv-mode
  :init
  (autoload 'sdcv-search "sdcv")
  :bind ([(control c) ?d] . sdcv-search))

(use-package deadgrep
  :ensure t
  :commands deadgrep)

;; I need to use the package installed by debian file to match the notmuch version
(use-package notmuch
  :preface
  :commands notmuch-hello
  :init (autoload 'notmuch "notmuch-hello"))
