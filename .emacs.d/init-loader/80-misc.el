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
                           '((holiday-fixed 1 7   "Traslado R. Magos")
                             (holiday-fixed 3 18  "S. Jose")
                             (holiday-fixed 8 15  "Asuncion")
                             (holiday-fixed 11 1  "All Saints")
                             (holiday-fixed 11 9  "Almudena")))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Minimize keystrokes for writing

(use-package hippie-exp
  :config
  (setq hippie-expand-try-functions-list
        '(try-expand-dabbrev
          try-complete-file-name-partially
          try-complete-file-name
          try-expand-all-abbrevs
          try-expand-dabbrev-all-buffers
          try-expand-dabbrev-from-kill
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

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)


(add-hook 'text-mode-hook
          (lambda ()
            (auto-fill-mode 1)
            ;; Hook is run by "child" modes
            (if (eq major-mode 'text-mode)
                (flyspell-mode 1))
            (setq tab-width 4)))



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
  (setq grep-find-ignored-directories '(".svn" ".git" ".hg" ".bzr" "target"))
  (add-to-list 'grep-find-ignored-files "TAGS"))

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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; org-mode

(use-package org
  :ensure t
  :bind (([(control c) ?l] . org-store-link)
         ([(control c) ?a] . org-agenda)
         ([(control c) ?c] . org-capture)
         ([(super o)]      . org-iswitchb))
  :config
  (use-package org-bullets :ensure t)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-agenda-files "~/org/agenda")
  (setq org-directory org-agenda-files)
  (setq org-src-fontify-natively t)
  (setq org-completion-use-ido t)
  (setq org-capture-templates
      '(("t" "Quick todo" entry (file+headline "pending.org" "Tasks") "* TODO %? \n")
        ("T" "Todo" entry (file+headline "pending.org" "Tasks") "* TODO %?\n  %U\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "journal.org") "* %<%R: >%?\n%t")
        ("s" "Code Snippet" entry (file "snippets.org") "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC"))))


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
  :ensure t
  :defer 30
  :init
  (setq clean-buffer-list-delay-general 3)
  (midnight-delay-set 'midnight-delay "7:10pm"))

(use-package yasnippet
  :ensure t
  :disabled
  :diminish yas-minor-mode
  :init (setq yas-prompt-functions '(yas-ido-prompt))
  :config
  (yas-global-mode)
  ;; Tab is for completion/indent
  (define-key yas-minor-mode-map [(tab)]       nil)
  (define-key yas-minor-mode-map (kbd "TAB")   nil)
  ;; Super tab (and friend) is for expansion
  (define-key yas-minor-mode-map [(super tab)] 'yas-expand)
  (define-key yas-minor-mode-map [(meta ?º)]   'yas-expand))

;; (use-package paradox
;;   :ensure t
;;   :commands paradox-list-packages
;;   :config
;;   (setq paradox-column-width-package 30)
;;   (setq paradox-display-download-count t))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config (which-key-mode 1))

(use-package general-close
  :ensure t
  :bind ([(super ?ç)] . general-close))
