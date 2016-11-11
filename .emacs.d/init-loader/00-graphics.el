(eval-when-compile
  (add-to-list 'byte-compile-not-obsolete-vars 'x-select-enable-primary)
  (add-to-list 'byte-compile-not-obsolete-vars 'x-select-enable-clipboard))

(when (display-graphic-p)
  (if (eq system-type 'darwin)
      (set-face-attribute 'default nil :height 110)
    (set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 98))
  (modify-all-frames-parameters '((fullscreen . maximized)))
  (setq frame-title-format '(:eval (if (buffer-file-name)
                                       (abbreviate-file-name (buffer-file-name))
                                     "%b")))
  (setq save-interprogram-paste-before-kill t)
  (if (< emacs-major-version 25)
      (progn
        (setq x-select-enable-primary   t
              x-select-enable-clipboard t)
        (defadvice x-set-selection (after replicate-selection (type data) activate)
          "Different applications use different data sources"
          (if (equal type 'CLIPBOARD)
              (x-set-selection 'PRIMARY data))))
    (progn
        (setq select-enable-clipboard t
              select-enable-primary   t)
        (defadvice gui-set-selection (after replicate-selection (type data) activate)
          "Different applications use different data sources"
          (if (equal type 'CLIPBOARD)
              (gui-set-selection 'PRIMARY data)))))

  (defadvice kmacro-end-or-call-macro (around do-not-use-x (arg) activate)
    "Do noy use system clipboard while executing a macro"
    (let ((x-select-enable-clipboard nil)
          (x-select-enable-primary nil)
          (select-enable-clipboard nil)
          (select-enable-primary nil))
      ad-do-it)))


(tool-bar-mode       0)
(menu-bar-mode       0)
(scroll-bar-mode     0)
(blink-cursor-mode   0)
(transient-mark-mode 0)
(if (fboundp 'horizontal-scroll-bar-mode) (horizontal-scroll-bar-mode 0))

(use-package color-theme-sanityinc-solarized :ensure t)
(use-package color-theme
  :ensure t
  :demand
  :config
  (defvar leon-light-theme 'sanityinc-solarized-light)
  (defvar leon-dark-theme  'sanityinc-solarized-dark)
  (load-theme leon-light-theme t)
  (run-with-idle-timer 3 nil (lambda ()
                               (load-theme leon-dark-theme t t)))
  (defun juanleon/toggle-theme ()
    "Toggle dark/light theme"
    (interactive)
    (let* ((b-color (frame-parameter nil 'background-color))
           (d-light (color-distance "white" b-color))
           (d-dark  (color-distance "black" b-color)))
      (if (> d-light d-dark)
          (enable-theme leon-light-theme)
        (enable-theme leon-dark-theme))))
  (global-set-key [(control ~)] 'juanleon/toggle-theme))
