(defvar squealer/host "sb1")

(defun squealer/last-error ()
  (interactive)
  (squealer/insert "ORDER BY reportId DESC LIMIT 1"))

(defun squealer/by-report-id (id)
  (squealer/insert (format "WHERE reportId = %s" id)))

(defun squealer/insert (query-fragment)
  (let ((buf (get-buffer-create "*squealer*"))
        (inhibit-read-only t))
    (switch-to-buffer buf)
    (erase-buffer)
    (shell-command
     (format "mysql -u root -h %s squealer --pager=cat -r -s -e 'SELECT description, stack FROM reportFullText %s'"
             squealer/host query-fragment)
     buf
     buf)
    (compilation-mode)
    (make-local-variable 'compilation-error-regexp-alist)
    (add-to-list 'compilation-error-regexp-alist '("^#[0-9] \\[\\(/[^ ]*?\\):\\([0-9]+\\)\\]" 1 2))
    (add-to-list 'compilation-error-regexp-alist '("^#[0-9]+ \\(/[^ ]*?\\)(\\([0-9]+\\)):" 1 2))
    (add-to-list 'compilation-error-regexp-alist '("\\(/[^ ]*?\\):\\([0-9]+\\)$" 1 2))))


(define-minor-mode squealer-mode
  "Browse my squealer reports."
  :init-value nil
  :keymap squealer-mode-map
  :lighter "<squealer>"
  (read-only-mode 1))

(defvar squealer-mode-map
  (let ((m (make-sparse-keymap)))
    (define-key m [return] 'squealer/show-entry)
    m)
  "Keymap for `squealer-mode'.")


(defun squealer/list ()
  (interactive)
  (let ((buf (get-buffer-create "*squealer-list*"))
        (inhibit-read-only t))
    (switch-to-buffer buf)
    (erase-buffer)
    (shell-command
     (format "mysql -u root -h %s squealer -t -e 'select report.id, time, server.name, SUBSTRING(REPLACE(reportFullText.description, \"\n\", \"\"), 1, 150) as description from report join server on serverId = server.id join reportFullText on report.id = reportFullText.reportId order by report.id desc limit 100'"
             squealer/host)
     buf
     buf)
    (squealer-mode)))

(defun squealer/-parse-id ()
  (save-excursion
    (save-restriction
      (beginning-of-line)
      (if (re-search-forward "^|\s+\\(.*?\\)\s*|" nil t)
          (match-string 1)))))

(defun squealer/show-entry ()
  (interactive)
  (let ((id (squealer/-parse-id)))
    (if id
        (squealer/by-report-id id)
      (message "No report in this line"))))
