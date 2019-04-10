(use-package wrap-region
  :ensure t
  :diminish wrap-region-mode
  :config
  (wrap-region-global-mode t)
  (wrap-region-add-wrapper "`" "`" "q" '(markdown-mode ruby-mode))
  (wrap-region-add-wrapper "```\n" "```" "Q" '(markdown-mode))
  (wrap-region-add-wrapper "`" "`"))


(use-package expand-region
  :ensure t
  :bind (([(super ?1)] . er/expand-region)))


(use-package easy-kill
  :ensure t
  :config
  :bind (([(super delete)] . easy-kill)))


(use-package kmacro
  :defer t
  :bind (([(control f11)] . kmacro-start-macro-or-insert-counter)
         ([(control f12)] . kmacro-end-or-call-macro))
  :config
  (defadvice kmacro-end-or-call-macro (around do-not-use-x (arg) activate)
    "Do noy use system clipboard while executing a macro (speed trick)."
    (let ((select-enable-clipboard nil)
          (select-enable-primary nil))
      ad-do-it)))


;; I use this for non-python too
(use-package python-switch-quotes
  :ensure t
  :bind ([(control c) ?'] . python-switch-quotes))


(use-package shrink-whitespace
  :ensure t
  :bind (([(control meta ? )] . shrink-whitespace)))


(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode))


(use-package subword
  :bind (([(meta left)]  . subword-backward)
         ([(meta right)] . subword-forward))
  :init
  (add-hook 'prog-mode-hook #'subword-mode))


(use-package multiple-cursors
  :ensure t
  :bind ([(control shift mouse-1)] . mc/add-cursor-on-click))


(use-package move-text
  :ensure t
  :bind (([(super up)]   . move-text-up)
         ([(super down)] . move-text-down)))


(use-package syntactic-close
  :ensure t
  :bind (([(super ?ç)] . syntactic-close)
         ("C-]" . syntactic-close)))    ; vector notation screws up paren matching


(use-package goto-chg
  :ensure t
  :bind (([(super ?-)] . goto-last-change)
         ([(super ?_)] . goto-last-change-reverse)))


(use-package align
  :defer t
  :bind (([(super ?a)] . align)
         ([(super ?A)] . align-regexp)))


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
