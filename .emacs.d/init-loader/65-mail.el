;; I need to use the package installed by debian file to match the notmuch version
(use-package notmuch
  :commands notmuch-hello
  :init
  (autoload 'notmuch "notmuch-hello")
  (setq send-mail-function    'smtpmail-send-it
        mail-self-blind       t
        smtpmail-local-domain "avature.net"
        smtpmail-smtp-server  "mail.avature.net"
        smtpmail-stream-type  'ssl
        smtpmail-smtp-service 465
        notmuch-fcc-dirs nil)

  ;; mail-self-blind is somehow ignored
  (add-hook 'message-setup-hook (lambda ()
                                  (message-add-header
                                   (concat "Bcc: " (notmuch-user-primary-email)))))

  ;; Use C-c C-d to transforn into HTML a message in markdown
  (defun juanleon/message-to-md ()
    (interactive)
    (save-excursion
      (message-goto-body)
      (shell-command-on-region (point) (point-max) "juanleon--markdown-mail" nil t)))
  (defun juanleon/message-send-md-formatted ()
    (interactive)
    (let ((message-send-hook '(juanleon/message-to-md)))
      (notmuch-mua-send-and-exit)))
  :config
  (bind-key "C-c C-d" 'juanleon/message-send-md-formatted notmuch-message-mode-map))