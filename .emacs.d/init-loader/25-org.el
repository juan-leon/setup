;; TODO investigate org-notmuch
;; (require 'org-notmuch) to deal with notmuch debian vs elpa issues

(defun juanleon/org-archive-done-tasks ()
  "Archived all DONE tasks in buffer"
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "/DONE" 'file))

(defun juanleon/org-done-and-archive ()
  "Flag an agenda item as sone and archive it"
  (interactive)
  (org-agenda-todo "DONE")
  (org-agenda-archive)
  (org-save-all-org-buffers))

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
         ([(control c) ?4] . juanleon/org-archive-done-tasks)
         ([(super o)]      . org-switchb)
         :map org-agenda-mode-map
         ([(super t)]      . juanleon/org-done-and-archive))
  :config
  (use-package org-bullets :ensure t)
  (require 'ox-md nil t)
  (require 'org-tempo)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-agenda-files '("~/Dropbox/org/agenda")
        org-directory "~/Dropbox/org"
        org-src-fontify-natively t
        org-edit-src-content-indentation 0
        org-support-shift-select t
        org-deadline-warning-days 1
        org-clock-history-length 20
        org-priority-lowest ?D)

  (setq org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-targets '(("~/Dropbox/org/agenda/agenda.org" :maxlevel . 1)
                             ("~/Dropbox/org/agenda/Inbox.org" :maxlevel . 1)))

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
          ("g" "Good News" entry (file+datetree "info/goodnews.org") "* %<%R:> %?\n")
          ("M" "Speed typing" entry (file+datetree "info/typing.org") "* %<%R:> %?\n")
          ("l" "Today I learned" entry (file+datetree "info/til.org") "* %<%R:> %?")
          ("k" "Trick " entry (file "info/tricks.org") "* %?\n")
          ("K" "Trick with code" entry (file "info/tricks.org") "* %? \n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
          ("f" "Follow up" entry (file "agenda/agenda.org")
           "* TODO Follow up %?\n  SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+3d\"))")
          ("s" "scheduled" entry (file "agenda/agenda.org")
           "* TODO %?\n  SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+2d\"))")))

  (setq org-agenda-custom-commands
        '(("x" "Inbox"
           ((tags "PRIORITY=\"A\"" ((org-agenda-overriding-header "Today:")))
            (tags "PRIORITY=\"B\"" ((org-agenda-overriding-header "Progress this week:")))
            (agenda "" ((org-agenda-span 14) (org-agenda-files '("~/Dropbox/org/agenda/agenda.org"))))
            (tags "PRIORITY=\"C\"" ((org-agenda-overriding-header "Reviewed this weekly:")))
            (tags "PRIORITY=\"D\"" ((org-agenda-overriding-header "To be classified:"))))
           ((org-agenda-files '("~/Dropbox/org/agenda/Inbox.org"))))
          ("p" "Projects"
           ((todo "TODO"
                       ((org-agenda-overriding-header "Ongoing projects:"))))
           ((org-agenda-files '("~/Dropbox/org/agenda/Projects.org")))))))


(use-package org-radiobutton
  :ensure t
  :config
  (global-org-radiobutton-mode 1))


(use-package orgtbl-aggregate
  :ensure t)

(use-package org-journal
  :ensure t
  :defer t
  :bind (([(control j)] . org-journal-new-entry)
         :map org-mode-map
         ([(control j)] . org-journal-new-entry))
  :custom
  (org-journal-dir "/home/plain/Dropbox/org/journal/")
  (org-journal-date-format "%A, %d/%m/%y"))


(use-package stripe-buffer
  :ensure t
  :commands turn-on-stripe-table-mode
  :custom-face (stripe-highlight ((t (:background "#e4e4d4")))))
