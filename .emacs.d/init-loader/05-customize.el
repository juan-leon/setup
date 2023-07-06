(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-keys '(up down left right))
 '(avy-lead-faces
   '(avy-lead-face avy-lead-face-0 avy-lead-face avy-lead-face-0 avy-lead-face avy-lead-face-0) t)
 '(browse-url-browser-function 'browse-url-firefox)
 '(copy-as-format-default "gitlab")
 '(custom-safe-themes
   '("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default))
 '(ediff-diff-options " -bB ")
 '(ediff-split-window-function 'split-window-horizontally)
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(flycheck-json-python-json-executable "python3.7")
 '(flycheck-python-flake8-executable "/home/juanleon/.envs/lint/bin/flake8")
 '(flycheck-python-pycompile-executable "/home/juanleon/.envs/lint/bin/python")
 '(flyspell-abbrev-p t)
 '(flyspell-correct-interface 'flyspell-correct-ivy)
 '(forge-alist
   '(("github.com" "api.github.com" "github.com" forge-github-repository)
     ("gitlab.com" "gitlab.com/api/v4" "gitlab.com" forge-gitlab-repository)
     ("gitlab.xcade.net" "gitlab.xcade.net/api/v4" "gitlab.xcade.net" forge-gitlab-repository)))
 '(git-messenger:show-detail t t)
 '(ibuffer-formats
   '((mark modified read-only " "
           (name 42 42)
           " "
           (size 9 9 :right)
           " "
           (mode 21 21 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 30 -1)
           " " filename)))
 '(jedi:tooltip-method nil)
 '(lsp-file-watch-ignored-directories
   '("[/\\\\]\\.git\\'" "[/\\\\]\\.github\\'" "[/\\\\]\\.circleci\\'" "[/\\\\]\\.hg\\'" "[/\\\\]\\.bzr\\'" "[/\\\\]_darcs\\'" "[/\\\\]\\.svn\\'" "[/\\\\]_FOSSIL_\\'" "[/\\\\]\\.idea\\'" "[/\\\\]\\.ensime_cache\\'" "[/\\\\]\\.eunit\\'" "[/\\\\]node_modules" "[/\\\\]\\.yarn\\'" "[/\\\\]\\.fslckout\\'" "[/\\\\]\\.tox\\'" "[/\\\\]dist\\'" "[/\\\\]dist-newstyle\\'" "[/\\\\]\\.stack-work\\'" "[/\\\\]\\.bloop\\'" "[/\\\\]\\.metals\\'" "[/\\\\]target\\'" "[/\\\\]\\.ccls-cache\\'" "[/\\\\]\\.vscode\\'" "[/\\\\]\\.venv\\'" "[/\\\\]\\.mypy_cache\\'" "[/\\\\]\\.deps\\'" "[/\\\\]build-aux\\'" "[/\\\\]autom4te.cache\\'" "[/\\\\]\\.reference\\'" "bazel-[^/\\\\]+\\'" "[/\\\\]\\.meta\\'" "[/\\\\]Library\\'" "[/\\\\]\\.lsp\\'" "[/\\\\]\\.clj-kondo\\'" "[/\\\\]\\.shadow-cljs\\'" "[/\\\\]\\.babel_cache\\'" "[/\\\\]\\.cpcache\\'" "[/\\\\]\\checkouts\\'" "[/\\\\]\\.gradle\\'" "[/\\\\]\\.m2\\'" "[/\\\\]bin/Debug\\'" "[/\\\\]obj\\'" "[/\\\\]_opam\\'" "[/\\\\]\\.cache\\'" "[/\\\\]\\.elixir_ls\\'" "[/\\\\]\\.direnv\\'"))
 '(lsp-pyls-plugins-flake8-config "/home/juanleon/.flake8")
 '(magit-log-arguments '("-n48"))
 '(magit-push-arguments nil)
 '(magit-rebase-arguments '("--keep-empty" "--autosquash"))
 '(magit-tag-arguments '("--annotate"))
 '(markdown-gfm-additional-languages '("bash"))
 '(notmuch-saved-searches
   '((:name "inbox" :query "tag:inbox" :key "i")
     (:name "unread" :query "tag:unread" :key "u")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t")
     (:name "drafts" :query "tag:draft" :key "d")
     (:name "all mail" :query "*" :key "a")
     (:name "last day" :query "date:yesterday..today")
     (:name "Last release" :query "from:juanleon subject:Release date:9days..")))
 '(package-selected-packages
   '(rustic company lsp-treemacs lsp-ivy speed-type typescript-mode lsp-ui flycheck-rust svelte-mode counsel-jq groovy-mode protobuf-mode deft org-journal bbdb-vcard bbdb counsel-bbdb use-package rust-mode stripe-buffer server midnight atomic-chrome python-mode dired-subtree quickrun dired-git-info powerthesaurus easy-kill hcl-mode smartparens forge org flyspell-correct-ivy deadgrep counsel-dash counsel-projectile counsel ivy-hydra swiper ivy orgtbl-aggregate docker-compose-mode docker async-await promise request minions auto-yasnippet org-radiobutton ace-window org-download beginend helpful dumb-jump exec-path-from-shell jedi-core git-messenger magit flycheck go-mode move-text markdown-mode projectile php-mode hydra color-theme which-key auto-complete ws-butler dired-quick-sort git-commit define-word python-switch-quotes notmuch syntactic-close copy-as-format git-link swap-buffers switch-window multi-compile dired-ranger mu4e-alert shrink-whitespace fancy-battery visible-mark beacon calfw imenu-list ggtags general-close refine yascroll xkcd ws-trim wrap-region wgrep undo-tree toml-mode sr-speedbar smooth-scroll smex scroll-restore rotate pymacs pylint pyflakes puppet-mode powerline peep-dired paradox org-bullets occur-x nginx-mode multiple-cursors memory-usage magit-rockstar lua-mode load-theme-buffer-local key-chord jedi ipython init-loader inf-mongo htmlize goto-chg golden-ratio git-timemachine git-gutter geben fixme-mode fill-column-indicator expand-region everything etags-table edit-server dockerfile-mode discover-my-major direx dired-narrow dired-efap ctags color-theme-solarized color-theme-sanityinc-solarized color-theme-buffer-local buffer-stack buffer-move browse-kill-ring bm back-button avy ag ack-and-a-half))
 '(paradox-github-token t)
 '(projectile-switch-project-action
   #[nil "\300\301 !\203\12\0\302 \207\303 \207"
         [magit-git-repo-p projectile-project-root magit-status projectile-dired]
         2])
 '(projectile-tags-command "ctags-exuberant -Re -f \"%s\" %s")
 '(ripgrep-arguments '("-M 200"))
 '(safe-local-variable-values
   '((org-startup-with-inline-images . t)
     (org-use-property-inheritance . t)
     (org-confirm-babel-evaluate)
     (test-case-name . twisted.test.test_usage)
     (eval add-to-list 'before-save-hook code-full-cleanup)
     (nxml-child-indent . 2)
     (eval make-variable-buffer-local 'before-save-hook)
     (eval add-to-list 'before-save-hook)))
 '(save-abbrevs 'silently)
 '(save-place-file "~/.emacs.d/history/places")
 '(send-mail-function 'smtpmail-send-it)
 '(svelte-basic-offset 4)
 '(switch-window-shortcut-style 'qwerty)
 '(uniquify-buffer-name-style 'post-forward-angle-brackets nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(git-timemachine-minibuffer-detail-face ((t (:foreground "deep sky blue"))))
 '(org-agenda-date-weekend ((t (:inherit org-agenda-date :foreground "dark gray"))))
 '(org-journal-dir "~/Dropbox/org/journal/")
 '(stripe-highlight ((t (:background "#e4e4d4"))) t))
