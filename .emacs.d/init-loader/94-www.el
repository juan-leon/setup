(use-package browse-url
  :defer t
  :commands browse-url-interactive-arg
  :config
  (setq browse-url-browser-function 'browse-url-firefox))

(use-package xwidget
  :defer t
  :commands xwidget-webkit-browse-url
  :init
  ;; adapt webkit according to window configuration change automatically
  ;; without this hook, every time you change your window configuration,
  ;; you must press 'a' to adapt webkit content to new window size
  (add-hook 'window-configuration-change-hook
            (lambda ()
              (when (equal major-mode 'xwidget-webkit-mode)
                (xwidget-webkit-adjust-size-dispatch))))
  :config
  (define-key xwidget-webkit-mode-map [mouse-4] 'xwidget-webkit-scroll-down)
  (define-key xwidget-webkit-mode-map [mouse-5] 'xwidget-webkit-scroll-up)
  (define-key xwidget-webkit-mode-map (kbd "<up>") 'xwidget-webkit-scroll-down)
  (define-key xwidget-webkit-mode-map (kbd "<down>") 'xwidget-webkit-scroll-up)
  (define-key xwidget-webkit-mode-map (kbd "M-w") 'xwidget-webkit-copy-selection-as-kill)
  (define-key xwidget-webkit-mode-map (kbd "C-c") 'xwidget-webkit-copy-selection-as-kill)
  (defun xwidget-kill-buffer-query-function () t))

;; by default, xwidget reuses previous xwidget window,
;; thus overriding your current website, unless a prefix argument
;; is supplied
;;
;; This function always opens a new website in a new window
(defun xwidget-browse-url-no-reuse (url &optional new-session)
  (interactive (browse-url-interactive-arg "URL: "))
  (xwidget-webkit-browse-url url t))
