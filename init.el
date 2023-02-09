;; shapes core
(add-to-list 'load-path (concat config-directory "core/"))

(defvar shapes-core-components '("load"
                                 "extensions"
                                 "package-manager"
                                 "config-management"))

(mapc (lambda (component) (require (intern (concat "shapes-core-" component)) (concat "shapes-" component)))
      shapes-core-components)

(message "Shapes: core loaded")

;; local settings
(let ((local (concat config-directory "local/local--" (system-name) ".el")))
  (if (file-exists-p local)
      (load-file local)
    (write-region ";; local emacs config" nil local)))

;; config directory
(setq config-directory (string-replace "~" (getenv "HOME") config-directory))

(load-file (concat config-directory "configs/" (concat config ".el")))

;; inhibit startup message
(setq inhibit-startup-message t)

;; startup buffers
(defun custom/spawn-startup-buffers ()
  "Spawn startup buffers"
  (cl-loop for buffer in startup-buffers
	   do (if (file-exists-p buffer)
                  (find-file-noselect buffer))))

(if spawn-startup-buffers
    (add-hook 'emacs-startup-hook #'custom/spawn-startup-buffers))

;; credentials
(defvar shapes-credentials-map (make-keymap))

(defun shapes-load-credentials ()
  (interactive)
  (let ((credential-file (concat config-directory "creds.el.gpg")))
    (if (file-exists-p credential-file)
        (condition-case nil
            (load-file credential-file)
          (error nil))
      (message "~/creds.el.gpg does not exist")))
  (global-set-key (kbd "C-M-p") shapes-credentials-map))

(global-set-key (kbd "C-M-p") #'shapes-load-credentials)

(provide 'init)
