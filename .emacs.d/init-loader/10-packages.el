(add-to-list 'load-path (concat user-emacs-directory "packages") t)

(when (require 'package nil t)
  (add-to-list 'package-archives
               '("marmalade" . "http://marmalade-repo.org/packages/") t)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t))

(defun install-base-packages ()
  (interactive)
  (package-refresh-contents)
  (dolist (p base-packages)
    (or (package-installed-p p)
        (package-install p))))

(setq base-packages
      '(ack-and-a-half
        auto-complete
        back-button
        bm
        browse-kill-ring
        buffer-stack
        button-lock
        color-theme-sanityinc-solarized
        ctags
        dired-efap
        edit-server
        epl
        ess
        etags-table
        everything
        expand-region
        fill-column-indicator
        fixmee
        flx
        flx-ido
        flycheck
        git-commit-mode
        git-gutter
        git-rebase-mode
        htmlize
        init-loader
        ipython
        key-chord
        list-utils
        load-theme-buffer-local
        magit
        markdown-mode
        memory-usage
        multiple-cursors
        nav-flash
        occur-x
        org-bullets
        pcache
        persistent-soft
        php-mode
        pkg-info
        popup
        projectile
        smartrep
        smex
        sr-speedbar
        string-utils
        undo-tree
        wgrep
        ws-trim
        yascroll
        yasnippet))
