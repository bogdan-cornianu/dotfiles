(custom-set-variables
    '(ansi-color-names-vector ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
    '(column-number-mode t)
    '(show-paren-mode t)
    '(tool-bar-mode nil)
    '(show-trailing-whitespace t)
    '(scroll-bar-mode nil)
    '(inhibit-startup-screen t)
    '(large-file-warning-threshold nil)
    '(python-shell-interpreter "python")
    '(display-time-day-and-date t)
    '(display-time-24hr-format t)
    '(custom-enabled-themes (quote (wombat)))
)

(set-frame-font "Source Code Pro-13" nil t)

(require 'package)
(add-to-list 'package-archives
	     '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))

(defun install-if-needed (package)
  (unless (package-installed-p package)
    (package-refresh-contents)
    (package-install package)))

(package-initialize)
(package-refresh-contents)

(setq package-list '(auto-complete yaml-mode flycheck less-css-mode markdown-mode jedi smartparens magit virtualenvwrapper))

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.sls?\\'" . yaml-mode))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)

(require 'uniquify)
(require 'smartparens)
(show-smartparens-global-mode +1)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-create-new-buffer 'always)
(ido-mode 1)

(display-time)
(setq js-indent-level 4)

(require 'virtualenvwrapper)
(venv-initialize-interactive-shells) ;; if you want interactive shell support
(venv-initialize-eshell) ;; if you want eshell support
(setq venv-location "~/Envs/")

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'python-mode-hook
          (lambda ()
            (jedi:setup)
            (jedi:ac-setup)
            (local-set-key "\C-cd" 'jedi:show-doc)
            (local-set-key (kbd "M-SPC") 'jedi:complete)
            (local-set-key (kbd "M-.") 'jedi:goto-definition)))

(defun flycheck-python-set-executables ()
  (let ((exec-path (python-shell-calculate-exec-path)))
    (setq flycheck-python-pylint-executable (executable-find "pylint")
          flycheck-python-pylintrc "~/.pylintrc"
          flycheck-python-flake8-executable (executable-find "flake8")))
  ;; Force Flycheck mode on
  (flycheck-mode))

(defun flycheck-python-setup ()
  (add-hook 'hack-local-variables-hook #'flycheck-python-set-executables
            nil 'local))

(add-hook 'python-mode-hook (lambda ()
                              (hack-local-variables)
                              (when (boundp 'project-venv-name)
                                (venv-workon project-venv-name))))
(add-hook 'python-mode-hook #'flycheck-python-setup)

(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files"
  (interactive)
  (let* ((list (buffer-list))
         (buffer (car list)))
    (while buffer
      (when (and (buffer-file-name buffer)
                 (not (buffer-modified-p buffer)))
        (set-buffer buffer)
        (revert-buffer t t t))
      (setq list (cdr list))
      (setq buffer (car list))))
  (message "Refreshed open files"))
(global-set-key [(control shift f5)] 'revert-all-buffers)

(defun kill-other-buffers ()
  "Kill all buffers but the current one.
Don't mess with special buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (unless (or (eql buffer (current-buffer)) (not (buffer-file-name buffer)))
      (kill-buffer buffer))))

(setq locate-command "mdfind")
(setq default-directory "full path to dir")
