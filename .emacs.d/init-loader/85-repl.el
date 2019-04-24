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


(use-package shell
  :defer t
  :bind (([(control x) (control z)] . shell)
         ([(super z)] . shell)
         :map shell-mode-map
         ([(meta kp-up)] . juanleon/shell-rename)
         ([(meta kp-8)]  . juanleon/shell-rename))
  :config
  (add-hook 'shell-mode-hook
            (lambda ()
              (setq comint-input-ring-file-name (concat user-emacs-directory "history/shell"))
              (add-hook 'kill-buffer-hook 'comint-write-input-ring nil t)))
  (defun juanleon/shell-rename()
    (interactive)
    (if (eq major-mode 'shell-mode)
        (rename-buffer "shell" t))))


(use-package calc
  :defer t
  :commands calc
  :bind (:map calc-mode-map
              ([(insert)] . calc-yank)
              ([(shift insert)] . calc-yank)))


(use-package sql
  :bind ([(meta f4)] . sql-connect)
  :config
  (add-to-list 'sql-product-alist
               '(MariaDB
                 :name "MySQL"
                 :free-software t
                 :font-lock sql-mode-mysql-font-lock-keywords
                 :sqli-program sql-mysql-program
                 :sqli-options sql-mysql-options
                 :sqli-login sql-mysql-login-params
                 :sqli-comint-func sql-comint-mysql
                 :list-all "SHOW TABLES;"
                 :list-table "DESCRIBE %s;"
                 :prompt-regexp "^MariaDB.*> "
                 :prompt-length 6
                 :prompt-cont-regexp "^    -> "
                 :syntax-alist ((?# . "< b"))
                 :input-filter sql-remove-tabs-filter))
  (modify-syntax-entry ?\" "\"" sql-mode-syntax-table)
  (setq sql-connection-alist
        '(("iats"
           (sql-product  'MariaDB)
           (sql-database "iats")
           (sql-server   "sb1")
           (sql-user     "root")
           (sql-password ""))
          ("squealer"
           (sql-product  'MariaDB)
           (sql-database "squealer")
           (sql-server   "sb1")
           (sql-user     "root")
           (sql-password "")))
        sql-input-ring-file-name (concat user-emacs-directory "history/sql"))
  (add-hook 'sql-interactive-mode-hook 'comint-write-input-ring nil t)
  (add-to-list 'same-window-buffer-names "*SQL*"))
