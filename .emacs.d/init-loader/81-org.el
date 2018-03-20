
(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "/DONE" 'file))

(use-package org
  :ensure t
  :bind (([(control c) ?l] . org-store-link)
         ([(control c) ?a] . org-agenda)
         ([(control c) ?c] . org-capture)
         ([(control c) ?4] . org-archive-done-tasks)
         ([(control c) ?1] . juanleon/open-mail-at-point)
         ([(super o)]      . org-iswitchb))
  :config
  (use-package org-bullets :ensure t)
  (require 'ox-md nil t)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-agenda-files '("~/Dropbox/org/agenda"))
  (setq org-directory "~/Dropbox/org")
  (setq org-src-fontify-natively t)
  (setq org-completion-use-ido t)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (emacs-lisp . t)))

  (setq org-capture-templates
        '(("t" "Today" entry (file+headline "agenda/Inbox.org" "Today") "* TODO %? \n  %U\n")
          ("m" "Mail" entry (file+headline "agenda/Inbox.org" "Today") "* TODO %? \n  %U\n%x")
          ("T" "Tomorrow" entry (file+headline "agenda/Inbox.org" "Tomorrow") "* TODO %? \n  %U\n")
          ("v" "Today with link" entry (file+headline "agenda/Inbox.org" "Today") "* TODO %?\n  %U\n  %i\n  %a\n")
          ("j" "Journal" entry (file+datetree "info/journal.org") "* %<%R:>%?\n")
          ("g" "Good News" entry (file+datetree "info/goodnews.org") "* %<%R:>%?\n")
          ("k" "Trick " entry (file "info/tricks.org") "* %?\n")
          ("K" "Trick with code" entry (file "info/tricks.org") "* %? \n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
          ;; https://addons.mozilla.org/en-US/firefox/addon/org-mode-capture/ (C-M-r)
          ("x" "firefox" entry (file+headline "agenda/Inbox.org" "Today") "* TODO Review %c\n%U\n%i\n" :immediate-finish)
          ("s" "scheduled" entry (file+headline "agenda/Inbox.org" "Scheduled")
           "* %?\n  SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+2d\"))")
          ("S" "scheduled mail" entry (file+headline "agenda/Inbox.org" "Scheduled")
           "* %?\n  SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+2d\"))\n%x")))

  (setq org-agenda-custom-commands
        '((" " "Inbox"
           ((tags "PRIORITY=\"A\"" ((org-agenda-overriding-header "High-prio:")))
            (agenda "" ((org-agenda-span 14)))
            (alltodo ""))
           ((org-agenda-files '("~/Dropbox/org/agenda/Inbox.org")))))))


(defun juanleon/org-table-to-markdown (beg end)
  (interactive "r")
  (save-excursion
    (goto-char beg)
    (while (re-search-forward "--\|[^-]" end t)
      (replace-match "-:|\n" nil nil))
    (goto-char beg)
    (while (re-search-forward "--\\+--" end t)
      (replace-match "--|--" nil nil))))
