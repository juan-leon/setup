;; Deactivated stuff.  Mostly things that need some polishing to be worth it
;; using it.


;; load-theme-buffer-local is not polished enough to be worth using it

(add-hook 'inferior-python-mode-hook
          (lambda nil
            (load-theme-buffer-local 'tango-dark (current-buffer))))
(add-hook 'shell-mode-hook
          (lambda nil
            (load-theme-buffer-local leon-dark-theme (current-buffer))))
(add-hook 'sql-interactive-mode
          (lambda nil
            (load-theme-buffer-local 'tango-dark (current-buffer))))



;; This is nice, and I leave here as example, but always end using
;; 'dired-at-other-repo

(setq popwin:special-display-config
  '(("*git-repositories*" :width 60)))

(require 'popwin)
(require 'button)
(popwin-mode 1)
(setq git-repositories
      (list
       "~/www/debhelpers"
       "~/www/githooktools"
       "~/www/iats/code"
       "~/www/iatsadmin"
       "~/www/iatsgithooks"
       "~/www/iatsreqs"
       "~/www/iatstesttools"
       "~/www/iatstools"
       "~/www/mergequeue"
       "~/www/sibyl"
       "~/www/squealer"
       "~/www/vagrant"
       "~/repos/git"
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


;; Useful, but I am using projectile for most of the stuff I need tags for.

(defun recreate-tags()
  (interactive)
  (projectile-with-default-dir (projectile-project-root)
    (ctags-create-or-update-tags-table)))

(global-set-key [(super T)] 'recreate-tags)
