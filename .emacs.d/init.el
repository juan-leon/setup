(package-initialize)

(global-set-key (kbd "C-p") nil)
(setq projectile-keymap-prefix (kbd "C-p"))

(add-to-list 'load-path (concat user-emacs-directory "packages") t)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

(unless (require 'use-package nil :noerror)
  (package-install 'use-package)
  (require 'use-package))

(setq init-loader-directory (concat user-emacs-directory "init-loader/")
      init-loader-show-log-after-init nil
      init-loader-byte-compile t
      byte-compile-warnings t
      custom-file (concat init-loader-directory "05-customize.el"))

(let ((byte-compile-warnings '(not unresolved free-vars)))
  (init-loader-load))
