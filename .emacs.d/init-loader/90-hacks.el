
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
        ("fixmee"      . fixmee-mode)
        ("ws-trim"     . ws-trim-mode)
        ("back-button" . back-button-mode)
        ("button-lock" . button-lock-mode)
        ("hideshow"    . hs-minor-mode)))

(setq projectile-mode-line-lighter " Prj")

(defadvice projectile-update-mode-line (around diminish activate)
  "No modeline real state waste when not in a project"
  (let ((projectile-require-project-root t))
    (condition-case nil
        (progn
          (projectile-project-root)
          ad-do-it)
      (error nil))))

(add-hook 'dired-mode-hook 'projectile-update-mode-line)

(setq ido-read-file-name-non-ido '(dired-create-directory))

(require 'buffer-move)
(global-set-key (kbd "<C-S-s-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-s-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-s-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-s-right>")  'buf-move-right)
