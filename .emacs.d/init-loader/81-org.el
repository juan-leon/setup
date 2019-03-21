
(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "/DONE" 'file))

(defun juanleon/org-case-template ()
  "* TODO AA BB %? \n  %U\n"
  (format "* TODO Case %s %%? \n  %%U\n  %s\n" (juanleon/cases-case-number) (juanleon/cases-info)))


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
  (setq org-agenda-files '("~/Dropbox/org/agenda"))
  (setq org-directory "~/Dropbox/org")
  (setq org-src-fontify-natively t)
  (setq org-edit-src-content-indentation 0)

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
          ("m" "Mail" entry (file "agenda/Inbox.org") "* TODO %? \n  %U\n%x")
          ("T" "Tomorrow" entry (file+headline "agenda/Inbox.org" "Tomorrow") "* TODO %? \n  %U\n")
          ("v" "Todo with link" entry (file "agenda/Inbox.org") "* TODO %?\n  %U\n  %i\n  %a\n")
          ("c" "Case" entry (file "agenda/Inbox.org") (function juanleon/org-case-template))
          ("j" "Journal" entry (file+datetree "info/journal.org") "* %<%R:>%?\n")
          ("g" "Good News" entry (file+datetree "info/goodnews.org") "* %<%R:>%?\n")
          ("k" "Trick " entry (file "info/tricks.org") "* %?\n")
          ("K" "Trick with code" entry (file "info/tricks.org") "* %? \n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
          ;; https://addons.mozilla.org/en-US/firefox/addon/org-mode-capture/ (C-M-r)
          ("x" "firefox" entry (file "agenda/Inbox.org") "* TODO Review %c\n%U\n%i\n" :immediate-finish t)
          ("s" "scheduled" entry (file "agenda/agenda.org")
           "* %?\n  SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+2d\"))")
          ("S" "scheduled mail" entry (file "agenda/agenda.org")
           "* %?\n  SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+2d\"))\n%x")))

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

(defun juanleon/org-table-to-markdown (beg end)
  (interactive "r")
  (save-excursion
    (goto-char beg)
    (while (re-search-forward "--\|[^-]" end t)
      (replace-match "-:|\n" nil nil))
    (goto-char beg)
    (while (re-search-forward "--\\+--" end t)
      (replace-match "--|--" nil nil))))

;; fixme (require 'org-notmuch)
