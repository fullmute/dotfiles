(require 'package)

(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq-default
 gc-cons-threshold (* 20 1024 1024)
 gc-cons-percentage 0.5)

(setq
 inhibit-startup-message t
 inhibit-splash-screen t
 inhibit-startup-buffer-menu t
 inhibit-major-mode 'initial-major-mode)

(add-to-list 'load-path "~/.emacs.d/custom")
(require 'funcs)

(define-key emacs-lisp-mode-map (kbd "C-c C-r") 'reload-init-file)

(global-set-key (kbd "C-c n") 'clean-up-buffer-or-region)

(require 'use-package)

(setq inhibit-startup-message t
      inhibit-splash-screen t
      inhibit-startup-buffer-menu t
      inhibit-startup-echo-area-message t
      initial-major-mode 'org-mode)

(setq standard-indent 4)
(setq c-basic-offset 4)
(c-set-offset 'substatement-open 0)
(setq-default tab-width 4
              indent-tabs-mode nil)
(add-hook 'c-mode-common-hook
          (lambda ()
            (c-set-offset 'inextern-lang 0)))

(setq make-backup-files nil
      auto-save-default nil)

(setq custom-safe-themes t)

(use-package gruvbox-theme
  :ensure t
  :config
  (progn
    (load-theme 'gruvbox)))

(enable-theme 'gruvbox)

(use-package dynamic-fonts
  :ensure t
  :commands (dynamic-fonts-setup)
  :init
  (progn
    (setq
     dynamic-fonts-preferred-monospace-fonts
     '("PragmataPro" "Consolas" "Monaco" "Menlo" "DejaVu Sans Mono"
       "Droid Sans Mono Pro" "Droid Sans Mono" "Inconsolata" "Source Code Pro"
       "Lucida Console" "Envy Code R" "Andale Mono" "Lucida Sans Typewriter"
       "Lucida Typewriter" "Panic Sans" "Bitstream Vera Sans Mono"
       "Excalibur Monospace" "Courier New" "Courier" "Cousine" "Lekton"
       "Ubuntu Mono" "Liberation Mono" "BPmono" "Anonymous Pro"
       "ProFontWindows")
     dynamic-fonts-preferred-monospace-point-size 11
     dynamic-fonts-preferred-proportional-fonts
     '("PT Sans" "Lucida Grande" "Segoe UI" "DejaVu Sans" "Bitstream Vera"
       "Tahoma" "Verdana" "Helvetica" "Arial Unicode MS" "Arial")
     dynamic-fonts-preferred-proportional-point-size 11)

    (defvar my-monospaced-font "Droid Sans Mono-8")
    (defvar my-variable-pitch-font "Inconsolata-8")

    (defun my-set-fonts  ()
      (interactive)
      (when window-system
        (condition-case nil
            (progn
              (set-face-attribute 'default nil :font my-monospaced-font)
              ;; (set-face-attribute 'default nil :font my-monospaced-font :width 'ultra-condensed :weight 'normal )
              (set-face-attribute 'fixed-pitch nil :font my-monospaced-font)
              (set-face-attribute 'variable-pitch nil :font my-variable-pitch-font))
          (error
           (progn
             (message
              "Setting default fonts failed, running dynamic-fonts-setup...")
             (dynamic-fonts-setup))))))
    (add-hook 'after-init-hook 'my-set-fonts t)))

(defmacro hook-modes (func modes)
  "Add hook func to multiple modes"
  `(dolist (mode-hook ,modes)
     (add-hook mode-hook ,func)))

(use-package autopair
  :ensure t
  :diminish autopair-mode
  :config
  (progn
    (add-hook 'c-mode-common-hook  #'(lambda ()
                                         (push '(?< . ?>)
                                               (getf autopair-extra-pairs :code))))
    (autopair-global-mode)))

(use-package smart-tab
  :ensure t)

(use-package smart-tabs-mode
  :ensure t)

(use-package paren
  :config (show-paren-mode))

(use-package hl-line
  :config (global-hl-line-mode))

(use-package auto-complete
  :ensure t
  :config
  (progn
    (use-package auto-complete-exuberant-ctags
      :ensure t
      :config (ac-exuberant-ctags-setup))
    (use-package auto-complete-c-headers
      :ensure t)
    (use-package auto-complete-clang
      :ensure t)
    (ac-config-default)))

(use-package ace-jump-mode
  :ensure t
  :bind
  (("C-c a w" . ace-jump-word-mode)
   ("C-c a c" . ace-jump-char-mode)
   ("C-c a l" . ace-jump-line-mode)))

(use-package undo-tree
  :ensure t
  :config (global-undo-tree-mode)
  :bind
  (("C-c u u" . undo-tree-undo)
   ("C-c u r" . undo-tree-redo)
   ("C-c u b" . undo-tree-switch-branch)
   ("C-c u v" . undo-tree-visualize)))

(use-package neotree
  :ensure t
  :defer t
  :config
  (progn
    (setq neo-theme 'nerd
          neo-window-width 30
          neo-vc-integration '(face)))
  :bind
  (("C-c t" . neotree-toggle)))

(use-package highlight-parentheses
  :ensure t
  :diminish highlight-parentheses-mode
  :config
  (progn
    (set-face-attribute 'hl-paren-face nil :weight 'ultra-bold)
    (global-highlight-parentheses-mode)
    (add-to-list 'after-change-functions '(lambda (&rest x) (hl-paren-highlight)))))

(use-package powerline
  :ensure t
  :init
  (progn
    (set-face-attribute 'mode-line nil :box nil)
    (powerline-default-theme)))

(use-package flycheck
  :ensure t
  :defer t
  :init
  (progn
    (add-hook 'c-mode-common-hook 'flycheck-mode)))

(use-package multiple-cursors
  :ensure t
  :bind
  (("C-c C-m n" . mc/mark-next-like-this)
   ("C-c C-m p" . mc/mark-previous-like-this)
   ("C-c C-m a" . mc/mark-all-like-this)
   ("C-c C-m e" . mc/edit-lines)))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode)
  :mode
  (("\\.markdown\\'" . markdown-mode)
   ("\\.md\\'" . markdown-mode)))
