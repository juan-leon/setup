
(defun juanleon/tmux-window-here ()
  "Open a new window on first session on current directory"
  (interactive)
  (if default-directory
      (shell-command
       (format "TMPDIR=/tmp/user/%d tmux new-window -c %s"
               (user-uid) default-directory))
    (error "This buffer has no directory")))



(defun juanleon/sudo-powerup ()
  (interactive)
  (if buffer-file-name
      (let ((point (point)))
        (find-alternate-file
         (if (tramp-tramp-file-p buffer-file-name)
             (progn
               (string-match "^/\\w*:" buffer-file-name)
               (replace-match "/sudo:" nil nil buffer-file-name))
           (concat "/sudo::" buffer-file-name)))
        (goto-char point))))


;; Helm will cause trouble with big TAGS files
(defun juanleon/find-tag-at-point ()
  (interactive)
  (xref-find-definitions (thing-at-point 'symbol)))
