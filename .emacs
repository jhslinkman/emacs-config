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
	virtualenvwrapper
	websocket
	request
	ein
	;; ein-mumamo
	;; mumamo
	auto-complete
	autopair
	find-file-in-repository
	flycheck
	js2-mode
	multi-web-mode
	simple-httpd
	skewer-mode
	ac-js2
	json-mode
	markdown-mode
	auctex
	auto-complete-auctex
	bash-completion
	;; php-mode
	ess
	pos-tip
        polymode
	web-mode
	less-css-mode
	ensime
	yafolding
))

(mapc 'install-if-needed to-install)

;; Position at point
(require 'pos-tip)

(require 'magit)
(global-set-key "\C-xg" 'magit-status)

(require 'auto-complete)
(require 'autopair)

;; yasnippet settings
(require 'yasnippet)
(add-hook 'web-mode-hook #'(lambda () (yas-activate-extra-mode 'html-mode)))
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

;; Settings for all programming modes
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'yas-minor-mode)
(add-hook 'prog-mode-hook 'autopair-mode)
(add-hook 'prog-mode-hook (lambda()
			    (setq indent-tabs-mode nil)))

;; ;; Python mode settings

(require 'virtualenvwrapper)
(venv-initialize-interactive-shells)
(venv-initialize-eshell)
(setq venv-location "c:/venvs/")
(setq ein:console-args '("--profile" "default"))

(require 'ein)

(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(setq py-electric-colon-active t)
(add-hook 'python-mode-hook 'linum-mode)

(setq
 python-shell-interpreter "ipython")

;; ;; ;; Jedi settings
(require 'jedi)
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)
;; ;; It's also required to run "pip install --user jedi" and "pip
;; ;; install --user epc" to get the Python side of the library work
;; ;; correctly.
;; ;; With the same interpreter you're using.

;; ;; if you need to change your python intepreter, if you want to change it
;; ;; (setq jedi:server-command
;; ;;       '("python2" "/home/andrea/.emacs.d/elpa/jedi-0.1.2/jediepcserver.py"))

(add-hook 'python-mode-hook
	  (lambda ()
	    (jedi:setup)
	    (jedi:ac-setup)
            (local-set-key "\C-cd" 'jedi:show-doc)
            (local-set-key (kbd "M-SPC") 'jedi:complete)
            (local-set-key (kbd "M-.") 'jedi:goto-definition)))



(add-hook 'python-mode 'auto-complete-mode)
(add-hook 'python-mode-hook (lambda ()
			      (setq-default indent-tabs-mode nil)
			      (setq-default tab-width 4)
			      (setq-default py-indent-tabs-mode nil)
			      (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

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
;; (add-hook 'js2-mode-hook 'skewer-mode)
;; (add-hook 'js-mode-hook 'skewer-mode)
;; (add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)
(add-hook 'css-mode-hook 'autopair-mode)

;; JavaScript settings
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq js-indent-level 4)

;; json settings
(require 'json-mode)
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
(add-hook 'json-mode-hook 'autopair-mode)

;; HTML settings
;; (require 'multi-web-mode)
;; (setq mweb-default-major-mode 'html-mode)
;; (setq mweb-tags '((js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;;                   (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
;; (setq mweb-filename-extensions '("htm" "html" "ctp"))
;; (multi-web-global-mode 1)

;; (add-hook 'js-mode-hook 'autopair-mode)
;; (add-hook 'js-mode-hook 'yas-minor-mode)
;; (add-hook 'css-mode-hook 'autopair-mode)
;; (add-hook 'css-mode-hook 'yas-minor-mode)
;; (add-hook 'html-mode-hook 'autopair-mode)
;; (add-hook 'html-mode-hook 'yas-minor-mode)


(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.hbs?\\'" . web-mode))
(setq web-mode-enable-current-element-highlight nil)
(add-hook 'web-mode-hook 'autopair-mode)
(add-hook 'web-mode-hook 'yas-minor-mode)

(require 'less-css-mode)
(add-to-list 'auto-mode-alist '("\\.less\\'" . less-css-mode))
(add-hook 'less-css-mode-hook 'autopair-mode)

;; SQL settings
(require 'sql)
(setq sql-mysql-options '("-C" "-t" "-f" "-n" "-P 3306"))
(add-hook 'sql-mode-hook 'autopair-mode)
(add-hook 'sql-mode-hook 'yas-minor-mode)
(sql-set-product 'mysql)

;; Tex and Latex
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(require 'auto-complete-auctex)
(add-hook 'TeX-mode-hook 'autopair-mode)

;; Markdown mode
(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-hook 'markdown-mode-hook 'autopair-mode)
(add-hook 'markdown-mode-hook 'linum-mode)
(add-hook 'markdown-mode-hook 'yas-minor-mode)
(add-hook 'markdown-mode-hook (lambda()
			    (setq indent-tabs-mode nil)))

;; Scala
(setq exec-path (append exec-path '("C:/Program Files (x86)/sbt/bin")))
;; (setenv "PATH" (concat "/path/to/scala/bin:" (getenv "PATH")))

(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)



;; Emacs Lisp settings
(add-hook 'emacs-lisp-mode-hook 'autopair-mode)
(add-hook 'emacs-lisp-mode-hook 'yas-minor-mode)

;; libraries for working with things
(require 'thingatpt)
(load "~/lib/thing-edit.el") ; http://www.emacswiki.org/emacs/download/thing-edit.el

;; Cygwin

(defun cygwin-shell ()
  "Run cygwin bash in shell mode."
  (interactive)
  (let ((explicit-shell-file-name "C:/cygwin64/bin/bash")
	(explicit-bash-args '("--login" "-i")))
    (call-interactively 'shell)))

;; bash completion

(autoload 'bash-completion-dynamic-complete
  "bash-completion"
  "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions
  'bash-completion-dynamic-complete)
(add-hook 'shell-command-complete-functions
  'bash-completion-dynamic-complete)

;; ess
(require 'ess-site)
(add-hook 'ess-R-post-run-hook 'autopair-mode)
(add-hook 'ess-mode-hook 'auto-complete-mode)
(add-hook 'ess-mode-hook 'autopair-mode)
(add-hook 'ess-mode-hook 'linum-mode)

(setq inferior-R-program-name "C:\\Program Files\\R\\R-3.2.2\\bin\\x64\\Rterm.exe")
(setq inferior-julia-program-name "C:\\Julia\\Julia-0.3.5\\Julia\\bin\\julia.exe")

(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . poly-markdown+r-mode))

(setq ac-quick-help-prefer-pos-tip t)
(setq ac-auto-show-menu 1)
;; Doc-view
(setq doc-view-ghostscript-program "gswin64c")
(add-to-list 'image-library-alist '(png "libpng12.dll"))

(ess-toggle-underscore nil)

(defun ess-rmarkdown (&optional pdf)
  "Compile R markdown (.Rmd). Should work for any output type."
  (interactive)
					; Check if attached R-session
  (condition-case nil
      (ess-get-process)
    (error
     (ess-switch-process)))
  (let* ((rmd-buf (current-buffer))
	 (system-command (if pdf
			     "library(rmarkdown); rmarkdown::render(\"%s\", \"pdf_document\")"
			   "library(rmarkdown); rmarkdown::render(\"%s\")")))
    (save-excursion
      (let* ((sprocess (ess-get-process ess-current-process-name))
	     (sbuffer (process-buffer sprocess))
	     (buf-coding (symbol-name buffer-file-coding-system))
	     (R-cmd
	      (format system-command
		      buffer-file-name)))
	(message "Running rmarkdown on %s" buffer-file-name)
	(ess-execute R-cmd 'buffer nil nil)
	(switch-to-buffer rmd-buf)
	(ess-show-buffer (buffer-name sbuffer) nil)))))

(defun html-preview ()
  "Open current buffer's .html preview in browser."
  (interactive)
  (let* ((fbase (file-name-sans-extension (buffer-name (current-buffer))))
	 (fhtml ( concat fbase ".html")))
    (if (file-exists-p fhtml)
	(browse-url-of-file fhtml)
      (message (concat fhtml " does not exist.")))
    ))

;; org mode

;; (require 'org)
;; (define-key global-map "\C-cl" 'org-store-link)
;; (define-key global-map "\C-ca" 'org-agenda)
;; (setq org-log-done t)

;; (setq org-agenda-files (list "~/org/"))

;; -------------------- extra nice things --------------------
;; use shift to move around windows
;;(windmove-default-keybindings 'shift)
(show-paren-mode t)
 ; Turn beep off
(setq visible-bell nil)
(setq dired-isearch-filenames t)
(setq save-interprogram-paste-before-kill t)

;; Aesthetics
(custom-set-variables
 '(custom-enabled-themes (quote (misterioso))))
(custom-set-faces)

;; initialization settings
(add-hook 'after-init-hook (lambda () (delete-other-windows)))
(setq inhibit-splash-screen t)

;; Spaces instead of tabs
(setq-default intent-tabs-mode nil)

;; some extra odds and ends

(defun move-right-and-insert-comma ()
  "Move the cursor right one character and insert a ','."
  (interactive)
  (forward-char)
  (insert ","))


(defun comma-region (posBegin posEnd)
  "Insert commas between each character in region."
  (interactive "r")
  (let (charCount)
    (setq charCount (- posEnd posBegin))
    (goto-char posBegin)
    (while (> charCount 1)
      (move-right-and-insert-comma)
      (setq charCount (1- charCount)))))

(defun comma-word ()
  "Insert commas between each character in word."
  (interactive)
  (let ((posBegin (point))
	charCount)
    (forward-word)
    (setq charCount (- (point) posBegin))
    (goto-char posBegin)
    (while (> charCount 1)
      (move-right-and-insert-comma)
      (setq charCount (1- charCount)))))


(provide '.emacs)
;;; .emacs ends here
(put 'dired-find-alternate-file 'disabled nil)
