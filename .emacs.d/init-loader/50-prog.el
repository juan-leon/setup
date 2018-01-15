

(use-package fixme-mode
  :ensure t
  :defer t
  :init (setq fixme-mode-warning-words '("FIXME" "TODO" "fixme" "HACK" "NOCOMMIT")))

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
                              (subword-mode  1)
                              (fixme-mode    1)
                              (hs-minor-mode 1)
                              (local-set-key [(meta f3)] 'hs-show-block)
                              (local-set-key [(f3)]      'hs-hide-block))))

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
                                    tab-width 4
                                    indent-tabs-mode t))))

(use-package ctags
  :ensure t
  :disabled
  :bind ([(super f12)] . ctags-create-or-update-tags-table)
  :config
  (setq etags-table-search-up-depth 20
        tags-revert-without-query t)
  (setq ctags-command
        "find . -name  '*.[ch]' -o -name '*.java' -o -name '*.el' -o -name '*.php' -o -name '*.js' -o -name '*.py' | xargs etags"))


(use-package js
  :mode ("\\.js\\.template\\'" . js-mode))


(use-package compile
  :bind (([(f8)]            . compile)
         ([(f7)]            . juanleon/execute-buffer)
         ([(control f6)]    . recompile)
         ([(super kp-8)]    . previous-error)
         ([(super kp-2)]    . next-error))
  :init
  (setq compilation-scroll-output t
        next-error-highlight 'fringe-arrow)
  (defun juanleon/goto-compilation-buffer ()
    (interactive)
    (let ((buf (get-buffer "*compilation*")))
      (and buf (switch-to-buffer buf))))
  (global-set-key [(control f8)] 'juanleon/goto-compilation-buffer)
  :config
  (add-hook 'compilation-finish-functions 'juanleon/notify-compilation-end))


(use-package hideshow
  :defer t
  :diminish hs-minor-mode)


(use-package multi-compile
  :bind ([(f6)] . multi-compile-run)
  :init
  (setq multi-compile-alist
        '(("\\.*/hacks/\\.*" . (("run" . "%path")))
          (python-mode . (("pyrev" "pyrev" (multi-compile-locate-file-dir ".git"))
                          ("pyreview" "pyreview --cycles" (multi-compile-locate-file-dir ".git")))))))

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
