;;; .emacs -- Summary:
;;; Commentary:

;;; Code:

;; Requisites: Emacs >= 24
(require 'package)
(package-initialize)

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)

(package-refresh-contents)

(defun install-if-needed (package)
  (unless (package-installed-p package)
    (package-install package)))

;; make more packages available with the package installer
(setq to-install
      '(python-mode
	magit
	yasnippet
	jedi
	auto-complete
	autopair
	find-file-in-repository
	flycheck
	js2-mode
	multi-web-mode
	simple-httpd
	skewer-mode
	ac-js2
))

(mapc 'install-if-needed to-install)

(require 'magit)
(global-set-key "\C-xg" 'magit-status)

(require 'auto-complete)
(require 'autopair)

;; yasnippet settings
(require 'yasnippet)
(yas-reload-all)

;; Flycheck settings
(require 'flycheck)
(global-flycheck-mode t)

(global-set-key [f7] 'find-file-in-repository)

; auto-complete mode extra settings
(setq
 ac-auto-start 2
 ac-override-local-map nil
 ac-use-menu-map t
 ac-candidate-limit 20)

;; ;; Python mode settings
(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(setq py-electric-colon-active t)
(add-hook 'python-mode-hook 'autopair-mode)
(add-hook 'python-mode-hook 'yas-minor-mode)

(setq
 python-shell-interpreter "ipython")

;; ;; Jedi settings
(require 'jedi)
;; It's also required to run "pip install --user jedi" and "pip
;; install --user epc" to get the Python side of the library work
;; correctly.
;; With the same interpreter you're using.

;; if you need to change your python intepreter, if you want to change it
;; (setq jedi:server-command
;;       '("python2" "/home/andrea/.emacs.d/elpa/jedi-0.1.2/jediepcserver.py"))

(add-hook 'python-mode-hook
	  (lambda ()
	    (jedi:setup)
	    (jedi:ac-setup)
            (local-set-key "\C-cd" 'jedi:show-doc)
            (local-set-key (kbd "M-SPC") 'jedi:complete)
            (local-set-key (kbd "M-.") 'jedi:goto-definition)))


(add-hook 'python-mode-hook 'auto-complete-mode)

(ido-mode t)

;; Emacs HTML server
;; default port is 8080
(require 'simple-httpd)
(setq httpd-root "c:/var/www")
(defun set-server-root ()
  "Set the root directory for the simple-httpd server to the current directory."
  (interactive)
  (setq httpd-root (read-from-minibuffer "Server root directory: ")))

;; Skewer settings
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'js-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)
;; (add-hook 'html-mode-hook 'skewer-html-mode)

;; JavaScript settings
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook 'autopair-mode)
(add-hook 'js2-mode-hook 'yas-minor-mode)

;; HTML settings
(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)

(add-hook 'js-mode-hook 'autopair-mode)
(add-hook 'js-mode-hook 'yas-minor-mode)
(add-hook 'css-mode-hook 'autopair-mode)
(add-hook 'css-mode-hook 'yas-minor-mode)
(add-hook 'html-mode-hook 'autopair-mode)
(add-hook 'html-mode-hook 'yas-minor-mode)

;; Emacs Lisp settings
(add-hook 'emacs-lisp-mode-hook 'autopair-mode)
(add-hook 'emacs-lisp-mode-hook 'yas-minor-mode)


;; -------------------- extra nice things --------------------
;; use shift to move around windows
;;(windmove-default-keybindings 'shift)
(show-paren-mode t)
 ; Turn beep off
(setq visible-bell nil)
(setq dired-isearch-filenames t)

;; Aesthetics
(custom-set-variables
 '(custom-enabled-themes (quote (misterioso))))
(custom-set-faces)


(provide '.emacs)
;;; .emacs ends here
