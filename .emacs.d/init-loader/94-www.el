(use-package browse-url
  :defer t
  :commands browse-url-interactive-arg
  :custom (browse-url-browser-function 'browse-url-firefox))

(use-package xwidget
  :defer t
  :commands xwidget-webkit-browse-url
  :config
  (define-key xwidget-webkit-mode-map [mouse-4] 'xwidget-webkit-scroll-down)
  (define-key xwidget-webkit-mode-map [mouse-5] 'xwidget-webkit-scroll-up)
  (define-key xwidget-webkit-mode-map (kbd "M-w") 'xwidget-webkit-copy-selection-as-kill)
  (defun xwidget-kill-buffer-query-function () t))
