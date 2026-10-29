;;; dotfiles-tangle.el --- GENERATED from config.org ("Emacs / Tangling"). Do not edit.  -*- lexical-binding: t; -*-

;; Saving config.org: tangle it completely, delete generated files whose
;; section disappeared, stage the generated files in git, and report.
;; Loaded by config.el, and by the `tangle-config' command (emacs --batch).

(require 'org)
(require 'ob-tangle)
(require 'seq)
(require 'subr-x)

(defconst MJ-dotfiles-dir
  (file-name-as-directory
   (expand-file-name "../.." (file-name-directory
                              (or load-file-name buffer-file-name))))
  "The dotfiles repository: two levels above live/emacs/.")

(defconst MJ-config-file (expand-file-name "config.org" MJ-dotfiles-dir)
  "The literate configuration.")

(defvar MJ-tangle-manifest (locate-user-emacs-file "dotfiles-tangled.eld")
  "File listing what the last complete tangle wrote, on this machine.")

(defconst MJ-generated-regexp "\\(?:GENERATED\\|tangled\\) from config\\.org"
  "A generated file says so in its first lines.")

(defun MJ--relative (file)
  "FILE relative to the repository."
  (file-relative-name file MJ-dotfiles-dir))

(defun MJ--generated-file-p (file)
  "Non-nil if FILE says in its first lines that it was generated."
  (with-temp-buffer
    (insert-file-contents file nil 0 1000)
    (re-search-forward MJ-generated-regexp nil t)))

(defun MJ--read-manifest ()
  "The files written by the previous complete tangle, or nil."
  (when (file-readable-p MJ-tangle-manifest)
    (with-temp-buffer
      (insert-file-contents MJ-tangle-manifest)
      (ignore-errors (read (current-buffer))))))

(defun MJ--write-manifest (files)
  "Remember FILES as written by this tangle."
  (make-directory (file-name-directory MJ-tangle-manifest) t) ; a new machine
  (with-temp-file MJ-tangle-manifest
    (prin1 files (current-buffer))))

(defun MJ--git (&rest args)
  "Run git with ARGS in the repository; return its exit status, or nil."
  (when (executable-find "git")
    (let ((default-directory MJ-dotfiles-dir))
      (apply #'call-process "git" nil (get-buffer-create " *dotfiles-git*") nil
             args))))

(defun MJ--delete-empty-parents (file)
  "Delete the folders above FILE that are now empty, up to the repository."
  (let ((dir (file-name-directory file)))
    (while (and dir
                (file-directory-p dir)
                (file-in-directory-p dir MJ-dotfiles-dir)
                (not (file-equal-p dir MJ-dotfiles-dir))
                (null (directory-files dir nil
                                       directory-files-no-dot-files-regexp t)))
      (delete-directory dir)
      (setq dir (file-name-directory (directory-file-name dir))))))

(defun MJ--rebuild-status ()
  "On NixOS: whether the Nix files differ from the running system."
  (let ((fingerprint (expand-file-name "~/.local/bin/dotfiles-fingerprint"))
        (built (expand-file-name "dotfiles/built"
                                 (or (getenv "XDG_STATE_HOME")
                                     "~/.local/state"))))
    (when (file-executable-p fingerprint)
      (let ((now (string-trim
                  (with-output-to-string
                    (call-process fingerprint nil standard-output nil))))
            (then (when (file-readable-p built)
                    (with-temp-buffer
                      (insert-file-contents built)
                      (string-trim (buffer-string))))))
        (if (equal now then)
            "nothing to rebuild"
          "Nix files changed: run rebuild")))))

(defun MJ--check-niri ()
  "On NixOS: an error message if niri rejects its generated settings."
  (let ((niri (executable-find "niri"))
        (kdl (expand-file-name "live/niri/config.kdl" MJ-dotfiles-dir)))
    (when (and niri (file-exists-p kdl))
      (with-temp-buffer
        (unless (eq 0 (call-process niri nil t nil "validate" "--config" kdl))
          (concat "niri's settings have an error: "
                  (car (last (split-string (string-trim (buffer-string))
                                           "\n")))))))))

(defun MJ-tangle-config ()
  "Tangle config.org completely, remove stale generated files, stage, report."
  (interactive)
  (let* ((default-directory MJ-dotfiles-dir)
         (coding-system-for-write 'utf-8-unix)
         (org-src-preserve-indentation t)
         (written (delete-dups
                   (mapcar #'expand-file-name
                           (let ((inhibit-message t)) ; quiet: one report at the end
                             (org-babel-tangle-file MJ-config-file)))))
         (previous (MJ--read-manifest))
         (suspicious (and previous
                          (< (length written) (/ (length previous) 2))))
         (stale (unless suspicious
                  (seq-filter (lambda (file)
                                (and (not (member file written))
                                     (file-exists-p file)
                                     (file-in-directory-p file MJ-dotfiles-dir)
                                     (MJ--generated-file-p file)))
                              previous)))
         (parts (list (format "Tangled %d files" (length written)))))
    (dolist (file stale)
      (delete-file file)
      (MJ--delete-empty-parents file))
    (unless suspicious
      (MJ--write-manifest written))
    ;; Stage the written files and the deletions, so Nix sees them.
    (when written
      (apply #'MJ--git "add" "--" (mapcar #'MJ--relative written)))
    ;; Scripts in live/bin must be executable on NixOS. Windows has no such
    ;; permission, and git there would record them as ordinary files; so set
    ;; the bit in git itself (harmless on NixOS, where it is set already).
    (let ((scripts (seq-filter (lambda (f) (string-prefix-p "live/bin/" f))
                               (mapcar #'MJ--relative written))))
      (when scripts
        (apply #'MJ--git "update-index" "--chmod=+x" "--" scripts)))
    (when stale
      (apply #'MJ--git "rm" "--cached" "--quiet" "--ignore-unmatch" "--"
             (mapcar #'MJ--relative stale)))
    (when stale
      (push (format "removed %s" (mapconcat #'MJ--relative stale ", ")) parts))
    (when suspicious
      (push "far fewer files than last time, so nothing was removed" parts))
    (let ((status (MJ--rebuild-status)))
      (when status (push status parts)))
    (let ((niri (MJ--check-niri)))
      (when niri (push niri parts)))
    (let ((report (mapconcat #'identity (nreverse parts) "; ")))
      (message "%s" report)
      report)))

(defun MJ-date-config ()
  "Before config.org is saved: set its #+DATE line to today's date."
  (when (and buffer-file-name
             (file-equal-p buffer-file-name MJ-config-file))
    (save-excursion
      (goto-char (point-min))
      ;; Only the header (the first 20 lines), never a #+DATE further down.
      (when (re-search-forward "^#\\+DATE: .*$"
                               (save-excursion (forward-line 20) (point)) t)
        (let ((today (format-time-string "#+DATE: %Y-%m-%d")))
          (unless (equal (match-string 0) today)
            (replace-match today t t)))))))

(defun MJ-tangle-batch ()
  "Entry point for `emacs --batch': see `MJ-tangle-config'."
  (MJ-tangle-config))

;;; dotfiles-tangle.el ends here
