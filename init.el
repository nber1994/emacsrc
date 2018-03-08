;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(custom-safe-themes
   (quote
    ("e11569fd7e31321a33358ee4b232c2d3cf05caccd90f896e1df6cab228191109" default)))
 '(fci-rule-color "#383838")
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(package-selected-packages
   (quote
    (multi-term zenburn-theme company hungry-delete swiper counsel smartparens evil js2-mode nodejs-repl exec-path-from-shell helm-ag window-numbering)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



 (when (>= emacs-major-version 24)
     (require 'package)
     (package-initialize)
     (setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
		      ("melpa" . "https://melpa.org/packages/"))))
;;		      ("melpa" . "http://elpa.emacs-china.org/melpa/"))))

;; 注意 elpa.emacs-china.org 是 Emacs China 中文社区在国内搭建的一个 ELPA 镜像

 ;; cl - Common Lisp Extension
 (require 'cl)

 ;; Add Packages
 (defvar my/packages '(
		;; --- Auto-completion ---
		company
		auto-complete
		;; --- Better Editor ---
		hungry-delete
		swiper
		counsel
		smartparens
		evil
		;; --- Major Mode ---
		js2-mode
		;; --- Minor Mode ---
		nodejs-repl
		exec-path-from-shell
		;; --- Themes ---
		;;monokai-theme
		;; solarized-theme
		zenburn-theme
		;; --- search ---
		helm-ag
		;;window
		window-numbering
		;;php-mode
		php-mode
		;;terminal
        ;;linum
        linum-relative
		) "Default packages")

 (setq package-selected-packages my/packages)

 (defun my/packages-installed-p ()
     (loop for pkg in my/packages
	   when (not (package-installed-p pkg)) do (return nil)
	   finally (return t)))

 (unless (my/packages-installed-p)
     (message "%s" "Refreshing package database...")
     (package-refresh-contents)
     (dolist (pkg my/packages)
       (when (not (package-installed-p pkg))
	 (package-install pkg))))

 ;; Find Executable Path on OS X
 (when (memq window-system '(mac ns))
   (exec-path-from-shell-initialize))

;;===============插件配置
(setq evil-want-C-u-scroll t)
(setq evil-want-C-i-jump nil)
(require 'evil)
(evil-mode 1)
(when evil-want-C-i-jump
  (define-key evil-motion-state-map (kbd "C-i") 'evil-jump-forward))
;;(setcdr evil-insert-state-map nil)
;;(define-key evil-insert-state-map [escape] 'evil-normal-state)
;;使用ctrl-u进行向上滚屏
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
;;跳转
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

;;php-mode
(eval-after-load 'php-mode
  '(require 'php-ext))

;;跳转
(autoload 'gtags-mode "gtags" "" t)  ;gtags-mode is true

 (global-set-key (kbd "M-.") 'gtags-find-tag)

 (global-set-key (kbd "M-,") 'gtags-find-rtag)

 (global-set-key (kbd "M-g M-f") 'gtags-find-file)

 (global-set-key (kbd "M-g M-s") 'gtags-find-symbol)

 (global-set-key (kbd "M-g M-u") 'gtags-update)

;;相对行号
(require 'linum-relative)
(linum-on)
(setq linum-relative-current-symbol "")

;; color-theme
(load-theme 'zenburn t)

;;
(window-numbering-mode 1)

; 开启全局 Company 补全
(global-company-mode 1)
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(require 'org)
(setq org-src-fontify-natively t)
;; 设置默认 Org Agenda 文件目录
(setq org-agenda-files '("~/org"))

;; 设置 org-agenda 打开快捷键
(global-set-key (kbd "C-c a") 'org-agenda)
(set-language-environment "UTF-8")

;;
(global-set-key (kbd "C-c p s") 'helm-do-ag-project-root)


;;=================单独的配置
;; 关闭工具栏，tool-bar-mode 即为一个 Minor Mode
(tool-bar-mode -1)

;; 关闭文件滑动控件
;;(scroll-bar-mode -1)

;; 显示行号
(global-linum-mode 1)
(linum-relative-global-mode t)

;; 更改光标的样式（不能生效，解决方案见第二集）
(setq cursor-type 'bar)

;; 关闭启动帮助画面
(setq inhibit-splash-screen 1)

;; 关闭缩进 (第二天中被去除)
;; (electric-indent-mode -1)

;; 快速打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; 这一行代码，将函数 open-init-file 绑定到 <f2> 键上
(global-set-key (kbd "<f2>") 'open-init-file)


;; 选中替换
(delete-selection-mode 1)

;; 自动加载修改的文件
(global-auto-revert-mode 1)


;;关闭哔哔
(setq ring-bell-function 'ignore)

;;简化
(fset 'yes-or-no-p 'y-or-n-p)

;;
(put 'dired-find-alternate-file 'disabled nil)

;; 主动加载 Dired Mode
;; (require 'dired)
;; (defined-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)

;; 延迟加载
(with-eval-after-load 'dired
    (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

(add-to-list 'load-path "~/.emacs.d/lisp/")

;; session
(desktop-save-mode 1)

;; 代码跳转
;; etags
(cond ((eq system-type 'windows-nt)
       (setq path-to-ctags "C:/installs/gnuglobal/bin/ctags.exe")))
(cond ((eq system-type 'gnu/linux)
       (setq path-to-ctags "/usr/local/bin/ctags")))

(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (message
  (format "%s -f %s/tags -eR %s"
  path-to-ctags (directory-file-name dir-name) (directory-file-name
                                                dir-name)))
(shell-command
 (format "%s -f %s/tags -eR %s" path-to-ctags
         (directory-file-name dir-name) (directory-file-name dir-name)))
)
