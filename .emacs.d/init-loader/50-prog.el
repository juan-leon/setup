
(setq fixme-mode-warning-words '("FIXME" "TODO" "fixme" "HACK" "NOCOMMIT"))

(add-hook 'prog-mode-hook (lambda ()
                            (subword-mode  1)
                            (fixme-mode    1)
                            (hs-minor-mode 1)))


(defun delete-trailing-blank-lines ()
  "Deletes all blank lines at the end of the file."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))



(eval-after-load "cc-mode"
  '(progn
     (defun leon/c-mode-setup ()
       (setq indicate-empty-lines t)
       (c-toggle-electric-state t)
       (c-toggle-hungry-state t)
       (setq c-basic-offset 4)
       (setq ff-search-directories '("." "include" "../include")))
     (add-hook 'c-mode-common-hook 'leon/c-mode-setup)
     (add-hook 'java-mode-hook (lambda ()
                                 (setq c-basic-offset 4
                                       tab-width 4
                                       indent-tabs-mode t)))
    (when (require 'xcscope nil t)
      (cscope-setup))
     (when (require 'ctags nil t)
       (setq tags-revert-without-query t)
       (setq ctags-command
             "find . -name  '*.[ch]' -o -name '*.java' -o -name '*.el' -o -name '*.php' -o -name '*.js' -o -name '*.py' | xargs etags"))
     (when (require 'etags-table nil t)
       (setq etags-table-search-up-depth 20))
     (c-set-offset 'case-label '+)
     (c-set-offset 'substatement-open 0)))

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(add-to-list 'auto-mode-alist '("\\.pp\\'" . puppet-mode))
(add-to-list 'auto-mode-alist '("\\.js.template\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(setq projectile-switch-project-action 'projectile-dired
      projectile-mode-line '(:eval (format " P[%s]" (projectile-project-name)))
      projectile-tags-command "ctags-exuberant -Re -f \"%s\" %s")
(projectile-global-mode)

;; fixme flymake fails more often than not (add-hook 'php-mode-hook 'flymake-mode)
(add-hook 'php-mode-hook '(lambda () (setq require-final-newline t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Compilation

(setq compilation-scroll-output t
      next-error-highlight-no-select 2.0
      next-error-highlight 'fringe-arrow)

(add-hook 'compilation-finish-functions 'notify-compilation-end)

