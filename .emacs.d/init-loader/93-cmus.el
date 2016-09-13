


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
  (if (/= 0 (shell-command (concat "cmus-remote " command)))
      (message "cmus error")))

;;  :bind ([(control ?))] . hydra-cmus/body)
;;  :config


(defhydra hydra-cmus (:color pink :hint nil)
  ("+" cmus-increase-vol "+vol")
  ("-" cmus-decrease-vol "-vol")
  ("p" cmus-pause "pause" :color blue)
  ("n" cmus-next "next" :color blue)
  ("r" cmus-replay "replay" :color blue))

(global-set-key [(control f9)] 'hydra-cmus/body)

