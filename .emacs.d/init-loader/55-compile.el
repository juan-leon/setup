(defun juanleon/notify-compilation-end (comp-buffer result)
  (unless (or (eq major-mode 'grep-mode) (eq major-mode 'ack-and-a-half-mode))
    (start-process "notification" nil "notify-send" "-t" "60000"
                   "-i" "/usr/share/icons/hicolor/48x48/apps/emacs.png"
                   (concat "Compilation " result))))


(use-package compile
  :bind (([(f8)]         . compile)
         ([(control f6)] . recompile)
         ([(super kp-8)] . previous-error)
         ([(super kp-2)] . next-error)
         ([(f7)]         . juanleon/execute-buffer)
         ([(control f8)] . juanleon/goto-compilation-buffer))
  :init
  (setq compilation-scroll-output t
        next-error-highlight 'fringe-arrow)

  (defun juanleon/goto-compilation-buffer ()
    (interactive)
    (let ((buf (get-buffer "*compilation*")))
      (and buf (switch-to-buffer buf))))

  (defun juanleon/execute-buffer ()
    (interactive)
    (let ((compile-command nil))
      (compile buffer-file-name)))
  :config
  (add-hook 'compilation-finish-functions 'juanleon/notify-compilation-end))


(use-package quickrun
  :ensure t
  :bind (([(f5)]         . quickrun)
         ([(control f5)] . quickrun-with-arg))
  :init (setq quickrun-focus-p nil))


(use-package multi-compile
  :ensure t
  :bind ([(f6)] . multi-compile-run)
  :init
  (setq multi-compile-completion-system 'default
        multi-compile-alist
        '(("\\.*/hacks/\\.*" . (("run" . "%path")))
          (python-mode . (("pyrev" "pyrev" (multi-compile-locate-file-dir ".git"))
                          ("pyreview" "pyreview" (multi-compile-locate-file-dir ".git"))
                          ("pymypy" "pymypy" (multi-compile-locate-file-dir ".git")))))))
