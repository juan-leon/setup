
(defun juanleon/rchat (user)
  "Send the active region as rocket chat message to USER."
  (interactive (let ((ivy-sort-functions-alist nil))
                 (list (completing-read "Alias name: " rchat-alias))))
  (if (region-active-p)
      (shell-command-on-region (region-beginning) (region-end)
                               (format "rchat send --to %s" user))
    (error "Region must be active")))
