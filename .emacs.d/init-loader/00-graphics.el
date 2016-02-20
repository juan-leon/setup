(when (display-graphic-p)
  (set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 98)
  (modify-all-frames-parameters '((fullscreen . maximized)))
  (setq frame-title-format '(:eval (if (buffer-file-name)
                                       (abbreviate-file-name (buffer-file-name))
                                     "%b")))
  (setq x-select-enable-primary   t
        x-select-enable-clipboard t)

  (defadvice x-set-selection (after replicate-selection (type data) activate)
    "Different applications use different data sources"
    (if (equal type 'CLIPBOARD)
        (x-set-selection 'PRIMARY data))))

(tool-bar-mode       0)
(menu-bar-mode       0)
(scroll-bar-mode     0)
(blink-cursor-mode   0)
(transient-mark-mode 0)

(defvar leon-light-theme 'sanityinc-solarized-light)
(defvar leon-dark-theme  'sanityinc-solarized-dark)

(load-theme leon-light-theme t)
(run-with-idle-timer 3 nil (lambda ()
                             (load-theme leon-dark-theme t t)))
