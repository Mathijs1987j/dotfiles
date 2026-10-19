;;; config.el --- tangled from config.org; do not edit  -*- lexical-binding: t; -*-

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      inhibit-compacting-font-caches t)

(defconst MJ-windows-p (eq system-type 'windows-nt)
  "Non-nil on Windows.")

(defconst MJ-nix-p
  (let ((lib (locate-library "vertico")))
    (and lib (string-prefix-p "/nix/store/" (file-truename lib))))
  "Non-nil when the Emacs packages are provided by Nix.")

(require 'package)

(let ((gpg (and MJ-windows-p
                (substitute-in-file-name "$USERPROFILE/scoop/shims/gpg.exe"))))
  (when (and gpg (file-exists-p gpg))
    (setq epg-gpg-program gpg)))

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)          ; harmless on Nix; ensures activation elsewhere

(require 'use-package)
(setq use-package-always-ensure (not MJ-nix-p))

(setq custom-file (locate-user-emacs-file "custom.el"))

(defconst MJ-config-file
  (expand-file-name "config.org"
                    (file-name-directory (or load-file-name buffer-file-name)))
  "The literate configuration (config.org) in the dotfiles repository.")

(defun MJ-open-init-file ()
  "Open the real configuration (config.org)."
  (interactive)
  (find-file MJ-config-file))

(global-set-key (kbd "C-c i") #'MJ-open-init-file)

(defun MJ-tangle-config ()
  "Tangle the configuration when `MJ-config-file' is saved."
  (when (and buffer-file-name
             (string= (file-truename buffer-file-name)
                      (file-truename MJ-config-file)))
    (org-babel-tangle)))

(add-hook 'org-mode-hook
          (lambda () (add-hook 'after-save-hook #'MJ-tangle-config nil t)))

(setq inhibit-startup-message t
      history-length 25
      global-auto-revert-non-file-buffers t)

(tool-bar-mode -1)
(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)
(repeat-mode 1)                  ; e.g. C-x o o o keeps switching windows

(add-hook 'prog-mode-hook #'electric-pair-local-mode)

(load-theme 'deeper-blue t)
;; Built-in alternative worth trying: (load-theme 'modus-vivendi t)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(dolist (hook '(shell-mode-hook eshell-mode-hook term-mode-hook
                eat-mode-hook pdf-view-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode 0))))

(use-package indent-bars
  :hook ((prog-mode web-mode) . indent-bars-mode)
  :custom
  (indent-bars-treesit-support (and (fboundp 'treesit-available-p)
                                    (treesit-available-p))))

(use-package which-key
  :ensure nil
  :config (which-key-mode))

(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind (("C-s"   . consult-line)
         ("C-c f" . consult-ripgrep)          ; needs ripgrep
         ("C-x b" . consult-buffer))
  :init
  ;; "Find references" and "go to definition" results through consult.
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(use-package embark
  :bind (("C-." . embark-act))
  :init (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult))

(use-package corfu
  :init (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-cycle t))

(use-package cape
  :init (add-hook 'completion-at-point-functions #'cape-file))

(use-package project
  :ensure nil
  :bind-keymap ("C-c p" . project-prefix-map))

(use-package magit
  :bind ("C-x g" . magit-status))

(setq treesit-language-source-alist
      '((python     "https://github.com/tree-sitter/tree-sitter-python")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript" nil "src")
        (css        "https://github.com/tree-sitter/tree-sitter-css")
        (html       "https://github.com/tree-sitter/tree-sitter-html")
        (json       "https://github.com/tree-sitter/tree-sitter-json")
        (nix        "https://github.com/nix-community/tree-sitter-nix")))

(defun MJ-treesit-ready-p (lang)
  "Return non-nil if tree-sitter and the grammar for LANG are available."
  (and (fboundp 'treesit-available-p)
       (treesit-available-p)
       (treesit-language-available-p lang)))

(defun MJ-treesit-install-missing ()
  "Install every grammar in `treesit-language-source-alist' not yet present.
Needs git and a C compiler on PATH."
  (interactive)
  (dolist (entry treesit-language-source-alist)
    (unless (treesit-language-available-p (car entry))
      (treesit-install-language-grammar (car entry)))))

(dolist (m '((python-mode     python-ts-mode python)
             (js-mode         js-ts-mode     javascript)
             (javascript-mode js-ts-mode     javascript)
             (css-mode        css-ts-mode    css)
             (js-json-mode    json-ts-mode   json)))
  (when (MJ-treesit-ready-p (nth 2 m))
    (add-to-list 'major-mode-remap-alist (cons (nth 0 m) (nth 1 m)))))

(defun MJ-eglot-ensure-if (program)
  "Return a hook function that starts eglot only if PROGRAM is on PATH."
  (lambda ()
    (when (executable-find program)
      (eglot-ensure))))

(use-package eglot
  :ensure nil
  :bind (:map eglot-mode-map
              ("C-c r" . eglot-rename)          ; same key as with lsp-mode
              ("C-c a" . eglot-code-actions))
  :custom (eglot-autoshutdown t)
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("basedpyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs
               '((web-mode :language-id "html") . ("vscode-html-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '((LaTeX-mode :language-id "latex") . ("texlab")))
  (add-to-list 'eglot-server-programs
               '(nix-ts-mode . ("nil"))))

(add-hook 'python-base-mode-hook (MJ-eglot-ensure-if "basedpyright-langserver"))
(add-hook 'js-base-mode-hook     (MJ-eglot-ensure-if "typescript-language-server"))
(add-hook 'css-base-mode-hook    (MJ-eglot-ensure-if "vscode-css-language-server"))
(add-hook 'web-mode-hook         (MJ-eglot-ensure-if "vscode-html-language-server"))
(add-hook 'LaTeX-mode-hook       (MJ-eglot-ensure-if "texlab"))
(add-hook 'nix-ts-mode-hook      (MJ-eglot-ensure-if "nil"))

(use-package flymake
  :ensure nil
  :bind (:map flymake-mode-map
              ("M-n" . flymake-goto-next-error)
              ("M-p" . flymake-goto-prev-error)))

(use-package yasnippet
  :init (yas-global-mode 1))

(use-package yasnippet-snippets)

(use-package apheleia
  :hook ((python-base-mode js-base-mode css-base-mode web-mode) . apheleia-mode)
  :config
  (setf (alist-get 'python-mode apheleia-mode-alist) 'ruff
        (alist-get 'python-ts-mode apheleia-mode-alist) 'ruff))

(use-package dape
  :commands dape
  :custom (dape-buffer-window-arrangement 'right))

(use-package aggressive-indent
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package paredit
  :hook (emacs-lisp-mode . paredit-mode))

(add-hook 'emacs-lisp-mode-hook (lambda () (electric-pair-local-mode -1)))

(use-package flymake-ruff
  :hook (eglot-managed-mode . (lambda ()
                                (when (and (derived-mode-p 'python-base-mode)
                                           (executable-find "ruff"))
                                  (flymake-ruff-load)))))

(use-package code-cells
  :hook (python-base-mode . code-cells-mode-maybe)
  :bind (:map code-cells-mode-map
              ("C-c C-c" . code-cells-eval)))

(use-package web-mode
  :mode ("\\.html?\\'" . web-mode)
  :hook (web-mode . (lambda () (setq indent-tabs-mode nil)))
  :custom
  (web-mode-markup-indent-offset 2)      ; HTML tags
  (web-mode-css-indent-offset 2)         ; embedded <style>
  (web-mode-code-indent-offset 2))       ; embedded <script>

(use-package css-mode
  :ensure nil
  :custom (css-indent-offset 2))

(use-package js
  :ensure nil
  :custom (js-indent-level 2))

(use-package emmet-mode
  :hook ((web-mode css-base-mode) . emmet-mode)
  :custom (emmet-use-style-tag-and-attr-detection t)
  :config (add-to-list 'emmet-css-major-modes 'css-ts-mode))

(use-package nix-ts-mode
  :if (MJ-treesit-ready-p 'nix)
  :mode "\\.nix\\'")

(use-package tex
  :ensure auctex
  :hook ((LaTeX-mode . visual-line-mode)
         (LaTeX-mode . TeX-source-correlate-mode))
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil)                ; ask for the master file in multi-file projects
  (TeX-source-correlate-start-server t)
  :config
  (unless MJ-windows-p            ; [NixOS] view PDFs in Emacs with pdf-tools
    (setf (alist-get 'output-pdf TeX-view-program-selection) '("PDF Tools"))
    (add-hook 'TeX-after-compilation-finished-functions
              #'TeX-revert-document-buffer)))

(use-package cdlatex
  :hook ((LaTeX-mode . turn-on-cdlatex)
         (org-mode   . turn-on-org-cdlatex)))

(use-package citar
  :custom
  (citar-bibliography '("~/path/to/your/references.bib")))   ; adjust

(use-package pdf-tools
  :if (not MJ-windows-p)
  :init (pdf-loader-install))

(use-package jinx
  :if (not MJ-windows-p)
  :hook (text-mode . jinx-mode)
  :bind ("M-$" . jinx-correct)
  :custom (jinx-languages "en_US nl_NL"))

(use-package flyspell
  :ensure nil
  :if MJ-windows-p
  :hook (LaTeX-mode . flyspell-mode))

(use-package org
  :ensure nil
  :hook (org-mode . visual-line-mode)
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t) (python . t) (latex . t))))

(use-package jupyter
  :if (not MJ-windows-p)
  :after org
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   (append org-babel-load-languages '((jupyter . t)))))

(use-package org-re-reveal
  :after org
  :custom
  (org-re-reveal-root ".")
  (org-re-reveal-revealjs-version "4"))

(use-package eat
  :if (not MJ-windows-p)
  :commands eat)

(load custom-file 'noerror 'nomessage)

(use-package envrc
  :if (executable-find "direnv")
  :hook (after-init . envrc-global-mode))

;;; config.el ends here
