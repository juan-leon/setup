(add-to-list 'load-path (concat user-emacs-directory "packages") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
;; (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)


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
    ;; Trick to speed up a little initial load
    (setq gc-cons-threshold (* 64 1024 1024))
    (init-loader-load)
    (setq gc-cons-threshold (* 10 1024 1024))))
