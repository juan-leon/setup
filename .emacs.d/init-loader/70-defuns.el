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

(defun leon/comment-or-uncomment-region (beg end &optional arg)
  "Comment or uncoment whole lines in region"
  (interactive "*r\nP")
  (comment-or-uncomment-region (save-excursion
                                 (goto-char beg)
                                 (beginning-of-line)
                                 (point))
                               (save-excursion
                                 (goto-char end)
                                 (end-of-line)
                                 (point)) arg))

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

;; This way is easy to choose if "_" is a word separator
(defun leon/toggle-underscore-syntax ()
  "Switch the char _ in-word behaviour."
  (interactive)
  (modify-syntax-entry ?_ (if (= (char-syntax ?_) ?_) "w" "_"))
  (message (concat "\"_\" is " (if (= (char-syntax ?_) ?_) "symbol" "word"))))

;; To move the cursor to func definition
(defun next-function-name-face ()
  "Point to next `font-lock-function-name-face' text."
  (interactive)
  (let ((pos (point)))
    (if (eq (get-text-property pos 'face) 'font-lock-function-name-face)
        (setq pos (or (next-property-change pos) (point-max))))
    (setq pos (text-property-any pos (point-max) 'face
                                 'font-lock-function-name-face))
    (if pos
        (goto-char pos)
      (goto-char (point-max)))))

(defun prev-function-name-face ()
  "Point to previous `font-lock-function-name-face' text."
  (interactive)
  (let ((pos (point)))
    (if (eq (get-text-property pos 'face) 'font-lock-function-name-face)
        (setq pos (or (previous-property-change pos) (point-min))))
    (setq pos (previous-property-change pos))
    (while (and pos (not (eq (get-text-property pos 'face)
                             'font-lock-function-name-face)))
      (setq pos (previous-property-change pos)))
    (if pos
        (progn
          (setq pos (previous-property-change pos))
          (goto-char (or (and pos (1+ pos)) (point-min))))
      (goto-char (point-min)))))

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

(defun squealer-last-error (&optional arg)
  (interactive "p")
  (or arg (setq arg 1))
  (let ((buf (get-buffer-create "*squealer*"))
        (inhibit-read-only t))
    (switch-to-buffer buf)
    (erase-buffer)
    (shell-command
     (format "echo \"SELECT description, stack FROM reportFullText ORDER BY reportId DESC LIMIT 1 OFFSET %d\" | mysql -u root squealer --pager=cat -r -s" (1- arg))
     buf
     buf)
    (compilation-mode)
    (make-local-variable 'compilation-error-regexp-alist)
    (add-to-list 'compilation-error-regexp-alist '("^#[0-9] \\[\\(/[^ ]*?\\):\\([0-9]+\\)\\]" 1 2))
    (add-to-list 'compilation-error-regexp-alist '("^#[0-9]+ \\(/[^ ]*?\\)(\\([0-9]+\\)):" 1 2))
    (add-to-list 'compilation-error-regexp-alist '("\\(/[^ ]*?\\):\\([0-9]+\\)$" 1 2))))

(defun extended-word-at-point ()
  (let ((underscore-syntax (if (= (char-syntax ?_) ?_) "_" "w"))
        (dash-syntax (if (= (char-syntax ?-) ?_) "_" "w")))
    (modify-syntax-entry ?_ "w")
    (modify-syntax-entry ?- "w")
    (prog1
        (thing-at-point 'word)
      (modify-syntax-entry ?_ underscore-syntax)
      (modify-syntax-entry ?- dash-syntax))))

(defun juanleon/browse-zeal (arg lang)
  (interactive (list
                (extended-word-at-point)
                (cond
                 ((eq major-mode 'emacs-lisp-mode) "emacs:")
                 ((eq major-mode 'js-mode) "javascript:")
                 ((eq major-mode 'php-mode) "php:")
                 ((eq major-mode 'python-mode) "python:")
                 ((eq major-mode 'sql-mode) "mysql:")
                 ((eq major-mode 'go-mode) "go:")
                 ((eq major-mode 'sql-interactive-mode) "mysql:")
                 ((eq major-mode 'sh-mode) "bash:")
                 ((eq major-mode 'html-mode) "html:")
                 ((eq major-mode 'ruby-mode) "ruby:")
                 ((eq major-mode 'css-mode) "css:"))
                ))
  (start-process "zeal" nil "zeal" "--query" (concat lang arg)))

(defun json-beautify-on-region (beg end)
  (interactive "r")
  (shell-command-on-region beg end "python -m json.tool" nil t))

(defun point-in-string-p (pt)
  "Returns t if PT is in a string"
  (eq 'string (syntax-ppss-context (syntax-ppss pt))))

(defun beginning-of-string ()
  "Moves to the beginning of a syntactic string"
  (interactive)
  (unless (point-in-string-p (point))
    (error "You must be in a string for this command to work"))
  (while (point-in-string-p (point))
    (forward-char -1))
  (point))

(defun swap-quotes ()
  "Swaps the quote symbols in a string"
  (interactive)
  (save-excursion
    (let ((bos (save-excursion
                 (beginning-of-string)))
          (eos (save-excursion
                 (beginning-of-string)
                 (forward-sexp)
                 (point)))
          (replacement-char ?\'))
      (goto-char bos)
      ;; if the following character is a single quote then the
      ;; `replacement-char' should be a double quote.
      (when (eq (following-char) ?\')
          (setq replacement-char ?\"))
      (delete-char 1)
      (insert replacement-char)
      (goto-char eos)
      (delete-char -1)
      (insert replacement-char))))

(defun juanleon/execute-buffer ()
  (interactive)
  (let ((compile-command nil))
    (compile buffer-file-name)))

;; Helm will cause trouble with big TAGS files
(defun juanleon/find-tag-at-point ()
  (interactive)
  (find-tag (thing-at-point 'symbol)))

;; Funny how packahe pyimport decided a poor's man version of same approach
;; (instead of looking in the filesystem, it looks in the opened buffers)
(defun juanleon/copy-import()
  (interactive)
  (projectile-with-default-dir (projectile-project-root)
    (let ((command (format
                    "find -name '*py' -exec  grep '^from.*import' {} \\; 2>/dev/null | sort | uniq | grep -w %s"
                    (word-at-point))))
      (kill-new (shell-command-to-string command)))))
