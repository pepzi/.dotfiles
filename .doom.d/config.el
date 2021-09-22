(setq user-full-name "Robert Sand"
      user-mail-address "robert@pepzi.org")

(setq doom-theme 'doom-one)
(setq display-line-numbers-type 'relative)
(setq doom-font (font-spec :family "Fira Code" :size 18))

;; Remap CapsLock to Ctrl
;;(start-process-shell-command "xmodmap" nil "xmodmap ~/.Xmodmap")

(start-process-shell-command "setxkbmap" nil
                             "setxkbmap -model pc105 -layout se -variant swea5")

(set-irc-server! "irc.libera.chat"
  `(:tls t
    :port 6697
    :nick "pepzi"
    :sasl-username ,(+pass-get-user "irc/libera.chat")
    :sasl-password (lambda (&rest _) (+pass-get-secret "irc/libera.chat"))
    :channels ("#emacs")))

(setq org-directory "~/org/")
(setq org-roam-directory "~/org/roam")

(setq org-hide-emphasis-markers t)

(setq org-todo-keyword-faces
      '(("TODO"  . (:foreground "red" :weight bold))
        ("NEXT"  . (:foreground "red" :weight bold))
        ("DONE"  . (:foreground "forest green" :weight bold))
        ("WAITING"  . (:foreground "orange" :weight bold))
        ("CANCELLED"  . (:foreground "forest green" :weight bold))
        ("SOMEDAY"  . (:foreground "orange" :weight bold))
        ("OPEN"  . (:foreground "red" :weight bold))
        ("CLOSED"  . (:foreground "forest green" :weight bold))
        ("ONGOING"  . (:foreground "orange" :weight bold))))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!/!)")
        (sequence "WAITING(w@/!)" "|" "CANCELLED(c!/!)")
        (sequence "SOMEDAY(s!/!)" "|")
        (sequence "OPEN(O!)" "|" "CLOSED(C!)")
        (sequence "ONGOING(o)" "|")))

(defun pepzi/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun pepzi/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process
           `(,(car command-parts) nil 0 nil
             ,@(cdr command-parts)))))

(defun pepzi/exwm-init-hook ()
  ;; Make workspace 1 be the one where we land at startup
  (exwm-workspace-switch-create 1)

  ;; Launch apps that will run in the background
  (pepzi/run-in-background "nm-applet")
  (pepzi/run-in-background "pasystray")
  )

(require 'exwm)
(require 'exwm-config)

(setq exwm-systemtray-height 16)

;; Load the system tray before exwm-init
(require 'exwm-systemtray)
(exwm-systemtray-enable)

(setq exwm-workspace-number 5)

;; When EXWM finishes initialization, do some extra setup
(add-hook 'exwm-init-hook #'pepzi/exwm-init-hook)
(add-hook 'exwm-update-class-hook #'pepzi/exwm-update-class)

(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time-mode 1)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "qutebrowser")

(setq exwm-input-prefix-keys
  '(?\C-x
    ?\C-u
    ?\C-h
    ?\M-x
    ?\M-`
    ?\M-&
    ?\M-:
    ?\C-\M-j  ;; Buffer list
    ?\M-\ ))  ;; Ctrl+Space

(define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)
;;(exwm-input-set-key (kbd "s-k") #'exwm-workspace-delete)
;;(exwm-input-set-key (kbd "s-w") #'exwm-workspace-swap)

(defun my-new-exwm-launch (command)
"Doc-string."
  (async-start-process command command nil))

(exwm-input-set-key (kbd "s-d")
                    (lambda ()
                      (interactive)
                      (my-new-exwm-launch "dmenu_run")))

(setq exwm-input-global-keys
      `(
        ;; Reset to line-mode
        ;; (C-c C-k switches to char-mode
        ;;          via exwm-input-release-keyboard)
        ([?\s-r] . exwm-reset)
        ([?\s-f] . exwm-layout-toggle-fullscreen)

        ;; Move between windows
        ([s-left] . windmove-left)
        ([s-right] . windmove-right)
        ([s-up] . windmove-up)
        ([s-down] . windmove-down)

        ([?\s-h] . windmove-left)
        ([?\s-l] . windmove-right)
        ([?\s-k] . windmove-up)
        ([?\s-j] . windmove-down)

        ;; Launch applications via shell command
        ([?\s-&] . (lambda (command)
                     (interactive (list (read-shell-command "$ ")))
                     (start-process-shell-command command nil command)))

        ;; Switch workspace
        ([?\s-w] . exwm-workspace-switch)

        ;; 's-N': Switch to certain workspace
        ;;        with Super (Win) plus a number key (0 - 9)
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))))

(exwm-enable)

(after! elfeed
  (setq elfeed-search-filter "@1-month-ago +unread"))
