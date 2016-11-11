


(defun cmus-increase-vol ()
  (interactive)
  (cmus-commmand "-v +10%"))

(defun cmus-decrease-vol ()
  (interactive)
  (cmus-commmand "-v -10%"))

(defun cmus-pause ()
  (interactive)
  (cmus-commmand "-u"))

(defun cmus-next ()
  (interactive)
  (cmus-commmand "-n"))

(defun cmus-replay ()
  (interactive)
  (cmus-commmand "-r"))

(defun cmus-commmand (command)
  (if (/= 0 (shell-command (concat "cmus-remote " command) nil "*cmus-error*"))
      (message "cmus error")))


