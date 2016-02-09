

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


(add-hook 'prog-mode-hook (lambda ()
                            (subword-mode  1)
                            (fixme-mode    1)
                            (hs-minor-mode 1)))


(defun juanleon/delete-trailing-blank-lines ()
  "Deletes all blank lines at the end of the file."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))



(eval-after-load "cc-mode"
  '(progn
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
                                       indent-tabs-mode t)))
     (when (require 'ctags nil t)
       (setq tags-revert-without-query t)
       (setq ctags-command
             "find . -name  '*.[ch]' -o -name '*.java' -o -name '*.el' -o -name '*.php' -o -name '*.js' -o -name '*.py' | xargs etags"))
     (when (require 'etags-table nil t)
       (setq etags-table-search-up-depth 20))
     (c-set-offset 'case-label '+)
     (c-set-offset 'substatement-open 0)))

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(add-to-list 'auto-mode-alist '("\\.js.template\\'" . js-mode))


;; fixme flymake fails more often than not (add-hook 'php-mode-hook 'flymake-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Compilation

(use-package compile
  :bind (([(f8)]            . compile)
         ([(control f6)]    . recompile)
         ([(super f7)]      . previous-error)
         ([(super f8)]      . next-error)
         ([(super kp-8)]    . previous-error)
         ([(super kp-2)]    . next-error)
         ([(super meta f7)] . previous-error-no-select)
         ([(super meta f8)] . next-error-no-select))
  :init
  (setq compilation-scroll-output t
        next-error-highlight 'fringe-arrow)
  (global-set-key [(control f8)] (command
                                  (let ((buf (get-buffer "*compilation*")))
                                    (and buf (switch-to-buffer buf)))))
  :config
  (add-hook 'compilation-finish-functions 'juanleon/notify-compilation-end))

(use-package projectile
  :init
  (setq projectile-keymap-prefix         (kbd "C-p")
        projectile-switch-project-action 'projectile-dired
        projectile-mode-line             '(:eval (format " P[%s]" (projectile-project-name)))
        projectile-tags-command          "ctags-exuberant -Re -f \"%s\" %s")
  :config
  (projectile-global-mode))
