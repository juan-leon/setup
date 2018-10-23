(defun juanleon/delete-trailing-blank-lines ()
  "Deletes all blank lines at the end of the file."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))

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

(defun toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message "Window '%s' is %s" (current-buffer)
           (if (let (window (get-buffer-window (current-buffer)))
                 (set-window-dedicated-p window
                                         (not (window-dedicated-p window))))
               "dedicated" "normal")))



(defun juanleon/notify-compilation-end (comp-buffer result)
  (unless (or (eq major-mode 'grep-mode) (eq major-mode 'ack-and-a-half-mode))
    (start-process "notification" nil "notify-send" "-t" "60000"
                   "-i" "/usr/share/icons/hicolor/48x48/apps/emacs.png"
                   (concat "Compilation " result))))

(defun code-full-cleanup ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (whitespace-cleanup)
    (if (not indent-tabs-mode)
        (while (re-search-forward "\t" nil t)
          (replace-match (make-string 2 ? ) nil nil)))
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

;; Most of the times I don't use rope
(defun use-ropemacs ()
  (interactive)
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/pymacs")
  (require 'pymacs)
  (pymacs-load "ropemacs" "rope-")
  (setq ropemacs-confirm-saving 'nil))

(defun toggle-split ()
  "Toggle vertical/horizontal window split."
  (interactive)
  (let ((buff-b (window-buffer (next-window)))
        (height (window-body-height))
        (width  (window-body-width)))
    (delete-other-windows)
    (if (> height (/ width 5))
        (split-window-vertically)
      (split-window-horizontally))
    (set-window-buffer (next-window) buff-b)))


(defun sudo-powerup ()
  (interactive)
  (if buffer-file-name
      (find-alternate-file
       (if (tramp-tramp-file-p buffer-file-name)
           (progn
             (string-match "^/\\w*:" buffer-file-name)
             (replace-match "/sudo:" nil nil buffer-file-name))
         (concat "/sudo::" buffer-file-name)))))

(defun juanleon/execute-buffer ()
  (interactive)
  (let ((compile-command nil))
    (compile buffer-file-name)))

;; Helm will cause trouble with big TAGS files
(defun juanleon/find-tag-at-point ()
  (interactive)
  (xref-find-definitions (thing-at-point 'symbol)))

;; Funny how packahe pyimport decided a poor's man version of same approach
;; (instead of looking in the filesystem, it looks in the opened buffers)
(defun juanleon/copy-import ()
  (interactive)
  (projectile-with-default-dir (projectile-project-root)
    (let ((command (format
                    "rg -g '*.py' --no-filename -N -w '^from\\b.*\\bimport\\b.*\\b%s' | head -1"
                    (symbol-at-point))))
      (kill-new (shell-command-to-string command)))))

(defun juanleon/open-mail-at-point ()
  (interactive)
  (let ((link (thing-at-point 'line)))
    (shell-command (format "/usr/lib/thunderbird/thunderbird -thunderlink %s" link))))
