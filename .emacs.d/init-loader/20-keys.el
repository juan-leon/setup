;; For shorter keybindings
(defmacro command (&rest body)
  `(lambda ()
     (interactive)
     ,@body))

(global-set-key [(f2)] nil)  ;; I am not a 2C user

(when (eq system-type 'darwin)
  (global-set-key [(home)] 'move-beginning-of-line)
  (global-set-key [(end)] 'end-of-line)
  (global-set-key [(shift hyper help)] 'yank))
