(add-to-list 'load-path (concat user-emacs-directory "packages") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(unless (require 'use-package nil :noerror)
  (package-refresh-contents)
  (package-install 'use-package)
  (require 'use-package))

(use-package init-loader
  :ensure t
  :init
  (setq init-loader-directory (concat user-emacs-directory "init-loader/")
        init-loader-show-log-after-init nil
        init-loader-byte-compile t
        byte-compile-warnings t
        custom-file (concat init-loader-directory "05-customize.el"))
  :config
  (let ((byte-compile-warnings '(not unresolved free-vars)))
    (init-loader-load)))
