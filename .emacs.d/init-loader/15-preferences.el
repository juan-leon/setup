
(setq-default
 indent-tabs-mode                   nil
 tab-width                          4
 fill-column                        80
 case-fold-search                   nil
 ediff-ignore-similar-regions       t
 search-ring-update                 t
 save-place                         t
 truncate-lines                     t
 ws-trim-level                      1
 ws-trim-method-hook                '(ws-trim-trailing))

(setq
 align-to-tab-stop                  nil
 auto-save-default                  nil
 backup-directory-alist             `(("" . ,(concat user-emacs-directory "/autosaved/")))
 browse-url-browser-function        'browse-url-chromium
 calendar-week-start-day            1
 calendar-mark-holidays-flag        t
 comint-input-ignoredups            t
 comint-use-prompt-regexp           nil  ; Weird bugs otherwise
 confirm-kill-emacs                 'y-or-n-p ; "Fast fingers protection"
 disabled-command-function          nil ; Warnings already read
 ediff-window-setup-function        'ediff-setup-windows-plain
 ediff-split-window-function        'split-window-horizontally
 ediff-diff-options                 " -bB "
 garbage-collection-messages        t
 ido-case-fold                      nil
 ido-enable-tramp-completion        nil
 ido-save-directory-list-file       (concat user-emacs-directory "history/ido")
 ido-auto-merge-delay-time          20
 ido-slow-ftp-host-regexps          '(".")
 ido-read-file-name-non-ido         '(dired-create-directory)
 inhibit-startup-message            t
 initial-scratch-message            nil
 isearch-allow-scroll               t
 jit-lock-stealth-time              5
 jit-lock-stealth-nice              0.25
 kill-do-not-save-duplicates        t
 kill-ring-max                      100
 major-mode                         'text-mode
 Man-notify-method                  'pushy
 message-log-max                    2500
 nxml-child-indent                  tab-width
 recentf-save-file                  (concat user-emacs-directory ".recentf")
 require-final-newline              t
 save-place-file                    (concat user-emacs-directory "history/places")
 search-ring-max                    32
 server-window                      'switch-to-buffer-other-frame
 scroll-step                        1
 scroll-conservatively              1
 scroll-preserve-screen-position    'in-place
 smex-save-file                     (concat user-emacs-directory ".smex-items")
 text-scale-mode-step               1.1
 track-eol                          t
 undo-ask-before-discard            nil
 uniquify-buffer-name-style         'post-forward-angle-brackets
 visible-bell                       t
 warning-suppress-types             '((undo discard-info))
 whitespace-line-column             100
 x-select-enable-primary            t
 x-select-enable-clipboard          t
 yascroll:delay-to-hide             nil)

(setq ibuffer-formats '((mark modified read-only
                              " " (name 35 35)
                              " " (size 9 9 :right)
                              " " (mode 18 18 :left :elide)
                              " " filename-and-process)
                        (mark " " (name 30 -1) " " filename)))


(column-number-mode       1)
(recentf-mode             1)
(auto-image-file-mode     1)
(show-paren-mode          1)
(size-indication-mode     1)
(file-name-shadow-mode    1)
(temp-buffer-resize-mode  1)
(winner-mode              1)
(global-yascroll-bar-mode 1)
(ido-mode                 1)
(ido-everywhere           1)
(flx-ido-mode             1)
(global-ws-trim-mode      1)
(back-button-mode         1)
(electric-pair-mode       1)

(require 'ack-and-a-half)
(require 'saveplace)
(require 'scroll-in-place)
(require 'uniquify)
(require 'buffer-move)
