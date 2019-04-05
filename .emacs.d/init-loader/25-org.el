;; TODO investigate org-notmuch
;; (require 'org-notmuch) to deal with notmuch debian vs elpa issues

(defun org-archive-done-tasks ()
  "Archived all DONE tasks in buffer"
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "/DONE" 'file))

(defun juanleon/org-case-template ()
  "Create a TODO item from a case (in a cases buffer)"
  (format "* TODO Case %s %%? \n  %%U\n  %s\n"
          (juanleon/cases-case-number)
          (juanleon/cases-info)))

;; Used less and less, as I kind of prefer quoting tables to rendering them to
;; nice html
(defun juanleon/org-table-to-markdown (beg end)
  (interactive "r")
  (save-excursion
    (goto-char beg)
    (while (re-search-forward "--\|[^-]" end t)
      (replace-match "-:|\n" nil nil))
    (goto-char beg)
    (while (re-search-forward "--\\+--" end t)
      (replace-match "--|--" nil nil))))


(use-package org
  :ensure t
  :bind (([(control c) ?l] . org-store-link)
         ([(control c) ?a] . org-agenda)
         ([(control c) ?c] . org-capture)
         ([(control c) ?4] . org-archive-done-tasks)
         ([(control c) ?1] . juanleon/open-mail-at-point)
         ([(super o)]      . org-switchb))
  :config
  (use-package org-bullets :ensure t)
  (require 'ox-md nil t)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-agenda-files '("~/Dropbox/org/agenda")
        org-directory "~/Dropbox/org"
        org-src-fontify-natively t
        org-edit-src-content-indentation 0)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (js . t)
     (python . t)
     (emacs-lisp . t)))

  (setq org-html-postamble-format
        '(("en" "<p class=\"author\">Author: %a (%e)</p>
<p class=\"date\">Date: %d</p>
<p class=\"creator\">%c</p>")))

  (setq org-capture-templates
        '(("t" "Todo" entry (file "agenda/Inbox.org") "* TODO %? \n  %U\n")
          ("T" "Today" entry (file "agenda/agenda.org")
           "* TODO %?\n  SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"\"))")
          ("v" "Todo with link" entry (file "agenda/Inbox.org") "* TODO %?\n  %U\n  %i\n  %a\n")
          ("c" "Case" entry (file "agenda/Inbox.org") (function juanleon/org-case-template))
          ("j" "Journal" entry (file+datetree "info/journal.org") "* %<%R:>%?\n")
          ("g" "Good News" entry (file+datetree "info/goodnews.org") "* %<%R:>%?\n")
          ("k" "Trick " entry (file "info/tricks.org") "* %?\n")
          ("K" "Trick with code" entry (file "info/tricks.org") "* %? \n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
          ("s" "scheduled" entry (file "agenda/agenda.org")
           "* %?\n  SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+2d\"))")))

  (setq org-agenda-custom-commands
        '((" " "Inbox"
           ((tags "PRIORITY=\"A\"" ((org-agenda-overriding-header "High-prio:")))
            (tags "ongoing"
                  ((org-agenda-files '("~/Dropbox/org/agenda/projects.org"))
                   (org-agenda-overriding-header "Ongoing projects:")))
            (agenda "" ((org-agenda-span 14) (org-agenda-files '("~/Dropbox/org/agenda/agenda.org"))))
            (alltodo ""))
           ((org-agenda-files '("~/Dropbox/org/agenda/Inbox.org")))))))


(use-package org-radiobutton
  :ensure t
  :config
  (global-org-radiobutton-mode 1))


(use-package orgtbl-aggregate
  :ensure t)
