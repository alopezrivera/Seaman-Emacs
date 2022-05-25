;;; -*- lexical-binding: t; -*-

;; display
(setq-default frame-title-format '("Emacs [%m] %b"))
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

;; warnings
(setq visible-bell t)

;; typefaces
(set-face-attribute 'default     nil :height 85)

;; dialogues
(advice-add 'yes-or-no-p :override #'y-or-n-p)

;; startup buffers
(defvar background-buffers
  '("~/.emacs.d/init.el"
    "~/.emacs.d/wild.el"))

(defun custom/spawn-startup-buffers ()
  (cl-loop for buffer in (append startup-buffers background-buffers)
	   collect (find-file-noselect buffer)))

(add-hook 'after-init-hook #'custom/spawn-startup-buffers)

;; straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; modus
(straight-use-package 'modus-themes)
(modus-themes-load-themes)
(modus-themes-load-operandi)

;; magit
(straight-use-package 'magit)

;; multiple cursors
(straight-use-package 'multiple-cursors)
(require 'multiple-cursors)

;; mc-lists
(setq mc/list-file "~/.emacs.d/mc-lists.el")

;; Create cursors
(global-set-key (kbd "C-.")         'mc/mark-next-like-this)
(global-set-key (kbd "C-;")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-<mouse-1>") 'mc/add-cursor-on-click)
(global-unset-key [C-down-mouse-1]) ; necessary

;; Return as usual
(define-key mc/keymap (kbd "<return>")       'electric-newline-and-maybe-indent)

;; Exit multiple-cursors-mode
(define-key mc/keymap (kbd "<escape>")       'multiple-cursors-mode)
(define-key mc/keymap (kbd "<mouse-1>")      'multiple-cursors-mode)
(define-key mc/keymap (kbd "<down-mouse-1>")  nil) ; necessary

;; ivy
(straight-use-package 'ivy)
(straight-use-package 'counsel)
(straight-use-package 'ivy-rich)
(require 'ivy)
(require 'counsel)
(require 'ivy-rich)

(let ((map ivy-minibuffer-map))
  (dolist (pair '(("<tab>" . ivy-alt-done)
		  ("<up>"  . ivy-previous-line-or-history)
		  ("C-l"   . ivy-alt-done)
		  ("C-j"   . ivy-next-line)
		  ("C-k"   . ivy-previous-line)))
    (define-key map (kbd (car pair)) (cdr pair))))

(let ((map ivy-switch-buffer-map))
  (dolist (pair '(("C-k"   . ivy-previous-line)
		  ("C-l"   . ivy-done)
		  ("C-d"   . ivy-switch-buffer-kill)))
    (define-key map (kbd (car pair)) (cdr pair))))

(let ((map ivy-reverse-i-search-map))
  (dolist (pair '(("C-k"   . ivy-previous-line)
		  ("C-d"   . ivy-reverse-i-search-kill)))
    (define-key map (kbd (car pair)) (cdr pair))))

(global-set-key (kbd "<menu>") 'counsel-M-x)

(ivy-mode 1)
(ivy-rich-mode 1)

;; swiper
(straight-use-package 'swiper)
(require 'swiper)

(defun custom/swiper-isearch (orig-fun &rest args)
  "`swiper-isearch' the selected region. If none are, `swiper-isearch'."
  (if (region-active-p)
      (let ((beg (region-beginning))
	    (end (region-end)))
	(deactivate-mark)
	(apply orig-fun (list (buffer-substring-no-properties beg end))))
    (apply orig-fun args)))
(advice-add 'swiper-isearch :around #'custom/swiper-isearch)
(define-key global-map (kbd "C-s") #'swiper-isearch)

(defun custom/swiper-multiple-cursors ()
  (interactive)
  (swiper-mc)
  (minibuffer-keyboard-quit))
(define-key swiper-map (kbd "M-<return>") 'custom/swiper-multiple-cursors)

;; winner
(winner-mode)

;; workgroups
(straight-use-package 'workgroups)
(require 'workgroups)

(setq wg-prefix-key (kbd "C-c w"))

(workgroups-mode 1)

;; desktop
(desktop-save-mode 1)

;; org
(setq org-src-tab-acts-natively        t)
(setq org-src-preserve-indentation     nil)
(setq org-edit-src-content-indentation 0)

;; ide
(require 'ide (concat config-directory "ide.el"))

(provide 'wild)
