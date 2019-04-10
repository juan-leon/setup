(defun find-anything-at-point ()
  "Find the variable or function or file at point."
  (interactive)
  (cond ((not (eq (variable-at-point) 0))
         (call-interactively 'describe-variable))
        ((function-called-at-point)
         (call-interactively 'describe-function))
        (t
         (call-interactively 'find-file-at-point))))


(defun tmux-window-here ()
  "Open a new window on first session on current directory"
  (interactive)
  (if default-directory
      (shell-command
       (format "TMPDIR=/tmp/user/%d tmux new-window -t 0 -c %s"
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

(defun close-frame (arg)
  "Close frame and, if last, kill emacs"
  (interactive "P")
  (if (= (length (frame-list)) 1)
      (save-buffers-kill-emacs arg)
    (delete-frame)))

(defun java-compile (makefile command)
  "Search for a makefile from current dir and compile"
  (with-temp-buffer
    (while (and (not (and (file-exists-p makefile)
                          (not (file-exists-p (concat "../" makefile)))))
                (not (equal "/" default-directory)))
      (cd ".."))
    (compile command)))

(defun java-quickie ()
  "Compile current java buffer and run it if successful"
  (interactive)
  (let* ((source (file-name-nondirectory buffer-file-name))
         (out    (file-name-sans-extension source))
         (class  (concat out ".class")))
    (shell-command (format "rm -f %s && javac %s" class source))
    (if (file-exists-p class)
        (shell-command (format "java %s" out) "*scratch*")
      (compile (concat "javac " source)))))



(defun code-full-cleanup ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (whitespace-cleanup)
    (if (not indent-tabs-mode)
        (while (re-search-forward "\t" nil t)
          (replace-match (make-string tab-width ? ) nil nil)))
    (indent-region (point-min) (point-max))))

(defun indent-by-shell-command ()
  (interactive)
  (when (and buffer-read-only
             (memq major-mode '(c-mode c++-mode)))
    (let ((buffer-modified-p (buffer-modified-p))
          (inhibit-read-only t)
          (line (line-number-at-pos)))
      (shell-command-on-region (point-min) (point-max) "indent" nil t nil)
      (set-buffer-modified-p buffer-modified-p)
      (goto-char (point-min))
      (forward-line (1- line)))))



(defun sudo-powerup ()
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

(defun juanleon/execute-buffer ()
  (interactive)
  (let ((compile-command nil))
    (compile buffer-file-name)))

;; Helm will cause trouble with big TAGS files
(defun juanleon/find-tag-at-point ()
  (interactive)
  (xref-find-definitions (thing-at-point 'symbol)))


(defun juanleon/open-mail-at-point ()
  (interactive)
  (let ((link (thing-at-point 'line)))
    (shell-command (format "/usr/lib/thunderbird/thunderbird -thunderlink %s" link))))
