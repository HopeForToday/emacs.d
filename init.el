;;; init.el --- Load the full configuration           -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Speedup startup
(let ((gct-original gc-cons-threshold)
      (fnha-original file-name-handler-alist))
  (setq gc-cons-threshold (* 1024 1024 27))
  (setq file-name-handler-alist nil)
  (run-with-idle-timer
   4 nil
   (lambda ()
     (setq gc-cons-threshold gct-original)
     (setq file-name-handler-alist fnha-original)
     (message "gc-cons-threshold and file-name-handler-alist restored"))))


(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "core" user-emacs-directory))

;;;; Modules

(require 'init-core)                    ; Must be loaded first
(require 'v-utils)
(require 'init-tools)
(require 'init-coding)
(require 'init-langs)
(require 'init-editor)
(require 'init-ui)
(require 'init-org)
(require 'v-tests)


(v-load doom-ui treemacs tabs
        company dumb-jump flycheck git lsp
        restclient
        elisp javascript org html xml yaml)

(require 'v-modules)


(bootstrap :ui
           auto-theme
           highlight
           :tools
           avy
           ivy)


(when is-wsl
  (bootstrap :os wsl))


(unless window-system
  (bootstrap :os tty))


(load-file v-autoload-file)


(defun v-golang ()
  "Load `v-golang' package."
  (quelpa '(v-golang :fetcher file :path "~/.emacs.d/v/v-golang.el"))
  (v-golang-config))


(defun v-python ()
  "Load `v-python' package."
  (interactive)
  (quelpa '(v-python :fetcher file :path "~/.emacs.d/v/v-python.el"))
  (v-python-config))


(defun bootstrap2 ()
  (v-golang))


(add-hook 'emacs-startup-hook #'bootstrap2)


;;;; Input method

(use-package rime
  :custom
  (default-input-method "rime")
  (rime-show-candidate 'posframe))


(use-package pyim
  :disabled
  :defer 1
  :if (and window-system is-wsl)
  :custom
  (default-input-method "pyim")
  (pyim-default-scheme 'microsoft-shuangpin)
  (pyim-page-tooltip 'posframe "Better performance than popup")
  :config
  ;; 使用半角标点
  (setq-default pyim-punctuation-translate-p '(no yes auto))

  ;; 使 pyim 在 ivy-posframe 中能够显示候选词
  ;; https://github.com/tumashu/ivy-posframe/issues/80#issuecomment-683519783
  (with-eval-after-load 'ivy-posframe
    (setq ivy-posframe-hide-minibuffer nil)))


(use-package pyim-basedict
  :after pyim
  :demand t
  :config
  (pyim-basedict-enable))


;;; init.el ends here
