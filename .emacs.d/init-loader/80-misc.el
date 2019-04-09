;; © Juan-Leon Lahoz 199x - 2014


(use-package calendar
  :bind ([(control f4)] . calendar)
  :init
  (setq calendar-week-start-day     1
        calendar-mark-holidays-flag t
        calendar-holidays (append
                           ;; Fixed
                           '((holiday-fixed 1 1 "New Year's Day")
                             (holiday-fixed 1 6 "Reyes")
                             (holiday-easter-etc -2 "Jueves Santo")
                             (holiday-easter-etc -3 "Viernes Santo")
                             (holiday-fixed 5 1   "Dia del Trabajador")
                             (holiday-fixed 5 2   "Comunidad del Madrid")
                             (holiday-fixed 10 12 "National Day")
                             (holiday-fixed 12 6  "Constitution")
                             (holiday-fixed 12 25 "Christmas"))
                           ;; This year
                           '((holiday-fixed 3 20  "S. Jose")
                             (holiday-fixed 5 15  "Whatever")
                             (holiday-fixed 8 15  "Asuncion")
                             (holiday-fixed 11 1  "All Saints")
                             (holiday-fixed 11 9  "Almudena")
                             (holiday-fixed 12 8  "Concepcion")))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Minimize keystrokes for writing

(use-package hippie-exp
  :bind (([(super tab)] . hippie-expand)
         ([(meta ?`)] . hippie-expand)  ; Sometimes super tab is stolen by WM
         ([(meta ?º)] . hippie-expand)  ; deal with Spanish keyboards
         ([(meta VoidSymbol)] . hippie-expand)
         ([(control VoidSymbol)] . hippie-expand))
  :config
  (setq hippie-expand-try-functions-list
        '(try-expand-dabbrev
          try-complete-file-name-partially
          try-complete-file-name
          try-expand-dabbrev-all-buffers
          try-expand-dabbrev-from-kill
          try-expand-all-abbrevs
          try-complete-lisp-symbol-partially
          try-complete-lisp-symbol
          try-expand-line
          try-expand-list)))


(use-package auto-complete
  :ensure t
  :config (ac-config-default))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Text stuff



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Spelling

(use-package ispell
  :defer t
  :preface
  (defvar juanleon/main-dictionary      "english")
  (defvar juanleon/secondary-dictionary "castellano8")
  :config
  (setq ispell-dictionary     juanleon/main-dictionary
        ispell-silently-savep t)
  (global-set-key [(super ?9)]
                  (lambda ()
                    (interactive)
                    (if (not (equal ispell-local-dictionary juanleon/secondary-dictionary))
                        (ispell-change-dictionary juanleon/secondary-dictionary)
                      (ispell-change-dictionary juanleon/main-dictionary)))))




(use-package occur-x
  :ensure t
  :config (add-hook 'occur-mode-hook 'turn-on-occur-x-mode))

(use-package grep
  :defer t
  :init
  (add-hook 'grep-setup-hook 'wgrep-setup))

(use-package wgrep
  :ensure t
  :commands wgrep-setup
  :init
  (setq wgrep-auto-save-buffer t
        wgrep-enable-key "e"))

(use-package shell
  :defer t
  :config
  (add-hook 'shell-mode-hook
            (lambda ()
              (setq comint-input-ring-file-name (concat user-emacs-directory "history/shell"))
              (add-hook 'kill-buffer-hook 'comint-write-input-ring nil t)))
  (defun juanleon/shell-rename()
    (interactive)
    (if (eq major-mode 'shell-mode)
        (rename-buffer "shell" t)))
  (define-key shell-mode-map [(meta kp-up)] 'juanleon/shell-rename)
  (define-key shell-mode-map [(meta kp-8)]  'juanleon/shell-rename))

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


(use-package midnight
  :defer 30
  :init
  (setq clean-buffer-list-delay-general 3)
  (midnight-delay-set 'midnight-delay "7:10pm"))

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (yas-global-mode)
  ;; Tab is for completion/indent
  (define-key yas-minor-mode-map [(tab)]       nil)
  (define-key yas-minor-mode-map (kbd "TAB")   nil)
  ;; Super ' is for expansion
  (define-key yas-minor-mode-map [(super ?`)]  'yas-expand))

(use-package auto-yasnippet
  :bind (([(control ?o)] . aya-open-line)
         ([(super f11)] . aya-create)
         ([(super f12)] . aya-expand))
  :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode 1))


(use-package calc
  :defer t
  :commands calc
  :bind (:map calc-mode-map
              ([(insert)] . calc-yank)
              ([(shift insert)] . calc-yank)))

(use-package abbrev
  :defer 4
  :config
  (add-hook 'text-mode-hook #'abbrev-mode)
  (add-hook 'markdown-mode-hook #'abbrev-mode)
  (if (file-exists-p abbrev-file-name)
      (quietly-read-abbrev-file)))

(use-package flyspell
  :defer 5
  :custom
  (flyspell-abbrev-p t)
  (save-abbrevs 'silently)
  :config
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  (add-hook 'text-mode-hook 'flyspell-mode))

(use-package flyspell-correct-ivy
  :after flyspell
  :ensure t
  :commands flyspell-correct-ivy
  :bind (:map flyspell-mode-map
        ("C-;" . flyspell-correct-word-generic))
  :custom (flyspell-correct-interface 'flyspell-correct-ivy))

(use-package tramp
  :config
  ;; Speed up things
  (setq remote-file-name-inhibit-cache nil
        tramp-completion-reread-directory-timeout nil
        vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)"
                                     vc-ignore-dir-regexp
                                     tramp-file-name-regexp)))

(use-package define-word
  :ensure t
  :commands define-word define-word-at-point)
