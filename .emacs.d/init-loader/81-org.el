
(use-package org
  :ensure t
  :bind (([(control c) ?l] . org-store-link)
         ([(control c) ?a] . org-agenda)
         ([(control c) ?c] . org-capture)
         ([(control c) ?4] . org-archive-done-tasks)
         ([(super o)]      . org-iswitchb))
  :config
  (use-package org-bullets :ensure t)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-agenda-files '("~/Dropbox/org/agenda"))
  (setq org-directory "~/Dropbox/org")
  (setq org-src-fontify-natively t)
  (setq org-completion-use-ido t)
  (setq org-capture-templates
        '(("t" "Today" entry (file+headline "agenda/Inbox.org" "Today") "* TODO %? \n  %U\n")
          ("T" "Tomorrow" entry (file+headline "agenda/Inbox.org" "Tomorrow") "* TODO %? \n  %U\n")
          ("v" "Today with link" entry (file+headline "agenda/Inbox.org" "Today") "* TODO %?\n  %U\n  %i\n  %a\n")
          ("j" "Journal" entry (file+datetree "info/journal.org") "* %<%R:>%?\n")
          ("g" "Good News" entry (file+datetree "info/goodnews.org") "* %<%R:>%?\n")
          ("r" "Trick " entry (file "info/tricks.org") "* %?\n")
          ("R" "Trick with code" entry (file "info/tricks.org") "* %? \n#+BEGIN_SRC %^{language}\n\n#+END_SRC"))))

(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "/DONE" 'file))
