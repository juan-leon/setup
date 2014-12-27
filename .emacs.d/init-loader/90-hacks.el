
(fset 'yes-or-no-p 'y-or-n-p)

(defadvice x-set-selection (after replicate-selection (type data) activate)
  "Different applications use different data sources"
  (if (equal type 'CLIPBOARD)
      (x-set-selection 'PRIMARY data)))

(defadvice windmove-do-window-select (around silent-windmove activate)
  "Do not beep when no suitable window is found."
  (condition-case () ad-do-it (error nil)))

(eval-after-load "comint"
  '(defadvice comint-previous-input (around move-free (arg) activate)
     "No more 'Not at command line'"
     (if (comint-after-pmark-p)
         ad-do-it
       (backward-paragraph arg))))

;;; Uncluttering modeline:

(mapc (lambda (x)
        (eval-after-load (car x)
          `(diminish (quote ,(cdr x)))))
      '(("autorevert"  . auto-revert-mode)
        ("ws-trim"     . ws-trim-mode)
        ("back-button" . back-button-mode)
        ("button-lock" . button-lock-mode)
        ("hideshow"    . hs-minor-mode)))

(setq projectile-mode-line-lighter " Prj")

;; (defadvice projectile-update-mode-line (around diminish activate)
;;   "No modeline real state waste when not in a project"
;;   (let ((projectile-require-project-root t))
;;     (condition-case nil
;;         (progn
;;           (projectile-project-root)
;;           ad-do-it)
;;       (error nil))))
;;
;; (add-hook 'dired-mode-hook 'projectile-update-mode-line)

(setq ido-read-file-name-non-ido '(dired-create-directory))

(require 'buffer-move)
(global-set-key (kbd "<C-S-s-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-s-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-s-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-s-right>")  'buf-move-right)



(defun point-in-string-p (pt)
  "Returns t if PT is in a string"
  (eq 'string (syntax-ppss-context (syntax-ppss pt))))

(defun beginning-of-string ()
  "Moves to the beginning of a syntactic string"
  (interactive)
  (unless (point-in-string-p (point))
    (error "You must be in a string for this command to work"))
  (while (point-in-string-p (point))
    (forward-char -1))
  (point))

(defun swap-quotes ()
  "Swaps the quote symbols in a string"
  (interactive)
  (save-excursion
    (let ((bos (save-excursion
                 (beginning-of-string)))
          (eos (save-excursion
                 (beginning-of-string)
                 (forward-sexp)
                 (point)))
          (replacement-char ?\'))
      (goto-char bos)
      ;; if the following character is a single quote then the
      ;; `replacement-char' should be a double quote.
      (when (eq (following-char) ?\')
          (setq replacement-char ?\"))
      (delete-char 1)
      (insert replacement-char)
      (goto-char eos)
      (delete-char -1)
      (insert replacement-char))))

(global-set-key [(super ?\")] 'swap-quotes)

(setq pylint-options "--rcfile ~/.pylint *")


(defun tasks ()
  "Toggle vertical/horizontal window split."
  (interactive)
  (delete-other-windows)
  (split-window-right)
  (other-window 1)
  (find-file "~/org/good-news.org")
  (split-window-vertically)
  (find-file "~/org/tomorrow.org")
  (split-window-vertically)
  (find-file "~/org/today.org")
  (other-window 2)
  (split-window-vertically)
  (find-file "~/org/pending.org"))

(global-set-key [(super ?º)] 'tasks)
(setq projectile-globally-ignored-files nil)
(global-set-key [(super ?k)] 'projectile-ack)

(add-hook 'php-mode-hook (lambda ()
                           (local-set-key [(?º)] (command (insert "$")))))



(setq popwin:special-display-config
  '(;; Emacs
    ("*git-repositories*" :width 60)))

(require 'popwin)
(require 'button)
(popwin-mode 1)
(setq git-repositories
      (list
       "~/www/debhelpers"
       "~/www/githooktools"
       "~/www/iats/code"
       "~/www/iatsadmin"
       "~/www/iatsgit"
       "~/www/iatsgithooks"
       "~/www/iatsqa"
       "~/www/iatsreqs"
       "~/www/iatstesttools"
       "~/www/iatstools"
       "~/www/mergequeue"
       "~/www/sibyl"
       "~/www/squealer"
       "~/www/vagrant"
       )
      )

(defun select-git-repository-from-list()
  (interactive)
  (with-output-to-temp-buffer "*git-repositories*"
    (with-current-buffer "*git-repositories*"
      (dolist (repo git-repositories)
        (insert-text-button repo 'action `(lambda (x) (delete-window) (magit-status ,repo)))
        (newline)))))
(global-set-key (kbd "C-c \\") 'select-git-repository-from-list)

