;; © Juan-Leon Lahoz 199x - 2014

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; This year's calendar calendar

(setq calendar-holidays (append
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
                           (holiday-fixed 11 9  "Almudena"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Dired stuff

(eval-after-load "dired"
  '(progn
     (defun leon/dired-hide-hidden ()
       (interactive)
       (let ((dired-actual-switches "--group-directories-first -l"))
         (revert-buffer)))
     (setq dired-copy-preserve-time nil
           dired-recursive-copies   'always)
     (autoload 'dired-efap "dired-efap")
     (autoload 'dired-efap-click "dired-efap")
     (setq dired-listing-switches "--group-directories-first -al")
     (require 'dired-x)))

(add-hook 'dired-mode-hook (lambda () (dired-omit-mode t)))

(add-hook 'dired-after-readin-hook
          (lambda ()
            (set (make-local-variable 'frame-title-format)
                 (abbreviate-file-name (dired-current-directory)))))

(autoload 'dired-jump "dired")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Minimize keystrokes for writing

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
        try-expand-list))

(if (require 'auto-complete-config nil t)
    (ac-config-default))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Text stuff

(add-hook 'text-mode-hook
          (lambda ()
            (auto-fill-mode 1)
            ;; Hook is run by "child" modes
            (if (eq major-mode 'text-mode)
                (flyspell-mode 1))
            (setq tab-width 4)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Server

(add-hook 'server-done-hook 'delete-frame)

(run-with-idle-timer 5 nil (lambda ()
                             (require 'server)
                             (unless (server-running-p)
                               (server-start)
                               (add-hook 'server-visit-hook
                                         (lambda ()
                                           (if (eq major-mode 'fundamental-mode)
                                               (flyspell-mode 1)))))))

(run-with-idle-timer 15 nil (lambda ()
                              (when (require 'edit-server nil t)
                                (edit-server-start)
                                (define-key edit-server-edit-mode-map
                                  [(meta return)]
                                  (command (insert "<br>")
                                           (newline))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Spelling

(defvar juanleon/main-dictionary      "english")
(defvar juanleon/secondary-dictionary "castellano8")

(setq ispell-dictionary     juanleon/main-dictionary
      ispell-silently-savep t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Searchs

(add-hook 'isearch-mode-end-hook
          (lambda () (if interprogram-cut-function
                         (funcall interprogram-cut-function isearch-string))))

(add-hook 'occur-mode-hook 'turn-on-occur-x-mode)

(eval-after-load "grep"
  '(progn
     (setq grep-find-ignored-directories '(".svn" ".git" ".hg" ".bzr" "target"))
     (add-to-list 'grep-find-ignored-files "TAGS")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Shell stuff

(eval-after-load "shell"
  '(progn
     (add-hook 'shell-mode-hook
               (lambda ()
                 (setq comint-input-ring-file-name (concat user-emacs-directory "history/shell"))
                 (add-hook 'kill-buffer-hook 'comint-write-input-ring nil t)))
     (defun shell-rename()
       (interactive)
       (if (eq major-mode 'shell-mode)
           (rename-buffer "shell" t)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Tramp

(require 'tramp)
(add-to-list 'tramp-default-proxies-alist
             '(nil "\\`root\\'" "/ssh:%h:"))
(add-to-list 'tramp-default-proxies-alist
             '((regexp-quote (system-name)) nil nil))
(add-to-list 'tramp-default-proxies-alist
             '("localhost" nil nil))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; org-mode

(eval-after-load "org"
  '(progn
     (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
     (setq org-agenda-files '("~/Dropbox/org/"))
     (setq org-completion-use-ido t
           org-log-done t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; SQL stuff

(eval-after-load "sql"
  '(progn
     (setq sql-connection-alist
           '(("events"
              (sql-product  'mysql)
              (sql-database "events")
              (sql-server   "squid1")
              (sql-user     "events")
              (sql-password "events"))
             ("users"
              (sql-product  'mysql)
              (sql-database "users")
              (sql-server   "localhost")
              (sql-user     "users")
              (sql-password "users")))
           sql-input-ring-file-name (concat user-emacs-directory "history/sql"))
     (add-hook 'sql-interactive-mode-hook 'comint-write-input-ring nil t)
     (add-to-list 'same-window-buffer-names "*SQL*")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Misc stuff

(add-hook 'latex-mode-hook (lambda () (setq fill-column 100)))
(add-hook 'elisp-mode-hook (lambda () (setq fill-column 75)))

(setq sr-speedbar-right-side nil)

(run-with-idle-timer 10 nil (lambda ()
                              (require 'midnight)
                              (setq clean-buffer-list-delay-general 3)
                              (midnight-delay-set 'midnight-delay "1:10pm")))

(eval-after-load "smex"
  '(progn
     (smex-auto-update 60)))
