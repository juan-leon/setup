(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))


(use-package comint
  :defer t
  :config
  (setq comint-input-ignoredups  t
        comint-use-prompt-regexp nil)  ; Weird bugs otherwise
  (defadvice comint-previous-input (around move-free (arg) activate)
    "No more 'Not at command line'"
    (if (comint-after-pmark-p)
        (progn
          ad-do-it)
      (backward-paragraph arg))))



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
         ([(control f3)]  . hydra-zoom/body))

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
    ("q" nil :exit t)))




(use-package toml-mode
  :ensure t
  :mode ("\\.toml\\'" . toml-mode))

