;; -*- lexical-binding: t; -*-

;; --- General Configuration ---
(setq inhibit-startup-message t)
(tool-bar-mode -1)

(recentf-mode 1)

(setq history-length 25)
(savehist-mode 1)

(save-place-mode 1)

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers 1)

(setq inhibit-compacting-font-caches t)

(defconst MJ-config-file (or load-file-name buffer-file-name))
(defun MJ-open-init-file ()
  "Open the real init file."
  (interactive)
  (find-file MJ-config-file))

(global-set-key (kbd "C-c i") #'MJ-open-init-file)

;; --- Themes ---
(load-theme 'deeper-blue t)
;;(use-package zenburn-theme
;;  :ensure t
;;  :config (load-theme 'zenburn t))

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)  ; optional: relative numbers, useful mainly for vim-style motions
(dolist (mode '(shell-mode-hook eshell-mode-hook term-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(require 'package)
;; Use Scoop's native Windows gpg, not the Unix-style one bundled with Git
(let ((gpg (and (eq system-type 'windows-nt)
		(substitute-in-file-name "$USERPROFILE/scoop/shims/gpg.exe"))))
  (when (and gpg (file-exists-p gpg))
    (setq epg-gpg-program gpg)))
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

;; --- General UI / completion-in-buffer helpers ---

(use-package which-key
  :config (which-key-mode))

(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-backends '((company-capf company-files))))

(use-package indent-bars
  :ensure t
  :hook ((prog-mode . indent-bars-mode)
         (web-mode . indent-bars-mode)))

;; --- Minibuffer completion UI (M-x, find-file, xref results, etc.) ---

(use-package vertico
  :ensure t
  :init (vertico-mode))

(use-package orderless
  :ensure t
  :custom (completion-styles '(orderless basic)))

(use-package marginalia
  :ensure t
  :init (marginalia-mode))

(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)
         ("C-c f" . consult-ripgrep)
         ("C-x b" . consult-buffer)))

(use-package embark
  :ensure t
  :bind (("C-." . embark-act))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure t
  :after (embark consult))

;; --- Project management ---

(use-package projectile
  :ensure t
  :init (projectile-mode +1)
  :bind-keymap ("C-c p" . projectile-command-map))

;; --- Git ---
(use-package magit
  :bind ("C-x g" . magit-status))

;; --- LSP core ---

(use-package lsp-mode
  :ensure t
  :commands lsp
  :init
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024)))

(with-eval-after-load 'lsp-mode
  (define-key lsp-mode-map (kbd "C-c r") #'lsp-rename))

;; Workaround for a known lsp-mode bug (emacs-lsp/lsp-mode issue #2915,
;; still open as of writing): when an LSP-backed completion or edit
;; triggers reindentation in a web-mode buffer, lsp-mode computes the
;; indent width via its own internal `lsp--get-indent-width' rather than
;; consulting web-mode's own offset variables. That function silently
;; falls back to Emacs's generic `standard-indent' (which defaults to 4),
;; ignoring `web-mode-markup-indent-offset' entirely — so buffers can look
;; correctly configured (the offset variable itself is right) while still
;; indenting at 4 spaces any time lsp-mode, not web-mode, ends up driving
;; the indentation.
;;
;; The fix: advise `lsp--get-indent-width' so that, specifically for
;; web-mode-derived buffers, it returns this buffer's `tab-width' instead
;; of falling through to the generic default. We keep `tab-width' in sync
;; with our actual preferred offset via the hook below, so the two stay
;; consistent without duplicating the "2" in two unrelated places.
;;
;; Wrapped in `with-eval-after-load' so the advice is only attached once
;; lsp-mode is actually loaded (it's autoloaded via `:commands lsp' above,
;; not loaded at startup) — attaching advice to a function that doesn't
;; exist yet would fail silently or error, depending on timing.
(add-hook 'web-mode-hook (lambda () (setq-local tab-width 2)))

(with-eval-after-load 'lsp-mode
  (advice-add 'lsp--get-indent-width :around
              (lambda (orig-fn mode)
                (if (provided-mode-derived-p mode 'web-mode)
                    tab-width
                  (funcall orig-fn mode)))))

;; --- Snippets (used by lsp-mode for smarter completions too) ---

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)

;; --- Elisp ---

(use-package aggressive-indent
  :ensure t
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package paredit
  :ensure t
  :hook (emacs-lisp-mode . paredit-mode))

;; --- Python ---

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

;; Python formatting is handled by Apheleia (see --- Formatting --- below).

;; --- Debugging (DAP) ---

(use-package dap-mode
  :ensure t
  :after lsp-mode
  :commands dap-debug
  :config
  (require 'dap-python)
  (dap-auto-configure-mode))

;; --- HTML / CSS / JS (e.g. reveal.js presentations) ---

(use-package web-mode
  :ensure t
  :mode ("\\.html?\\'" . web-mode)
  :hook (web-mode . lsp)
  :custom
  (web-mode-markup-indent-offset 2)  ; HTML tags
  (web-mode-css-indent-offset 2)     ; embedded <style> blocks
  (web-mode-code-indent-offset 2))   ; embedded <script> blocks

(add-hook 'web-mode-hook (lambda () (setq indent-tabs-mode nil)))

(use-package css-mode
  :hook (css-mode . lsp)
  :custom (css-indent-offset 2))

(use-package js2-mode
  :ensure t
  :mode "\\.js\\'"
  :hook (js2-mode . lsp)
  :custom (js2-basic-offset 2))

(use-package emmet-mode
  :ensure t
  :hook ((web-mode . emmet-mode)
         (css-mode . emmet-mode)))

;; HTML/CSS/JS formatting is handled by Apheleia (see --- Formatting --- below).

;; --- Formatting ---
;;
;; Apheleia formats buffers on save (black for Python, Prettier for
;; HTML/CSS/JS). It replaced blacken and prettier-js; prettier-js never
;; worked reliably on Windows here, for reasons that weren't pinned down.
;;
;; How it works: Apheleia sends the buffer's contents to the formatter
;; in the background, then runs the external `diff' program to compare
;; the original and formatted text, and applies only the changes. This
;; keeps point, marks and undo history intact, and skips the update if
;; you edited the buffer in the meantime.
;;
;; External requirements (all must be on `exec-path'):
;; - `diff' (on Windows, from Scoop's diffutils or Git's usr/bin).
;; - `bash', because Apheleia runs Prettier through a bundled bash
;;   script, "apheleia-npx" (Git for Windows' bash works).
;; - Prettier itself (npm install -g prettier) and black (pipx).
;;
;; Apheleia fails silently. If saving doesn't format, run
;; M-x apheleia-goto-error right after saving to see the formatter's output.
;;
;; Note: Prettier honours `.prettierignore' files in the project and its
;; parent folders. A project-level one (e.g. reveal.js's own, which
;; excludes all *.html) makes Prettier report success while changing
;; nothing. Check with: prettier --file-info <file>
(use-package apheleia
  :ensure t
  :hook ((web-mode css-mode js2-mode python-mode) . apheleia-mode)
  :config
  (setf (alist-get 'python-mode apheleia-mode-alist) '(black)))

;; --- Latex ---
(use-package auctex
  :ensure t
  :hook (LaTeX-mode . visual-line-mode)
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil))  ; ask which file is the "master" doc for multi-file projects

(use-package company-auctex
  :ensure t
  :after (company auctex)
  :config (company-auctex-init))

(use-package lsp-latex
  :ensure t
  :after (lsp-mode auctex)
  :hook (LaTeX-mode . lsp))

(use-package citar
  :ensure t
  :custom
  (citar-bibliography '("~/path/to/your/references.bib")))

(use-package flyspell
  :hook (LaTeX-mode . flyspell-mode))
