
(defun juanleon/tmux-window-here ()
  "Open a new window on first session on current directory"
  (interactive)
  (if default-directory
      (shell-command
       (format "TMPDIR=/tmp/user/%d tmux new-window -c %s"
               (user-uid) default-directory))
    (error "This buffer has no directory")))

(defun juanleon/comment-or-uncomment-region (beg end &optional arg)
  "Comment or uncoment whole lines in region"
  (interactive "*r\nP")
  (comment-or-uncomment-region (save-excursion
                                 (goto-char beg)
                                 (beginning-of-line)
                                 (point))
                               (save-excursion
                                 (goto-char end)
                                 (end-of-line)
                                 (point))
                               arg))


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


(defun juanleon/open-mail-at-point ()
  (interactive)
  (let ((link (thing-at-point 'line)))
    (shell-command (format "/usr/lib/thunderbird/thunderbird -thunderlink %s" link))))
