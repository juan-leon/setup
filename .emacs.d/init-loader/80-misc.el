



(use-package avy
  :ensure t
  :bind (([(super ?j)] . avy-goto-word-1)
         ([(super ?k)] . avy-goto-char-timer)
         ([(super ?l)] . avy-goto-line))
  :init
  (setq avy-keys '(up down left right)
        avy-lead-faces '(avy-lead-face
                         avy-lead-face-0
                         avy-lead-face
                         avy-lead-face-0
                         avy-lead-face
                         avy-lead-face-0)))


(use-package hydra
  :ensure t
  :commands defhydra
  :bind (([(control ?=)]  . hydra-diff/body)
         ([(control f7)]  . hydra-next-error/body)
         ([(control f10)] . hydra-toggle/body)
         ([(control f3)]  . hydra-zoom/body))

  :config
  (defhydra hydra-zoom nil
    "Change text size"
    ("+" text-scale-increase "in")
    ("-" text-scale-decrease "out"))

  (defhydra hydra-diff nil
    "Show diffs"
    ("b" ediff-buffers "buffers" :color blue)
    ("f" ediff-files "files" :color blue)
    ("d" diff "diff" :color blue)
    ("w" compare-windows "windows" :color blue)
    ("v" vc-diff "versioned" :color blue))

  (defhydra hydra-next-error ()
    "Error Selection"
    ("j" next-error "next" :bind nil)
    ("n" next-error "next" :bind nil)
    ("k" previous-error "previous" :bind nil)
    ("p" previous-error "previous" :bind nil)
    ("l" juanleon/goto-compilation-buffer "compile errors" :exit t)
    ("f" flycheck-list-errors "flycheck errors" :exit t)
    ("q" nil "quit" :exit t))

  (defhydra hydra-toggle nil
    "Toggle stuff"
    ("d" toggle-debug-on-error "debug-on-error" :exit t)
    ("D" toggle-debug-on-quit "debug-on-quit" :exit t)
    ("F" auto-fill-mode "Auto-fill" :exit t)
    ("l" toggle-truncate-lines "Truncate lines" :exit t)
    ("r" read-only-mode "Read-only" :exit t)
    ("s" flyspell-mode "FlySpell" :exit t)
    ("S" flyspell-prog-mode "FlySpell prog" :exit t)
    ("h" hl-line-mode "Highlight lines" :exit t)
    ("n" display-line-numbers-mode "Line numbers" :exit t)
    ("w" whitespace-mode "whitespace" :exit t)
    ("q" nil :exit t)))




(use-package toml-mode
  :ensure t
  :mode ("\\.toml\\'" . toml-mode))



(use-package calendar
  :bind ([(control f4)] . calendar)
  :init
  (setq calendar-week-start-day     1
        calendar-mark-holidays-flag t
        calendar-holidays (append
                           ;; Fixed
                           '((holiday-fixed 1 1 "New Year's Day")
                             (holiday-fixed 1 6 "Reyes")
                             (holiday-easter-etc -2 "Jueves Santo")
                             (holiday-easter-etc -3 "Viernes Santo")
                             (holiday-fixed 5 1   "Dia del Trabajador")
                             (holiday-fixed 5 2   "Comunidad del Madrid")
                             (holiday-fixed 10 12 "National Day")
                             (holiday-fixed 12 6  "Constitution")
                             (holiday-fixed 12 25 "Christmas"))
                           ;; This year
                           '((holiday-fixed 3 20  "S. Jose")
                             (holiday-fixed 5 15  "Whatever")
                             (holiday-fixed 8 15  "Asuncion")
                             (holiday-fixed 11 1  "All Saints")
                             (holiday-fixed 11 9  "Almudena")
                             (holiday-fixed 12 8  "Concepcion")))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Spelling

(use-package ispell
  :defer t
  :preface
  (defvar juanleon/main-dictionary      "english")
  (defvar juanleon/secondary-dictionary "castellano8")
  :config
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
  ;; :bind-keymap (:map (yas-minor-mode-map [(super ?`)] . yas-expand))
  :config
  (yas-global-mode)
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
  :init (setq-default ediff-ignore-similar-regions t)
  :custom
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-diff-options          " -bB "))


(use-package bm
  :ensure t
  :defer t
  :bind (([(control Scroll_Lock)] . bm-toggle)
         ([(shift Scroll_Lock)]   . bm-previous)
         ([(Scroll_Lock)]         . bm-next)))




(use-package back-button
  :ensure t
  :config (back-button-mode 1))


;; Cleaner modeline
(use-package minions
  :ensure t
  :config
  (minions-mode 1)
  (setq minions-mode-line-lighter "@"))


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


(use-package whitespace
  :defer t
  :config
  (setq whitespace-line-column 100))


(use-package time
  :defer t
  :config
  (setq display-time-world-list '(("America/Argentina/Buenos_Aires" "Buenos Aires")
                                  ("UTC" "UTC")
                                  ("Europe/Madrid" "Madrid"))))
