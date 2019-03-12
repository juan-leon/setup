(defvar teg-lists
  '("juanleon"
    "reviews"
    "platform"
    "tests"
    "ft"
    "javier"
    "ruben"
    "carlos"
    "javier2"
    "david"
    "javier3"
    "mariajose"
    "juan"
    "sergey"
    "quimey"
    "julio"
    "devops-goals"
    "platform-goals"
    "tests-goals"
    "auto"
    "mariano"
    "cristian"
    "daniel"
    "victorp"
    ))

(defvar teg-templates '("platform" "tests"))


(defun juanleon/cases (list-name &optional no-cache sort-by)
  (interactive (let ((ivy-sort-functions-alist nil))
                 (list (completing-read "List name: " teg-lists nil t))))
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
    (define-key m [?n]     'juanleon/cases-copy-number)
    (define-key m [?N]     'juanleon/cases-add-note)
    (define-key m [?g]     'juanleon/cases-refresh)
    (define-key m [?i]     'juanleon/cases-summary)
    (define-key m [?I]     'juanleon/cases-sort-by-id)
    (define-key m [?S]     'juanleon/cases-sort-by-step)
    (define-key m [?P]     'juanleon/cases-sort-by-prio)
    (define-key m [?R]     'juanleon/review-at-point)
    (define-key m [?a]     'juanleon/cases-add-new)
    (define-key m [?o]     'juanleon/cases)
    (define-key m [?f]     'juanleon/cr-form)
    (define-key m [?m]     'juanleon/magit-at-point)
    (define-key m [?M]     'juanleon/magit-at-point-no-fetch)
    (define-key m [?,]     'juanleon/magit-at-point-with-co)
    (define-key m [?t]     'juanleon/teg)
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
    (beginning-of-line)
    (if (re-search-forward "|.*?|\s*\\([0-9]+\\)\s*|" nil t)
        (concat "https://teg.avature.net/#Case/" (match-string 1)))))

(defun juanleon/cases-case-number ()
  (save-excursion
    (beginning-of-line)
    (if (re-search-forward "|.*?|\s*\\([0-9]+\\)\s*|" nil t)
        (match-string 1))))

(defun juanleon/cases-case-title ()
  (save-excursion
    (beginning-of-line)
    (if (re-search-forward "^|\s+\\(.*?\\)\s*|" nil t)
        (match-string 1))))

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

(defun juanleon/cases-info ()
  (let ((url (juanleon/cases-case-url))
        (title (juanleon/cases-case-title)))
    (if url
        (concat url ": " title)
      "No case in this line")))

(defun juanleon/cases-copy-number ()
  (interactive)
  (let ((number (juanleon/cases-case-number)))
    (if number
        (kill-new number)
      (message "No case in this line"))))

(defun juanleon/cases-add-note ()
  (interactive)
  (let ((number (juanleon/cases-case-number)))
    (if number
        (juanleon/teg-add-note number)
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

(defun juanleon/teg(template-name)
  (interactive (list (completing-read "List name: " teg-templates)))
  (shell-command (concat "juanleon-teg " template-name)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Doing Code Reviews using case list & magit

(defun juanleon/review-at-point ()
  (interactive)
  (let ((case (save-excursion
                (beginning-of-line)
                (if (re-search-forward "|.*?|\s*\\([0-9]+\\)\s*|" nil t) (match-string 1))))
        (project (save-excursion
                (end-of-line)
                (if (re-search-backward "\s+\\([-a-zA-Z0-9]+\\)\s+" nil t) (match-string 1)))))
    (if (or (not project) (equal project "review"))
        (error "No project"))
    (if (not case)
        (error "No case"))
    (let ((dir (if (equal project "iats") "iats/code" project)))
          (kill-new (format "cd /home/juanleon/www/%s && juanleon-review %s" dir case)))))

(defun juanleon/magit-at-point (&optional no-fetch checkout)
  (interactive)
  (let ((branch (save-excursion
                (beginning-of-line)
                (if (re-search-forward "\\(T[[:digit:]]+[[:alpha:]][[:alnum:]]*\\)" nil t) (match-string 1))))
        (project (save-excursion
                (end-of-line)
                (if (re-search-backward "\s+\\([-a-zA-Z0-9]+\\)\s+" nil t) (match-string 1)))))
    (if (not branch)
        (error "No branch"))
    (if (or (not project) (equal project "review"))
        (error "No project"))
    (juanleon/code-review project branch no-fetch checkout)))

(defun juanleon/magit-at-point-no-fetch ()
  (interactive)
  (juanleon/magit-at-point t))

(defun juanleon/magit-at-point-with-co ()
  (interactive)
  (juanleon/magit-at-point nil t))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Adding notes in TEG

(defvar juanleon/teg-add-note-mode-map
  (let ((m (make-sparse-keymap)))
    (define-key m "\C-c\C-c" 'juanleon/teg-add-note-finalize)
    (define-key m "\C-c\C-k" 'juanleon/teg-add-note-kill)
    m)
  "Keymap for `juanleon/reg-add-note-mode'.")

(define-minor-mode juanleon/teg-add-note-mode
  "Blah blah"
  nil " Whut" juanleon/teg-add-note-mode-map)

(defun juanleon/teg-add-note (case)
  (interactive "nCase: ")
  (let ((buf (get-buffer-create (format "*note-%s*" case))))
    (switch-to-buffer buf)
    (make-local-variable 'case-number)
    (setq case-number case)
    (erase-buffer)
    (juanleon/teg-add-note-mode)))

(defun juanleon/teg-add-note-finalize ()
  (interactive)
  (shell-command-on-region
   (point-min) (point-max) (format "juanleon-add-note %s" case-number))
  (bury-buffer))

(defun juanleon/teg-add-note-kill ()
  (interactive)
  (kill-buffer))

(defun juanleon/teg-add-note-from-region(case)
  (interactive "nCase: ")
  (shell-command-on-region
   (region-beginning) (region-end) (format "juanleon-add-note %d" case)))

(defun juanleon/cr-form (&optional arg)
  (interactive "P")
  (let ((number (juanleon/cases-case-number))
        (fetch (if arg "--fetch" "")))
    (if number
        (shell-command (format "juanleon-form-cr %s %s" fetch number))
    (message "No case in this line"))))

(require 'stripes)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Commenting in gitlab when doing CRs

(defvar juanleon/gitlab-add-note-mode-map
  (let ((m (make-sparse-keymap)))
    (define-key m "\C-c\C-c" 'juanleon/gitlab-add-note-finalize)
    (define-key m "\C-c\C-k" 'juanleon/gitlab-add-note-kill)
    m)
  "Keymap for `juanleon/gitlab-add-note-mode'.")

(define-minor-mode juanleon/gitlab-add-note-mode
  "Blah blah blah"
  nil " Whut whu" juanleon/gitlab-add-note-mode-map)

(defun juanleon/gitlab-add-note ()
  (interactive)
  (and (get-buffer "*gitlab-note*") (kill-buffer "*gitlab-note*"))
  (let ((buf (get-buffer-create "*gitlab-note*"))
        (source-dir default-directory)
        (source-line (line-number-at-pos))
        (source-buffer (buffer-name))
        (source-file-name (or buffer-file-name "nil")))
    (switch-to-buffer buf)
    (markdown-mode)
    (set (make-local-variable 'local-source-dir) source-dir)
    (set (make-local-variable 'local-source-line) source-line)
    (set (make-local-variable 'local-source-buffer) source-buffer)
    (set (make-local-variable 'local-source-file-name) source-file-name)
    (erase-buffer)
    (juanleon/gitlab-add-note-mode)))

(defun juanleon/gitlab-add-note-finalize ()
  (interactive)
  (if (eq (shell-command-on-region
           (point-min) (point-max)
           (format "juanleon-comment-in-gitlab '%s' '%s' '%s' '%s'"
                   local-source-dir
                   local-source-buffer
                   local-source-file-name
                   local-source-line)) 0)
      (kill-buffer)))

(defun juanleon/gitlab-add-note-kill ()
  (interactive)
  (kill-buffer))

(global-set-key [(super G)] 'juanleon/gitlab-add-note)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Creating new cases

(defvar juanleon/cases-add-case-mode-map
  (let ((m (make-sparse-keymap)))
    (define-key m "\C-c\C-c" 'juanleon/cases-add-case-finalize)
    (define-key m "\C-c\C-k" 'juanleon/cases-add-case-kill)
    m)
  "Keymap for `juanleon/cases-add-case-mode'.")

(define-minor-mode juanleon/cases-add-case-mode
  "Blah blah blah"
  nil " Whut whu" juanleon/cases-add-case-mode-map)

(defun juanleon/cases-add-new ()
  (interactive)
  (find-file (make-temp-file "new-case" nil ".toml"))
  (yas-minor-mode 1)
  (yas-expand-snippet (yas-lookup-snippet "case"))
  (juanleon/cases-add-case-mode))

(defun juanleon/cases-add-case-finalize ()
  (interactive)
  (save-buffer)
  (if (eq (shell-command-on-region (point-min) (point-max) "juanleon-add-case") 0)
      (kill-buffer)))

(defun juanleon/cases-add-case-kill ()
  (interactive)
  (kill-buffer))
