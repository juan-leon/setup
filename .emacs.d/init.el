(package-initialize)

(setq init-loader-directory (concat user-emacs-directory "init-loader/")
      init-loader-show-log-after-init nil
      init-loader-byte-compile t
      byte-compile-warnings t
      custom-file (concat init-loader-directory "05-customize.el"))

(let ((byte-compile-warnings '(not unresolved free-vars)))
  (init-loader-load))
