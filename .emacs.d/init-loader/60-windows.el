(use-package winner
  :config
  (winner-mode 1)
  (define-key winner-mode-map [(super prior)] 'winner-undo)
  (define-key winner-mode-map [(super next)]  'winner-redo))


(use-package rotate
  :ensure t
  :bind (([(super home)] . rotate-layout)
         ([(super end)]  . rotate-window)))


(use-package windmove
  :bind (([(control next)]     . windmove-down)
         ([(control prior)]    . windmove-up)
         ([(control kp-6)]     . windmove-right)
         ([(control kp-4)]     . windmove-left)
         ([(control kp-right)] . windmove-right)
         ([(control kp-left)]  . windmove-left))
  :config
  (setq windmove-create-window t)
  (windmove-display-default-keybindings) ; S-M-arrow command: create/show
  (windmove-delete-default-keybindings))  ; C-x S-arrow: delete


(use-package buffer-move
  :ensure t
  :bind (([(control shift super up)]    . buf-move-up)
         ([(control shift super down)]  . buf-move-down)
         ([(control shift super left)]  . buf-move-left)
         ([(control shift super right)] . buf-move-right)))


(use-package switch-window
  :ensure t
  :commands switch-window
  :bind (([(control tab)] . juanleon/switch-buffer-or-window)
         ([(control insert)] . juanleon/switch-buffer-or-window)
         ([(control shift tab)] . switch-window-then-swap-buffer)
         ([(control iso-lefttab)] . switch-window-then-swap-buffer))
  :preface
  (defun juanleon/switch-buffer-or-window ()
    (interactive)
    (if (one-window-p)
        (ivy-switch-buffer)
      (switch-window)))
  :config (setq switch-window-shortcut-style 'qwerty))


(use-package window
  :bind (([(pause)] . delete-other-windows))
  :init
  (setq split-height-threshold 140
        recenter-positions '(top middle bottom)))


;; Cleaner modeline
(use-package minions
  :ensure t
  :config
  (minions-mode 1)
  (setq minions-mode-line-lighter "@"))


(defun juanleon/toggle-split ()
  "Toggle vertical/horizontal window split."
  (interactive)
  (let ((buff-b (window-buffer (next-window)))
        (height (window-body-height))
        (width  (window-body-width)))
    (delete-other-windows)
    (if (> height (/ width 5))
        (split-window-vertically)
      (split-window-horizontally))
    (set-window-buffer (next-window) buff-b)))


(defun juanleon/toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message "Window '%s' is %s" (current-buffer)
           (if (let (window (get-buffer-window (current-buffer)))
                 (set-window-dedicated-p window
                                         (not (window-dedicated-p window))))
               "dedicated" "normal")))

(global-set-key [(super pause)]  'juanleon/toggle-split)
(global-set-key [(control kp-1)] 'juanleon/toggle-window-dedicated)
