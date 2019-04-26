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

(defun juanleon/dired-browse-html ()
  (interactive)
  (eww-open-file (dired-get-file-for-visit)))


(use-package dired
  :demand
  :bind (([(control ?x) (control ?d)] . dired-jump)
         ([(control meta ?0)] . juanleon/dired-at-repo)
         ([(super u)]         . juanleon/dired-recursive-by-extension)
         :map dired-mode-map
         ([?U] . dired-unmark-backward)
         ([?a] . juanleon/dired-hide-hidden)
         ([?e] . juanleon/dired-browse-html)
         ([(control return)] . dired-find-alternate-file)
         ([(backspace)] . dired-jump)
         ([(control backspace)] . dired-unmark-backward))
  :config
  (setq dired-copy-preserve-time nil
        dired-recursive-copies   'always)
  (unless (eq system-type 'darwin)
    (setq dired-listing-switches "--group-directories-first -al"))

  (add-hook 'dired-after-readin-hook
            (lambda ()
              (set (make-local-variable 'frame-title-format)
                   (abbreviate-file-name (dired-current-directory))))))


(use-package dired-x
  :after dired
  :bind (:map dired-mode-map ([(super h)] . dired-omit-mode))
  :config (add-hook 'dired-mode-hook (lambda () (dired-omit-mode t))))


(use-package wdired
  :after dired
  :bind (:map dired-mode-map ([?r] . wdired-change-to-wdired-mode)))


(use-package dired-efap
  :ensure t
  :after dired
  :bind (:map dired-mode-map
              ([f2] . dired-efap)
              ([down-mouse-1] . dired-efap-click)))


(use-package dired-quick-sort
  :ensure t
  :after dired
  :config
  (dired-quick-sort-setup))


(use-package peep-dired
  :ensure t
  :after dired
  :bind (:map dired-mode-map ([?P] . peep-dired))
  :config (setq peep-dired-cleanup-on-disable t))


(use-package dired-narrow
  :ensure t
  :bind (:map dired-mode-map ([?/] . dired-narrow)))


(use-package dired-ranger
  :ensure t
  :after dired
  :bind (:map dired-mode-map
              ("W" . dired-ranger-copy)
              ("X" . dired-ranger-move)
              ("Y" . dired-ranger-paste)))


(use-package dired-git-info
  :ensure t
  :after dired
  :bind (:map dired-mode-map (")" . dired-git-info-mode)))
