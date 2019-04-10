(use-package flycheck
  :ensure t
  :bind ([(control x)(?!)] . flycheck-mode)
  :init
  (setq-default flycheck-disabled-checkers '(emacs-lisp emacs-lisp-checkdoc))
  (setq flycheck-idle-change-delay 3
        flycheck-check-syntax-automatically '(save idle-change mode-enabled)
        flycheck-shellcheck-excluded-warnings '("SC2086"))
  :config
  ;; xenial shellcheck does not support that option
  (setq flycheck-shellcheck-follow-sources nil)
  (add-hook 'after-init-hook #'global-flycheck-mode))


(use-package ws-butler
  :ensure t
  :diminish ws-butler-mode
  :init
  (add-hook 'prog-mode-hook #'ws-butler-mode)
  (add-hook 'text-mode-hook #'ws-butler-mode))


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


(use-package puppet-mode
  :ensure t
  :mode ("\\.pp\\'" . puppet-mode))


(use-package go-mode
  :ensure t
  :mode ("\\.go\\'" . go-mode))


(use-package prog-mode
  :defer t
  :config
  (add-hook 'prog-mode-hook (lambda ()
                              (hs-minor-mode 1)
                              (local-set-key [(meta f3)] 'hs-show-block)
                              (local-set-key [(f3)]      'hs-hide-block))))


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
  (defun php-syntax-propertize-function (start end) nil)
  (define-key php-mode-map [(?`)]  (command (insert "$")))
  (define-key php-mode-map [(control ?.)]  nil))


(use-package json-mode
  :mode ("\\.js\\.template\\'" . json-mode))


(use-package markdown-mode
  :ensure t
  :defer t
  :custom (markdown-gfm-additional-languages '("bash")))


(use-package copy-as-format
  :ensure t
  :commands copy-as-format
  :custom (copy-as-format-default "gitlab"))


(use-package hcl-mode
  :ensure t)


(use-package sh-script
  :defer t
  :config
  ;; This allows linting correctly files with no shebang (libraries), since I
  ;; always use bash
  (add-hook 'sh-mode-hook (lambda () (sh-set-shell "bash"))))


(defun juanleon/open-test-file (lang)
  "Quick test in language of choice"
  (interactive (let ((ivy-sort-functions-alist nil))
                 (list (completing-read
                        "Language: " '("py" "sh" "php" "ruby" "go" "perl")))))
  (let ((filename
          (replace-regexp-in-string
           "\n$" "" (shell-command-to-string (concat "test-file " lang)))))
    (find-file filename)))
