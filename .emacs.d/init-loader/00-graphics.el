(when (display-graphic-p)
  (if (eq system-type 'darwin)
      (set-face-attribute 'default nil :height 110)
    (set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 98))
  (modify-all-frames-parameters '((fullscreen . maximized)))
  (setq frame-title-format '(:eval (if (buffer-file-name)
                                       (abbreviate-file-name (buffer-file-name))
                                     "%b")))
  (setq save-interprogram-paste-before-kill t)
  (setq select-enable-clipboard t
        select-enable-primary   t)
  (defadvice gui-set-selection (after replicate-selection (type data) activate)
    "Different applications use different data sources"
    (if (equal type 'CLIPBOARD)
        (gui-set-selection 'PRIMARY data)))

  (defadvice kmacro-end-or-call-macro (around do-not-use-x (arg) activate)
    "Do noy use system clipboard while executing a macro"
    (let ((select-enable-clipboard nil)
          (select-enable-primary nil))
      ad-do-it)))

;; Disable niceties
(mapc (lambda (mode) (funcall mode 0))
      '(tool-bar-mode menu-bar-mode scroll-bar-mode blink-cursor-mode
        transient-mark-mode horizontal-scroll-bar-mode))

;; Enable niceties
(mapc (lambda (mode) (funcall mode 1))
      '(column-number-mode auto-image-file-mode show-paren-mode size-indication-mode))

(use-package color-theme-sanityinc-solarized :ensure t)
(use-package color-theme
  :ensure t
  :demand
  :config
  (defvar juanleon-light-theme 'sanityinc-solarized-light)
  (defvar juanleon-dark-theme  'sanityinc-solarized-dark)
  (load-theme juanleon-light-theme t)
  (run-with-idle-timer 3 nil (lambda ()
                               (load-theme juanleon-dark-theme t t)))
  (defun juanleon/toggle-theme ()
    "Toggle dark/light theme"
    (interactive)
    (let* ((b-color (frame-parameter nil 'background-color))
           (d-light (color-distance "white" b-color))
           (d-dark  (color-distance "black" b-color)))
      (if (> d-light d-dark)
          (enable-theme juanleon-light-theme)
        (enable-theme juanleon-dark-theme))))
  (global-set-key [(control ~)] 'juanleon/toggle-theme))
