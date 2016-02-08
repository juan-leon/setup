(use-package dired
  :config
  (require 'dired-x)

  (setq dired-copy-preserve-time  nil
        dired-recursive-copies   'always
        dired-listing-switches    "--group-directories-first -al")

  (add-hook 'dired-mode-hook (lambda () (dired-omit-mode t)))
  (add-hook 'dired-after-readin-hook
            (lambda ()
              (set (make-local-variable 'frame-title-format)
                   (abbreviate-file-name (dired-current-directory)))))

  (global-set-key [(control meta ?0)] 'juanleon/dired-at-repo)
  (global-set-key [(control meta ?')] 'juanleon/dired-at-other-repo)
  (global-set-key [(super u)]         'juanleon/dired-recursive-by-extension)
  (define-key dired-mode-map [?r] 'wdired-change-to-wdired-mode)
  (define-key dired-mode-map [?U] 'dired-unmark-backward)
  (define-key dired-mode-map [?a] 'juanleon/dired-hide-hidden)
  (define-key dired-mode-map [f2] 'dired-efap)
  (define-key dired-mode-map [(super h)] 'dired-omit-mode)
  (define-key dired-mode-map [down-mouse-1] 'dired-efap-click)
  (define-key dired-mode-map [(control return)] 'dired-find-alternate-file)
  (define-key dired-mode-map [(backspace)] 'dired-jump)
  (define-key dired-mode-map [(control backspace)] 'dired-unmark-backward))

(use-package dired-x
  :ensure t
  :bind ([(control ?x) (control ?d)] . dired-jump))

(use-package diredx
  :ensure t
  :bind ([(super ?<)] . direx:jump-to-directory)
  :config
  (defun juanleon/direx-at-repo ()
    "Open direx on the base directory on a git repo"
    (interactive)
    (let ((dir (locate-dominating-file default-directory ".git/")))
      (if dir
          (direx:find-directory dir)
        (message "Not in a git repo"))))
  (global-set-key [(control meta ?=)] 'juanleon/direx-at-repo))

(use-package dired-efap
  :ensure t)

(defun juanleon/dired-recursive-by-extension (extension)
  (interactive (list (read-string "Extension: ")))
  (find-dired default-directory (concat "-name '*." extension "'")))

(defun juanleon/dired-at-repo ()
  "Open dired on the base directory on a git repo"
  (interactive)
  (let ((dir (locate-dominating-file default-directory ".git/")))
    (if dir
        (dired dir)
      (message "Not in a git repo"))))

(defun juanleon/dired-hide-hidden ()
  (interactive)
  (let ((dired-actual-switches "--group-directories-first -l"))
    (revert-buffer)))

(defun juanleon/dired-at-other-repo ()
  (interactive)
  (with-temp-buffer
    (cd "~/www")
    (ido-dired)))
