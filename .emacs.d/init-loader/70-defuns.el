(defun find-anything-at-point ()
  "Find the variable or function or file at point."
  (interactive)
  (cond ((not (eq (variable-at-point) 0))
         (call-interactively 'describe-variable))
        ((function-called-at-point)
         (call-interactively 'describe-function))
        (t
         (call-interactively 'find-file-at-point))))

(defun dired-at-repo ()
  "Open dired on the base directory on a git repo"
  (interactive)
  (with-temp-buffer
    (while (and (not (file-exists-p ".git/"))
                (not (equal "/" default-directory)))
      (cd ".."))
    (dired default-directory)))

(defun tmux-window-here ()
  "Open a new window on juanleon session on current directory"
  (interactive)
  (if default-directory
      (shell-command
       (format "TMPDIR=/tmp/user/%d tmux new-window -t juanleon -c %s"
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

(defun notify-compilation-end (comp-buffer result)
  (unless (eq major-mode 'grep-mode)
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

(defun browse-javadoc ()
  (interactive)
  (let ((class (thing-at-point 'word)))
    (save-excursion
      (save-restriction
        (goto-char (point-min))
        (if (re-search-forward (concat "^import\s+\\(.*\\." class  "\\);$") nil t)
            (let ((url (concat "http://www.google.es/search?q=javadoc+"
                               (match-string 1)
                               "+overview+frames&btnI=")))
              (browse-url url))
          (message "No class at point"))))))

(defun toggle-theme ()
  "Toggle dark/light theme"
  (interactive)
  (let* ((b-color (frame-parameter nil 'background-color))
         (d-light (color-distance "white" b-color))
         (d-dark  (color-distance "black" b-color)))
    (if (> d-light d-dark)
        (enable-theme leon-light-theme)
      (enable-theme leon-dark-theme))))

(defun dired-recursive-by-extension (extension &optional no-target)
  (interactive (list (read-string "Extension: ")))
  (let ((target (if no-target " ! -path \"*target*\" " "")))
    (find-dired default-directory (concat "-name \"*." extension "\"" target))))

(defun dired-recursive-by-extension-no-target (extension)
  (interactive (list (read-string "Extension: ")))
  (dired-recursive-by-extension extension t))

(defun sudo-powerup ()
  (interactive)
  (if buffer-file-name
      (find-alternate-file
       (if (tramp-tramp-file-p buffer-file-name)
           (progn
             (string-match "^/\\w*:" buffer-file-name)
             (replace-match "/sudo:" nil nil buffer-file-name))
         (concat "/sudo:root@localhost:" buffer-file-name)))))
