(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default))
 '(magit-log-arguments '("-n48"))
 '(magit-rebase-arguments '("--keep-empty" "--autosquash"))
 '(magit-tag-arguments '("--annotate"))
 '(notmuch-saved-searches
   '((:name "inbox" :query "tag:inbox" :key "i")
     (:name "unread" :query "tag:unread" :key "u")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t")
     (:name "drafts" :query "tag:draft" :key "d")
     (:name "all mail" :query "*" :key "a")))
 '(package-selected-packages
   '(counsel-notmuch counsel-dash counsel-projectile counsel ivy-hydra swiper ivy orgtbl-aggregate helm-tramp docker-compose-mode docker async-await promise request minions auto-yasnippet org-radiobutton ace-window org-download beginend helpful dumb-jump exec-path-from-shell jedi-core git-messenger magit flycheck go-mode move-text markdown-mode projectile php-mode hydra helm-projectile color-theme helm-files which-key auto-complete ws-butler dired-quick-sort projectile-ripgrep git-commit define-word python-switch-quotes notmuch syntactic-close copy-as-format git-link swap-buffers switch-window multi-compile dired-ranger mu4e-alert shrink-whitespace fancy-battery visible-mark beacon calfw imenu-list ggtags general-close refine yascroll xkcd ws-trim wrap-region wgrep undo-tree toml-mode string-utils sr-speedbar smooth-scroll smex scroll-restore rotate pymacs pylint pyflakes puppet-mode powerline popwin peep-dired paradox org-bullets occur-x nginx-mode multiple-cursors minimap memory-usage magit-rockstar lua-mode load-theme-buffer-local key-chord jedi ipython init-loader inf-mongo htmlize helm-swoop helm-rhythmbox helm-proc helm-ls-git helm-descbinds helm-dash goto-chg golden-ratio git-timemachine git-gutter geben flx-ido fixme-mode fill-column-indicator expand-region everything etags-table ess erlang emms edit-server dockerfile-mode discover-my-major direx dired-narrow dired-efap ctags color-theme-solarized color-theme-sanityinc-solarized color-theme-buffer-local buffer-stack buffer-move browse-kill-ring bm back-button avy anzu anaphora ag ack-and-a-half ace-jump-mode))
 '(paradox-github-token t)
 '(safe-local-variable-values
   '((org-use-property-inheritance . t)
     (org-confirm-babel-evaluate)
     (test-case-name . twisted\.test\.test_usage)
     (eval add-to-list 'before-save-hook code-full-cleanup)
     (nxml-child-indent . 2)
     (eval make-variable-buffer-local 'before-save-hook)
     (eval add-to-list 'before-save-hook)))
 '(send-mail-function 'smtpmail-send-it))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "brown"))))
 '(git-timemachine-minibuffer-detail-face ((t (:foreground "deep sky blue")))))
