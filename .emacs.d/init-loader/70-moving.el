(use-package avy
  :ensure t
  :bind (([(super ?j)] . avy-goto-word-1)
         ([(super ?k)] . avy-goto-char-timer)
         ([(super ?l)] . avy-goto-line))
  :config
  (setq avy-keys '(up down left right)
        avy-lead-faces '(avy-lead-face
                         avy-lead-face-0
                         avy-lead-face
                         avy-lead-face-0
                         avy-lead-face
                         avy-lead-face-0)))


(use-package bm
  :ensure t
  :defer t
  :bind (([(control Scroll_Lock)] . bm-toggle)
         ([(shift Scroll_Lock)]   . bm-previous)
         ([(Scroll_Lock)]         . bm-next)))


(use-package back-button
  :ensure t
  :config (back-button-mode 1))
