(defvar teg-lists '("juanleon" "javier" "julio" "ruben" "joseluis" "all" "reviews" "team" "ft" "ramiro" "seppo" "juan"))

(defun juanleon/cases(list-name &optional no-cache sort-by)
  (interactive (list (completing-read "List name: " teg-lists)))
  (let* ((buf (get-buffer-create (format "*cases-%s*" list-name)))
         (inhibit-read-only t))
    (switch-to-buffer buf)
    (make-local-variable 'teg-list)
    (setq teg-list list-name)
    (erase-buffer)
    (shell-command
     (format "cases %s list -K --format orgtbl %s %s"
             (if no-cache "--http-cache 0" "")
             (if sort-by (format "--sort-by '%s'" sort-by) "")
             list-name)
     buf buf)
    (juanleon/cases-mode)))

(defvar juanleon/cases-mode-map
  (let ((m (make-sparse-keymap)))
    (define-key m [return] 'juanleon/cases-browse-by-id)
    (define-key m [?c]     'juanleon/cases-copy-url)
    (define-key m [?C]     'juanleon/cases-copy-all)
    (define-key m [?g]     'juanleon/cases-refresh)
    (define-key m [?i]     'juanleon/cases-summary)
    (define-key m [?I]     'juanleon/cases-sort-by-id)
    (define-key m [?S]     'juanleon/cases-sort-by-step)
    (define-key m [?P]     'juanleon/cases-sort-by-prio)
    (define-key m [?q]     'bury-buffer)
    m)
  "Keymap for `juanleon/cases-mode'.")

(define-minor-mode juanleon/cases-mode
  "Browse my opened cases.

\\{juanleon/cases-mode-map}"
  :init-value nil
  :keymap 'juanleon/cases-mode-map
  :lighter "<cases>"
  (read-only-mode 1)
  (stripes-mode 1))

(defun juanleon/cases-case-url ()
  (save-excursion
    (save-restriction
      (beginning-of-line)
      (if (re-search-forward "|.*?|\s*\\([0-9]+\\)\s*|" nil t)
          (concat "https://teg.avature.net/#Case/" (match-string 1))))))

(defun juanleon/cases-case-title ()
  (save-excursion
    (save-restriction
      (beginning-of-line)
      (if (re-search-forward "^|\s+\\(.*?\\)\s*|" nil t)
          (match-string 1)))))

(defun juanleon/cases-browse-by-id ()
  (interactive)
  (let ((browse-url-browser-function 'browse-url-default-browser)
        (url (juanleon/cases-case-url)))
    (if url
        (progn
          (message (format "Opening %s" url))
          (browse-url url))
      (message "No case in this line"))))

(defun juanleon/cases-copy-url ()
  (interactive)
  (let ((url (juanleon/cases-case-url)))
    (if url
        (kill-new url)
      (message "No case in this line"))))

(defun juanleon/cases-copy-all ()
  (interactive)
  (let ((url (juanleon/cases-case-url))
        (title (juanleon/cases-case-title)))
    (if url
        (kill-new (concat url ": " title))
      (message "No case in this line"))))

(defun juanleon/cases-refresh ()
  (interactive)
  (juanleon/cases teg-list t))

(defun juanleon/cases-sort-by-id ()
  (interactive)
  (juanleon/cases teg-list t "Case ID"))

(defun juanleon/cases-sort-by-step ()
  (interactive)
  (juanleon/cases teg-list t "Case Workflow step"))

(defun juanleon/cases-sort-by-prio ()
  (interactive)
  (juanleon/cases teg-list t "Priority"))

(defun juanleon/cases-summary ()
  (interactive)
  (message "There are %d cases" (- (line-number-at-pos (point-max)) 3)))

(require 'stripes)
