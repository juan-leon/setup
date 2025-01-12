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

(defun juanleon/iats-switch (rev)
  (interactive (list (magit-read-other-branch-or-commit "Branch")))
  (shell-command (concat "iatsSwitch " rev))
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
                     (magit-log-other (list (concat "origin/master.." ,ref)) (list "-100"))
                     (if ,checkout (magit-checkout ,ref))
                     (magit-diff-range (concat "origin/master..." ,ref) nil))))
    (delete-other-windows)
    (dired repo-dir)
    (if no-fetch
        (funcall sentinel nil nil)
      (set-process-sentinel (magit-fetch-all-prune) sentinel))))

(defun juanleon/visit-teg-from-branch ()
  "Visit teg case, based on branch name"
  (interactive)
  (shell-command "cases open --git"))


(use-package magit
  :bind (([(super ?0)] . magit-status)
         ([(control ?\))] . magit-status))
  :commands magit-git-repo-p magit-status
  :ensure t
  :init
  (setq magit-revision-insert-related-refs nil
        magit-display-buffer-function 'magit-display-buffer-fullcolumn-most-v1
        git-commit-summary-max-length 70)
  :config
  ;; (define-key magit-status-mode-map [(? )] 'magit-show-commit)
  (define-key magit-status-mode-map [backspace] 'juanleon/magit-in-supermodule)
  (define-key magit-mode-map [(control backspace)] 'juanleon/visit-gitlab)
  (add-hook 'git-commit-mode-hook #'turn-on-flyspell)
  (transient-append-suffix 'magit-branch "n" '("I" "iatsBranch" juanleon/iats-branch))
  (transient-append-suffix 'magit-branch "b" '("S" "iatsSwitch" juanleon/iats-switch))
  (transient-append-suffix 'magit-pull "e" '("I" "iatsPull" juanleon/iats-pull))
  (transient-append-suffix 'magit-push "t" '("I" "iatsPush" juanleon/iats-push))
  (transient-append-suffix 'magit-rebase "f" '("R" "Rockstar" magit-rockstar))
  (transient-append-suffix 'magit-rebase "R" '("N" "Reshelve" magit-reshelve))
  (transient-append-suffix 'magit-run "S" '("T" "Open TEG" juanleon/visit-teg-from-branch))

  (defun juanleon/magit-in-supermodule ()
    (interactive)
    (with-temp-buffer
      (cd "..")
      (if (magit-toplevel)
          (magit-status default-directory)))))


(use-package git-messenger
  :ensure t
  :bind ([(control ?x) ?v ?p] . git-messenger:popup-message)
  :init (setq git-messenger:show-detail t)
  :config (define-key git-messenger-map (kbd "m") 'git-messenger:copy-message))


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


;; Config: in ~/.authinfo.gpg, this line
;; machine XXX.XXX.XXX/api/v4 login XXX^forge XXX
(use-package forge
  :ensure t
  :commands juanleon/mr
  :after magit
  :bind (:map magit-mode-map ([(super ?f)] . forge-dispatch))
  :config
  (setq forge-notifications-selection '())
  (defun juanleon/mr ()
    (interactive)
    (forge-create-pullreq
     (format "origin/%s" (magit-get-current-branch)) "origin/master"))

  (defun juanleon/assign-mr ()
    (interactive)
    (insert "\n/assign susana.ledesma\n/reviewer quimey.vivas"))

  (add-hook 'forge-post-mode-hook (lambda ()
                                    (local-set-key [(super ?a)] 'juanleon/assign-mr))))
