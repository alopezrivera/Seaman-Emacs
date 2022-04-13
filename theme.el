;; Default face
(set-face-attribute 'default nil        :font "Fira Code Retina" :height 110)

;; Fixed pitch face
(set-face-attribute 'fixed-pitch nil    :font "Fira Code Retina" :height 110)

;; Variable pitch face
(set-face-attribute 'variable-pitch nil :font "Linux Libertine"  :height 135 :weight 'regular)

;; Title face
(setq title-typeface "Century Gothic")

;; Heading face
(setq heading-typeface "Century Gothic")

;; Mode line
(set-face-attribute 'mode-line nil :height 110 :inherit 'fixed-pitch)

;; Symbol library
(use-package all-the-icons
  :if (display-graphic-p))

(defun custom/org-pitch-setup ()
  (with-eval-after-load 'org-faces

    ;; Code
    (set-face-attribute 'org-block                 nil :foreground nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-code                  nil                 :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim              nil                 :inherit '(shadow fixed-pitch))

    ;; Tables
    (set-face-attribute 'org-table                 nil                 :inherit '(shadow fixed-pitch))

    ;; Lists
    (set-face-attribute 'org-checkbox              nil                 :inherit 'fixed-pitch)
    (set-face-attribute 'org-indent                nil                 :inherit '(org-hide fixed-pitch))

    ;; Meta
    (set-face-attribute 'org-meta-line             nil                 :inherit 'fixed-pitch)
    (set-face-attribute 'org-document-info         nil                 :inherit 'fixed-pitch)
    (set-face-attribute 'org-document-info-keyword nil                 :inherit 'fixed-pitch)
    (set-face-attribute 'org-special-keyword       nil                 :inherit 'fixed-pitch)))

(add-hook 'org-mode-hook #'custom/org-pitch-setup)

;; Title face

(defun custom/org-title-setup () 
  (with-eval-after-load 'org-faces
    (set-face-attribute 'org-document-title nil :font title-typeface :height 2.074 :weight 'bold :foreground 'unspecified)))
;; :inherit 'org-level-8

(add-hook 'org-mode-hook #'custom/org-title-setup)

;; Use levels 1 through 4
(setq org-n-level-faces 4)

;; Do not cycle header style after 4th level
(setq org-cycle-level-faces nil)

;; Hide leading stars
(setq org-hide-leading-starts t)

;; Font sizes
(defun custom/org-header-setup () 
  (with-eval-after-load 'org-faces

    ;; Heading font sizes
    (dolist (face '((org-level-1 . 1.5)
                    (org-level-2 . 1.2)
                    (org-level-3 . 1.1)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.0)
                    (org-level-6 . 1.0)
                    (org-level-7 . 1.0)
                    (org-level-8 . 1.0)))
         (set-face-attribute (car face) nil :font heading-typeface :weight 'regular :height (cdr face)))))

(add-hook 'org-mode-hook #'custom/org-header-setup)

(use-package svg-tag-mode)

(defconst date-re "[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}")
(defconst time-re "[0-9]\\{2\\}:[0-9]\\{2\\}")
(defconst day-re "[A-Za-z]\\{3\\}")
(defconst day-time-re (format "\\(%s\\)? ?\\(%s\\)?" day-re time-re))

(defun svg-progress-percent (value)
  (svg-image (svg-lib-concat
              (svg-lib-progress-bar (/ (string-to-number value) 100.0)
                                nil :margin 0 :stroke 2 :radius 3 :padding 2 :width 11)
              (svg-lib-tag (concat value "%")
                           nil :stroke 0 :margin 0)) :ascent 'center))

(defun svg-progress-count (value)
  (let* ((seq (mapcar #'string-to-number (split-string value "/")))
         (count (float (car seq)))
         (total (float (cadr seq))))
  (svg-image (svg-lib-concat
              (svg-lib-progress-bar (/ count total) nil
                                    :margin 0 :stroke 2 :radius 3 :padding 2 :width 11)
              (svg-lib-tag value nil
                           :stroke 0 :margin 0)) :ascent 'center)))

(setq svg-tag-tags
      `(
        ;; Org tags
        (":\\([A-Za-z0-9]+\\)" . ((lambda (tag) (svg-tag-make tag))))
        (":\\([A-Za-z0-9]+[ \-]\\)" . ((lambda (tag) tag)))
        
        ;; Task priority
        ("\\[#[A-Z]\\]" . ( (lambda (tag)
                              (svg-tag-make tag :face 'org-priority 
                                            :beg 2 :end -1 :margin 0))))

        ;; Progress
        ("\\(\\[[0-9]\\{1,3\\}%\\]\\)" . ((lambda (tag)
                                            (svg-progress-percent (substring tag 1 -2)))))
        ("\\(\\[[0-9]+/[0-9]+\\]\\)" . ((lambda (tag)
                                          (svg-progress-count (substring tag 1 -1)))))
        
        ;; TODO / DONE
        ("TODO" . ((lambda (tag) (svg-tag-make "TODO" :face 'org-todo :inverse t :margin 0))))
        ("DONE" . ((lambda (tag) (svg-tag-make "DONE" :face 'org-done :margin 0))))


        ;; Citation of the form [cite:@Knuth:1984]
        ("\\(\\[cite:@[A-Za-z]+:\\)" . ((lambda (tag)
                                          (svg-tag-make tag
                                                        :inverse t
                                                        :beg 7 :end -1
                                                        :crop-right t))))
        ("\\[cite:@[A-Za-z]+:\\([0-9]+\\]\\)" . ((lambda (tag)
                                                (svg-tag-make tag
                                                              :end -1
                                                              :crop-left t))))
        
        ;; Active date (with or without day name, with or without time)
        (,(format "\\(<%s>\\)" date-re) .
         ((lambda (tag)
            (svg-tag-make tag :beg 1 :end -1 :margin 0))))
        (,(format "\\(<%s \\)%s>" date-re day-time-re) .
         ((lambda (tag)
            (svg-tag-make tag :beg 1 :inverse nil :crop-right t :margin 0))))
        (,(format "<%s \\(%s>\\)" date-re day-time-re) .
         ((lambda (tag)
            (svg-tag-make tag :end -1 :inverse t :crop-left t :margin 0))))

        ;; Inactive date  (with or without day name, with or without time)
         (,(format "\\(\\[%s\\]\\)" date-re) .
          ((lambda (tag)
             (svg-tag-make tag :beg 1 :end -1 :margin 0 :face 'org-date))))
         (,(format "\\(\\[%s \\)%s\\]" date-re day-time-re) .
          ((lambda (tag)
             (svg-tag-make tag :beg 1 :inverse nil :crop-right t :margin 0 :face 'org-date))))
         (,(format "\\[%s \\(%s\\]\\)" date-re day-time-re) .
          ((lambda (tag)
             (svg-tag-make tag :end -1 :inverse t :crop-left t :margin 0 :face 'org-date))))))

;; Highlight HTML color strings in their own color
(use-package rainbow-mode
  :init (rainbow-mode))

(rainbow-mode 1)

(setq doom-modeline-bar-width 10)

(defun custom/modeline-color (color)
  (set-face-background 'modeline modeline-color)
  (set-face-attribute 'doom-modeline-bar nil :background modeline-color :inherit 'mode-line))

(defun custom/dark-modeline ()
  (custom/modeline-color "#000000"))

(defun custom/light-modeline ()
  (custom/modeline-color "#FFFFFF"))

;; Customize names displayed in mode line
(use-package delight)
(require 'delight)

;; Remove default modes from mode line
(delight '((visual-line-mode nil "simple")
	   (buffer-face-mode nil "simple")
   	   (eldoc-mode nil "eldoc")
	   ;; Major modes
	   (emacs-lisp-mode "EL" :major)))

(use-package org-modern)

(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

;; Org hook
(defun custom/org-mode-setup ()

  ;; Enter variable pitch mode
  (variable-pitch-mode 1)

  ;; Enter visual line mode:  wrap long lines at the end of the buffer, as opposed to truncating them
  (visual-line-mode    1)

  ;; Move through lines as they are displayed in visual-line-mode, as opposed to how they are stored.
  (setq line-move-visual t)

  ;; Enter indent mode: indent truncated lines appropriately
  (org-indent-mode     1))

(add-hook 'org-mode-hook #'custom/org-mode-setup)

;; Center text
(use-package olivetti
  :delight olivetti-mode
  )

(add-hook 'olivetti-mode-on-hook (lambda () (olivetti-set-width 0.9)))

(add-hook 'org-mode-hook 'olivetti-mode)

;; Title keyword
(setq org-hidden-keywords '(title))

;; Markup
(setq org-hide-emphasis-markers t)

;; Change ellipsis ("...") to remove clutter
(setq org-ellipsis " ▾")

(plist-put org-format-latex-options :scale 1.5)

(use-package modus-themes)

(modus-themes-load-themes)

(defvar after-enable-theme-hook nil
   "Normal hook run after enabling a theme.")

(defun run-after-enable-theme-hook (&rest _args)
   "Run `after-enable-theme-hook'."
   (run-hooks 'after-enable-theme-hook))

(advice-add 'enable-theme :after #'run-after-enable-theme-hook)

;; (defvar after-enable-modus-operandi-hook nil
;;    "Normal hook run after enabling a theme.")

;; (defun run-after-enable-modus-operandi-hook (&rest _args)
;;    "Run `after-enable-theme-hook'."
;;    (run-hooks 'after-enable-theme-hook))

;; (advice-add 'enable-theme :after #'run-after-enable-theme-hook)

;; (advice-add 'enable-theme :after #'run-after-enable-theme-hook)

;; (enable-theme 'modus-operandi)

;; (defun foo (a b) (+ a b))

;; (advice-add 'foo :around (lambda (orig a b)))

;; Org Mode
(defun custom/org-theme-reload ()
  (if (custom/in-mode "org-mode")
      (org-mode)))

(add-hook 'after-enable-theme-hook #'custom/org-theme-reload)

;; Mode line
;; (add-hook ')

(defun my-modus-themes-toggle ()
  "Toggle between `modus-operandi' and `modus-vivendi' themes.
This uses `enable-theme' instead of the standard method of
`load-theme'.  The technicalities are covered in the Modus themes
manual."
  (interactive)
  (pcase (modus-themes--current-theme)
    ('modus-operandi (progn (enable-theme 'modus-vivendi)
                            (disable-theme 'modus-operandi)))
    ('modus-vivendi (progn (enable-theme 'modus-operandi)
                            (disable-theme 'modus-vivendi)))
    (_ (error "No Modus theme is loaded; evaluate `modus-themes-load-themes' first"))))

(use-package circadian                  ; you need to install this
  :config
  (setq circadian-themes '(("08:00" . modus-operandi)
                           ("17:00"  . modus-vivendi)))
  (circadian-setup))

(modus-themes-load-vivendi)

;; Provide theme
(provide 'theme)