(use-package flycheck
  :ensure t
  :bind (([(control x)(?!)] . flycheck-mode)
         ([(f2)] . flycheck-list-errors))
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp emacs-lisp-checkdoc))
  (setq flycheck-idle-change-delay 3
        flycheck-check-syntax-automatically '(save idle-change mode-enabled)
        ;; json
        flycheck-json-python-json-executable "python3.7"
        ;; python
        flycheck-python-flake8-executable "/home/juanleon/.envs/lint/bin/flake8"
        flycheck-python-pycompile-executable "/home/juanleon/.envs/lint/bin/python"
        ;; bash
        flycheck-shellcheck-excluded-warnings '("SC2086")
        flycheck-shellcheck-follow-sources nil)) ; xenial shellcheck does not support that


(use-package prog-mode
  :defer t
  :bind (:map prog-mode-map ([(super ?\;)] . juanleon/comment-or-uncomment-region))
  :config
  (defun juanleon/comment-or-uncomment-region (beg end &optional arg)
    "Comment or uncoment whole lines in region"
    (interactive "*r\nP")
    (comment-or-uncomment-region (save-excursion
                                   (goto-char beg)
                                   (beginning-of-line)
                                   (point))
                                 (save-excursion
                                   (goto-char end)
                                   (end-of-line)
                                   (point))
                                 arg)))


(use-package ws-butler
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'ws-butler-mode)
  (add-hook 'text-mode-hook #'ws-butler-mode)
  ;; Why are those below not inheriting from prog-mode?
  (add-hook 'toml-mode-hook #'ws-butler-mode)
  (add-hook 'protobuf-mode-hook #'ws-butler-mode)
  :config
  (setq ws-butler-global-exempt-modes nil))


(use-package whitespace
  :defer t
  :config
  (setq whitespace-line-column 100))


(use-package dumb-jump
  :ensure t
  :bind ([(control meta ?.)] . dumb-jump-go)
  :config
  (dumb-jump-mode 1))


(use-package fixme-mode
  :ensure t
  :defer t
  :init
  (setq fixme-mode-warning-words '("FIXME" "TODO" "fixme" "HACK"))
  (add-hook 'prog-mode-hook #'fixme-mode))


(use-package hideshow
  :after prog-mode
  :defer t
  :bind (:map prog-mode-map
              ([(meta f3)] . hs-show-block)
              ([(f3)]      . hs-hide-block))
  :config
  (add-hook 'prog-mode-hook #'hs-minor-mode))


(use-package puppet-mode
  :ensure t
  :mode ("\\.pp\\'" . puppet-mode))


(use-package go-mode
  :ensure t
  :mode ("\\.go\\'" . go-mode))


(use-package toml-mode
  :ensure t
  :mode ("\\.toml\\'" . toml-mode))


(use-package elisp-mode
  :defer t
  :commands emacs-lisp-mode
  :bind (:map emacs-lisp-mode-map ([(f8)] . juanleon/byte-compile-this-file))
  :config
  (defun juanleon/byte-compile-this-file()
    (interactive)
    (byte-compile-file (buffer-file-name))))


(use-package cc-mode
  :defer t
  :config
  (c-set-offset 'case-label '+)
  (c-set-offset 'substatement-open 0)
  (defun juanleon/c-mode-setup ()
    (setq indicate-empty-lines t)
    (c-toggle-electric-state t)
    (c-toggle-hungry-state t)
    (setq c-basic-offset 4)
    (setq ff-search-directories '("." "include" "../include")))
  (add-hook 'c-mode-common-hook 'juanleon/c-mode-setup)
  (add-hook 'java-mode-hook (lambda ()
                              (setq c-basic-offset 4
                                    indent-tabs-mode t))))


(use-package php-mode
  :ensure t
  :defer t
  :config
  ;; Monkey patch function to avoid buffer modified file flag bug
  (defun php-syntax-propertize-function (start end) nil))


(use-package json-mode
  :mode ("\\.js\\.template\\'" . json-mode))


(use-package copy-as-format
  :ensure t
  :commands copy-as-format
  :config (setq copy-as-format-default "gitlab"))


(use-package hcl-mode
  :mode ("\\.tf\\'" . hcl-mode)
  :ensure t)


(use-package protobuf-mode
  :mode ("\\.proto\\'" . protobuf-mode)
  :ensure t)


(use-package sh-script
  :defer t
  :config
  ;; This allows linting correctly files with no shebang (libraries), since I
  ;; never use other shells
  (add-hook 'sh-mode-hook (lambda () (sh-set-shell "bash"))))


(defun juanleon/open-test-file (lang)
  "Quick test in language of choice"
  (interactive (let ((ivy-sort-functions-alist nil))
                 (list (completing-read
                        "Language: " '("py" "sh" "php" "mail" "ruby" "go" "perl" "js" "ts")))))
  (let ((filename
          (replace-regexp-in-string
           "\n$" "" (shell-command-to-string (concat "test-file " lang)))))
    (find-file filename)))


(use-package markdown-mode
  :ensure t
  :defer t
  :config
  (setq markdown-gfm-additional-languages '("bash"))
  ;; I wonder if I will regret this...
  (modify-syntax-entry ?' "\"" text-mode-syntax-table))


(use-package lsp-mode
  :ensure t
  :defer t
  :init
  (setq lsp-keymap-prefix "s-l")
  :hook ((go-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui
  :ensure t
  :defer t
  :commands lsp-ui-mode)

(use-package lsp-ivy
  :ensure t
  :defer t
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
  :ensure t
  :defer t
  :commands lsp-treemacs-errors-list)

(use-package rustic
  :ensure t
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-d l" . flycheck-list-errors)
              ("C-c C-d a" . lsp-execute-code-action)
              ("C-c C-d r" . lsp-rename)
              ("C-c C-d q" . lsp-workspace-restart)
              ("C-c C-d Q" . lsp-workspace-shutdown)
              ("C-c C-d s" . lsp-rust-analyzer-status))
  :config
  (setq rustic-format-trigger 'on-save))
