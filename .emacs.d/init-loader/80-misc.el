(use-package ispell
  :defer t
  :config
  (defvar juanleon/main-dictionary      "english")
  (defvar juanleon/secondary-dictionary "castellano8")
  (setq ispell-dictionary     juanleon/main-dictionary
        ispell-silently-savep t)
  (global-set-key [(super ?9)]
                  (lambda ()
                    (interactive)
                    (if (not (equal ispell-local-dictionary juanleon/secondary-dictionary))
                        (ispell-change-dictionary juanleon/secondary-dictionary)
                      (ispell-change-dictionary juanleon/main-dictionary)))))


(use-package yasnippet
  :ensure t
  :bind (:map yas-minor-mode-map ([(super ?`)] . yas-expand))
  :init
  (yas-global-mode)
  :config
  ;; Tab is for completion/indent
  (define-key yas-minor-mode-map [(tab)] nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil))


(use-package auto-yasnippet
  :bind (([(control ?o)] . aya-open-line)
         ([(super f11)] . aya-create)
         ([(super f12)] . aya-expand))
  :ensure t)


(use-package define-word
  :ensure t
  :commands define-word define-word-at-point)


(use-package ediff
  :defer t
  :init
  :config
  (setq-default ediff-ignore-similar-regions t)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain
        ediff-split-window-function 'split-window-horizontally
        ediff-diff-options          " -bB "))


(use-package man
  :bind (([(super m)] . man))
  :config (setq Man-notify-method 'pushy))


(defun juanleon/tmux-window-here ()
  "Open a new window on first session on current directory"
  (interactive)
  (if default-directory
      (shell-command
       (format "TMPDIR=/tmp/user/%d tmux new-window -c %s"
               (user-uid) default-directory))
    (error "This buffer has no directory")))

(global-set-key [(super t)] 'juanleon/tmux-window-here)


(use-package jit-lock
  :defer t
  :config
  (setq jit-lock-stealth-time 5
        jit-lock-stealth-nice 0.25))


(use-package executable
  :defer t
  :init
  (add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p))

(defun spotify-commmand (command)
  (if (/= 0 (shell-command (concat "juanleon-spotify " command) nil "*spotify-error*"))
      (message "spotify error")))


(global-set-key [(XF86AudioPlay)] (lambda () (interactive) (spotify-commmand "PlayPause")))
(global-set-key [(XF86AudioPrev)] (lambda () (interactive) (spotify-commmand "prev")))
(global-set-key [(XF86AudioNext)] (lambda () (interactive) (spotify-commmand "next")))
