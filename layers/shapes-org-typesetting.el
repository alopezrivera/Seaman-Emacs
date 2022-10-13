(shapes-module "org-modern")

(defun custom/org-typefaces-body ()
  (with-eval-after-load 'org-faces

    ;; Code
    (set-face-attribute 'org-block                 nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-code                  nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim              nil :inherit '(shadow fixed-pitch))

    ;; Tables
    (set-face-attribute 'org-table                 nil :inherit '(shadow fixed-pitch))

    ;; Lists
    (set-face-attribute 'org-checkbox              nil :inherit 'fixed-pitch)

    ;; Meta
    (set-face-attribute 'org-meta-line             nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-document-info         nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-document-info-keyword nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-special-keyword       nil :inherit 'fixed-pitch)))

(add-hook 'org-mode-hook #'custom/org-typefaces-body)

;; use levels 1 through 8
(setq org-n-level-faces 8)

;; do not cycle header style after 8th level
(setq org-cycle-level-faces nil)

;; hide leading stars
(setq org-hide-leading-starts t)

;; font sizes
(defun custom/org-heading-typefaces () 
  (with-eval-after-load 'org-faces
    (dolist (face '((org-level-1 . 1.175)
                    (org-level-2 . 1.175)
                    (org-level-3 . 1.175)
                    (org-level-4 . 1.175)
                    (org-level-5 . 1.175)
                    (org-level-6 . 1.175)
                    (org-level-7 . 1.175)
                    (org-level-8 . 1.175)))
         (set-face-attribute (car face) nil :font typeface-heading :weight 'bold :height (cdr face)))))

(add-hook 'org-mode-hook #'custom/org-heading-typefaces)

(add-hook 'org-mode-hook (lambda () (progn (visual-line-mode 1) (setq line-move-visual t))))

;; symbols, super- and subscripts
(setq org-pretty-entities nil)

;; Change ellipsis ("...") to remove clutter
(setq org-ellipsis " ♢")

(provide 'shapes-layer-org-typesetting)
;;; shapes-org-typesetting.el ends here
