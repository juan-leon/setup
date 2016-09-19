(use-package magit
  :bind (([(super ?0)] . magit-status)
         ([(super ?q)] . magit-status))
  :ensure t
  :init
  (setq magit-completing-read-function 'helm--completing-read-default
        git-commit-summary-max-length 70)
  :config
  (define-key magit-status-mode-map [backspace] 'juanleon/magit-in-supermodule)
  (add-hook 'git-commit-mode-hook #'turn-on-flyspell)
  (autoload 'magit-rockstar "magit-rockstar" nil t)
  (autoload 'magit-reshelve "magit-rockstar" nil t)
  (magit-define-popup-action 'magit-rebase-popup ?R "Rockstar" 'magit-rockstar)
  (magit-define-popup-action 'magit-commit-popup ?n "Reshelve" 'magit-reshelve)
  (magit-define-popup-switch 'magit-log-popup ?F "First parent" "--first-parent")

  ;; Monkey patch because I like this behaviour
  (defun magit-copy-buffer-revision (beg end &optional region)
    (interactive (list (mark) (point)
                       (prefix-numeric-value current-prefix-arg)))
    (kill-ring-save beg end region))

  (defun juanleon/magit-in-supermodule()
  (interactive)
  (with-temp-buffer
    (cd "..")
    (if (magit-toplevel)
        (magit-status-internal default-directory)))))

(use-package git-messenger
  :bind ([(control ?x) ?v ?p] . git-messenger:popup-message)
  :ensure t
  :init
  (setq git-messenger:show-detail t)
  :config
  (define-key git-messenger-map (kbd "m") 'git-messenger:copy-message))

(use-package git-timemachine
  :ensure t)

