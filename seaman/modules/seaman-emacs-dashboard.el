;; requirements
(require 'projectile)
(require 'all-the-icons)
(require 'page-break-lines)

(straight-use-package 'dashboard)
(require 'dashboard)

(dashboard-setup-startup-hook)

;; options
(setq dashboard-center-content t)
(setq dashboard-set-file-icons t)

;; initial buffer choice
(if (and (not initial-buffer-choice)
         (string-equal (buffer-name (current-buffer)) "*scratch*"))
    (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*"))))

(provide 'seaman-module-emacs-dashboard)
;;; seaman-emacs-dashboard.el ends here
