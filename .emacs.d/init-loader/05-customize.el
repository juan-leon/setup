(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default))
 '(forge-alist
   '(("github.com" "api.github.com" "github.com" forge-github-repository)
     ("gitlab.com" "gitlab.com/api/v4" "gitlab.com" forge-gitlab-repository)
     ("gitlab.xcade.net" "gitlab.xcade.net/api/v4" "gitlab.xcade.net" forge-gitlab-repository)))
 '(magit-log-arguments '("-n48"))
 '(magit-push-arguments nil)
 '(magit-rebase-arguments '("--keep-empty" "--autosquash"))
 '(magit-tag-arguments '("--annotate"))
 '(notmuch-saved-searches
   '((:name "inbox" :query "tag:inbox" :key "i")
     (:name "unread" :query "tag:unread" :key "u")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t")
     (:name "drafts" :query "tag:draft" :key "d")
     (:name "all mail" :query "*" :key "a")
     (:name "last day" :query "date:yesterday..today")))
 '(package-selected-packages
   '(stripe-buffer server midnight atomic-chrome validate dired-subtree quickrun dired-git-info easy-kill hcl-mode spartparens forge org flyspell-correct-ivy deadgrep counsel-dash counsel-projectile counsel ivy-hydra swiper ivy orgtbl-aggregate docker-compose-mode docker async-await promise request minions auto-yasnippet org-radiobutton ace-window helpful dumb-jump exec-path-from-shell jedi-core git-messenger magit flycheck go-mode move-text markdown-mode projectile php-mode hydra which-key auto-complete ws-butler dired-quick-sort projectile-ripgrep git-commit define-word python-switch-quotes notmuch syntactic-close copy-as-format git-link swap-buffers switch-window multi-compile dired-ranger shrink-whitespace visible-mark yascroll xkcd wrap-region wgrep toml-mode string-utils smex scroll-restore rotate pyflakes puppet-mode powerline peep-dired org-bullets occur-x nginx-mode multiple-cursors memory-usage magit-rockstar lua-mode key-chord jedi ipython init-loader htmlize goto-chg git-timemachine git-gutter fixme-mode fill-column-indicator expand-region ess erlang edit-server dockerfile-mode discover-my-major direx dired-narrow dired-efap ctags color-theme-sanityinc-solarized buffer-stack buffer-move browse-kill-ring bm back-button avy ag ack-and-a-half ace-jump-mode))
 '(safe-local-variable-values
   '((org-startup-with-inline-images . t)
     (org-use-property-inheritance . t)
     (org-confirm-babel-evaluate))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "brown"))))
 '(git-timemachine-minibuffer-detail-face ((t (:foreground "deep sky blue"))))
 '(org-agenda-date-weekend ((t (:inherit org-agenda-date :foreground "dark gray")))))
