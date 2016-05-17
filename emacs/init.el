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
	     '("melpa-stable" . "http://stable.melpa.org/packages/"))

(defun install-if-needed (package)
  (unless (package-installed-p package)
    (package-refresh-contents)
    (package-install package)))

(package-initialize)
(package-refresh-contents)

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.sls?\\'" . yaml-mode))

(setq package-list '(fill-column-indicator auto-complete flycheck less-css-mode markdown-mode jedi smartparens magit))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)

(require 'uniquify)
(require 'fill-column-indicator)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-create-new-buffer 'always)
(ido-mode 1)

(define-globalized-minor-mode
 global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode t)

(display-time)

(setq default-directory "full_path_to_dir")
