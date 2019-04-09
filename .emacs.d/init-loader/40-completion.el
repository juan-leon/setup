(use-package ivy
  :ensure t
  :diminish ivy-mode
  :bind (([(control ?c) (control ?r)] . ivy-resume)
         ([(meta kp-5)]     . ivy-switch-buffer)
         ([(meta kp-begin)] . ivy-switch-buffer)
         ([(control ?\\)] . ivy-switch-buffer)
         ([(control ?c) ?v] . ivy-push-view)
         ([(control ?c) ?V] . ivy-pop-view)
         :map ivy-minibuffer-map
         ([(control ?w)] . ivy-yank-word)
         ([(control ?a)] . ivy-yank-symbol)
         )
  :config
  (ivy-mode 1)
  (setq ivy-height 16
        ivy-use-virtual-buffers t
        ivy-count-format "%d/%d "
        projectile-completion-system 'ivy
        ivy-initial-inputs-alist nil
        magit-completing-read-function 'ivy-completing-read
        ivy-re-builders-alist '((counsel-dash . ivy--regex-ignore-order)
                                (t . ivy--regex-plus))
        ivy-height-alist '((counsel-dash . 48)
                           (counsel-dash-at-point . 48)
                           (counsel-yank-pop . 64))))


(use-package swiper
  :ensure t
  :bind (([(control ?s)] . swiper)))


(use-package counsel
  :ensure t
  :bind (([(meta ?x)] . counsel-M-x)
         ([(control ?x) (control ?f)] . counsel-find-file)
         ([(super ?.)] . counsel-imenu)
         ([(super b)] . counsel-bookmark)
         ([(super y)] . counsel-yank-pop)
         :map shell-mode-map
         ([(control ?r)] . counsel-shell-history)
         ([(super up)] . counsel-shell-history))
  :config
  ;; Counsel overrides my ivy-height configs :-(
  (setq ivy-height-alist '((counsel-dash . 48)
                           (counsel-dash-at-point . 48)
                           (counsel-yank-pop . 64))))


(use-package ivy-hydra
  :ensure t
  :defer
  :commands hydra-ivy/body)


(use-package counsel-projectile
  :ensure t
  :after projectile
  :bind (([(super ?q)] . counsel-projectile)
         ([(super ?\\)] . counsel-projectile)
         ([(super kp-5)] . counsel-projectile)))


;; counsel-M-x is a lot nicer when smex is installed
(use-package smex
  :ensure t
  :init (setq smex-save-file (concat user-emacs-directory ".smex-items"))
  :config (smex-auto-update 60))


(use-package counsel-dash
  :ensure t
  :defer t
  :bind (([(super return)] . counsel-dash-at-point)
         ([(super shift return)] . counsel-dash))
  :config
  (setq counsel-dash-browser-func
        (lambda (url)
          (other-window 1)
          (xwidget-webkit-browse-url url)))
  ;; fixme check if present and install them (using zeal to do that nowadays,
  ;; helm-dash-ensure-docset-installed is not working as expected)
  (defun counsel-dash-at-point ()
    (interactive)
    (let ((helm-dash-common-docsets
           (cond
            ((eq major-mode 'emacs-lisp-mode) '("Emacs_Lisp"))
            ((eq major-mode 'python-mode) '("Python_3"))
            ((eq major-mode 'sh-mode) '("Bash"))
            ((eq major-mode 'php-mode) '("PHP"))
            ((eq major-mode 'sql-mode) '("MySQL"))
            ;; All of the above
            (t '("Python_3" "Bash" "PHP" "MySQL" "Emacs_Lisp")))))
      (counsel-dash (thing-at-point 'symbol)))))


(defadvice projectile-switch-project (around be-fuzzy (arg) activate)
  "Use fuzzy matching"
  (let ((ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
        (ivy-height 32))
    ad-do-it))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Work on progress: name the thing and integrate in use-package

(defvar xxx/view-template "[%s]")

(defun xxx/get-view-name ()
  ;; try catch
  (let ((project-name (or projectile-project-name
                          (projectile-default-project-name (projectile-project-root)))))
    (format xxx/view-template project-name)))

(defun xxx/update-view-for-project ()
  (interactive)
  (let ((view-name (xxx/get-view-name))
        ;; code stolen from ivy.el
        (view (cl-labels
                  ((ft (tr)
                       (if (consp tr)
                          (if (eq (car tr) t)
                              (cons 'vert
                                    (mapcar #'ft (cddr tr)))
                            (cons 'horz
                                  (mapcar #'ft (cddr tr))))
                         (with-current-buffer (window-buffer tr)
                           (cond (buffer-file-name
                                  (list 'file buffer-file-name (point)))
                                ((eq major-mode 'dired-mode)
                                 (list 'file default-directory (point)))
                                (t
                                 (list 'buffer (buffer-name) (point))))))))
                (ft (car (window-tree))))))
    (when view-name
      (let ((x (assoc view-name ivy-views)))
        (if x
            (setcdr x (list view))
          (push (list view-name view) ivy-views))))))


(global-set-key [(super ?=)] 'xxx/update-view-for-project)

(defun juanleon/projectile-switch-project-action ()
  (let ((view (assoc (xxx/get-view-name) ivy-views)))
    (if view
        (progn
          (delete-other-windows)
          (ivy-set-view-recur (cadr view)))
      (if (magit-git-repo-p (projectile-project-root))
          (magit-status-internal (projectile-project-root))
        (projectile-dired)))))


(setq projectile-switch-project-action 'juanleon/projectile-switch-project-action)
