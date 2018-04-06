(use-package magit
  :bind (([(super ?0)] . magit-status)
         ([(super ?q)] . magit-status))
  :ensure t
  :init
  (setq magit-completing-read-function 'helm--completing-read-default
        git-commit-summary-max-length 70)
  :config
  (define-key magit-status-mode-map [backspace] 'juanleon/magit-in-supermodule)
  (define-key magit-mode-map [(control backspace)] 'juanleon/visit-gitlab)
  (add-hook 'git-commit-mode-hook #'turn-on-flyspell)
  (magit-define-popup-action 'magit-rebase-popup ?R "Rockstar" 'magit-rockstar)
  (magit-define-popup-action 'magit-commit-popup ?n "Reshelve" 'magit-reshelve)

  (magit-define-popup-action 'magit-branch-popup ?I "iatsBranch" 'juanleon/iats-branch)
  (magit-define-popup-action 'magit-branch-popup ?S "iatsSwitch" 'juanleon/iats-switch)
  (magit-define-popup-action 'magit-pull-popup ?I "iatsPull" 'juanleon/iats-pull)
  (magit-define-popup-action 'magit-push-popup ?I "iatsPush" 'juanleon/iats-push)
  (magit-define-popup-action 'magit-merge-popup ?I "iatsMerge" 'juanleon/iats-merge)
  (magit-define-popup-action 'magit-tag-popup ?I "iatsTag" 'juanleon/iats-tag)

  (magit-define-popup-switch 'magit-log-popup ?F "First parent" "--first-parent")
  (autoload 'org-read-date "org")
  (defun magit-org-read-date (prompt &optional _default)
    (org-read-date 'with-time nil nil prompt))
  (magit-define-popup-option 'magit-log-popup ?s "Since date" "--since=" #'magit-org-read-date)
  (magit-define-popup-option 'magit-log-popup ?u "Until date" "--until=" #'magit-org-read-date)

  ;; Monkey patch because I like this behaviour
  (defun magit-copy-buffer-revision (beg end &optional region)
    (interactive (list (mark) (point)
                       (prefix-numeric-value current-prefix-arg)))
    (kill-ring-save beg end region))

  (defun juanleon/magit-in-supermodule ()
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

(use-package magit-rockstar
  :commands magit-rockstar magit-reshelve
  :ensure t)

(use-package git-link
  :ensure t
  :commands git-link git-link-commit
  :config
  (add-to-list 'git-link-remote-alist '("git.xcade.net"    git-link-github))
  (add-to-list 'git-link-remote-alist '("gitlab.xcade.net" git-link-github))
  (add-to-list 'git-link-remote-alist '("tcgit.xcade.net"  git-link-github))
  (add-to-list 'git-link-commit-remote-alist '("git.xcade.net"    git-link-commit-github))
  (add-to-list 'git-link-commit-remote-alist '("gitlab.xcade.net" git-link-commit-github))
  (add-to-list 'git-link-commit-remote-alist '("tcgit.xcade.net"  git-link-commit-github)))


(defun juanleon/iats-branch (branch)
  (interactive (list (magit-read-tag "Branch name: ")))
  (shell-command (concat "iatsBranch " branch))
  (magit-refresh))

(defun juanleon/iats-pull ()
  (interactive)
  (shell-command "iatsPull")
  (magit-refresh))

(defun juanleon/iats-push ()
  (interactive)
  (shell-command "iatsPush")
  (magit-refresh))

(defun juanleon/iats-merge (rev)
  (interactive (list (magit-read-other-branch-or-commit "Merge")))
  (shell-command (concat "iatsMerge " rev))
  (magit-refresh))

(defun juanleon/iats-switch (rev)
  (interactive (list (magit-read-other-branch-or-commit "Branch")))
  (shell-command (concat "iatsSwitch " rev))
  (magit-refresh))

(defun juanleon/iats-tag (tag comment)
  (interactive (list (magit-read-tag "Tag name")
                     (read-from-minibuffer "Comment: ")))
  (shell-command (format "iatsTag %s %s" tag comment))
  (magit-refresh))

(defun juanleon/visit-gitlab ()
  "Visit commit in gitlab"
  (interactive)
  (let* ((commit (magit-commit-at-point))
         (args (if commit (format "-r %s" commit) "")))
    (shell-command (format "juanleon-gitlab-utils %s visit" args))))

(defun juanleon/code-review (repo branch &optional no-fetch checkout)
  (let* ((repo-dir (format "/home/juanleon/www/%s" repo))
        (ref (format "origin/%s" branch))
        (sentinel `(lambda (process event)
                     (magit-log (list (concat "origin/master.." ,ref)) (list "-100"))
                     (if ,checkout (magit-checkout ,ref))
                     (magit-diff (concat "origin/master..." ,ref) nil))))
    (dired repo-dir)
    (if no-fetch
        (funcall sentinel nil nil)
      (set-process-sentinel (magit-fetch "origin" nil) sentinel))))
