(use-package ibuffer
  :bind ([remap list-buffers] . ibuffer)
  :custom
  (ibuffer-formats '((mark modified read-only
                           " " (name 42 42)
                           " " (size 9 9 :right)
                           " " (mode 21 21 :left :elide)
                           " " filename-and-process)
                     (mark " " (name 30 -1) " " filename))))


(use-package uniquify
  :custom (uniquify-buffer-name-style 'post-forward-angle-brackets))


;; Fast switching buffers in same window
(use-package buffer-stack
  :ensure t
  :bind (([(meta kp-4)]     . buffer-stack-up)
         ([(meta kp-left)]  . buffer-stack-up)
         ([(meta kp-6)]     . buffer-stack-down)
         ([(meta kp-right)] . buffer-stack-down)
         ([(meta kp-2)]     . buffer-stack-bury)
         ([(meta kp-down)]  . buffer-stack-bury)
         ([(meta kp-8)]     . buffer-stack-untrack)
         ([(meta kp-up)]    . buffer-stack-untrack))
  :config
  (add-to-list 'buffer-stack-untracked "*Backtrace*")
  (defvar buffer-stack-mode)
  (defun buffer-op-by-mode (op &optional mode)
    (let ((buffer-stack-filter 'buffer-stack-filter-by-mode)
          (buffer-stack-mode (or mode major-mode)))
      (funcall op)))
  (defun buffer-stack-filter-by-mode (buffer)
    (with-current-buffer buffer
      (equal major-mode buffer-stack-mode)))
  (global-set-key [(meta kp-7)] (command (buffer-op-by-mode 'buffer-stack-up)))
  (global-set-key [(meta kp-9)] (command (buffer-op-by-mode 'buffer-stack-down)))
  (global-set-key [(meta kp-3)] (command (buffer-op-by-mode 'buffer-stack-down 'dired-mode)))
  (global-set-key [(meta kp-1)] (command (buffer-op-by-mode 'buffer-stack-up 'dired-mode))))


(use-package midnight
  :defer 30
  :init
  (setq clean-buffer-list-delay-general 3)
  (midnight-delay-set 'midnight-delay "7:10pm"))
