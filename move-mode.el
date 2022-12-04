;;; move-mode.el --- Major mode for editing move source files. -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright @ 2022, Chao Xu

;; Author: Chao Xu (fardream@users.noreply.github.com)
;; Version: 0.1
;; Keywords: move-lang
;; URL: https://github.com/fardream/move-mode

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This package provides a major mode to edit move-lang (https://github.com/move-lang/move) source files.
;; It only provides very simple syntax highlighting.

;; based on go-mode at https://go.googlesource.com/go/+/294f9b8/misc/emacs/go-mode.el

;;; Code:


(defun move-mode--regexp-enclose-in-symbol (s)
  "Enclose S as a symbol."
  (concat "\\_<" s "\\_>"))

(defun move-mode--build-font-locks ()
  "Build font locks for move mode."
  )

(defconst move-mode-identifier-regexp "[[:word:][:multibyte:]_]+")
(defconst move-mode-keywords
  '("break" "if" "else" "fun" "public" "entry" "acquires" "has" "struct" "let" "use" "module" "const" "phantom")
  "All keywords in move.")
(defconst move-mode-types
  '("bool" "vector" "u8" "u64" "u128" "u256" "address" "signer")
  "All types in move-lang.")
(defconst move-mode-fun-regexp (concat
                                (move-mode--regexp-enclose-in-symbol "fun") "\\s *\\(" move-mode-identifier-regexp "\\)"))
(defconst move-mode-named-address-regexp (concat "\\@" move-mode-identifier-regexp))

(defconst move-lang-constants '("true" "false"))

(setq move-mode-font-lock-keywords
      `(
        (, "assert!" . 'font-lock-warning-face)
        (,move-mode-fun-regexp . font-lock-function-name-face)
        (,(move-mode--regexp-enclose-in-symbol (regexp-opt move-mode-keywords t)) . 'font-lock-type-face) ;; types
        (,(concat (move-mode--regexp-enclose-in-symbol "struct") "[[:space:]]+" move-mode-identifier-regexp) . 'font-lock-type-face) ;; types
        (,(move-mode--regexp-enclose-in-symbol (regexp-opt move-mode-types t)) . 'font-lock-keyword-face)
        (,(move-mode--regexp-enclose-in-symbol (regexp-opt move-lang-constants t)) . 'font-lock-constant-face)
        (,(move-mode--regexp-enclose-in-symbol move-mode-named-address-regexp) . 'font-lock-constant-face)
        (,(concat "\\(" move-mode-identifier-regexp "\\)[[:space:]]*(") . 'font-lock-function-name-face)
        )
      )

(defvar move-mode-syntax-table nil "Syntax table for `move-mode`.")

(setq move-mode-syntax-table
      (let ((st (make-syntax-table)))
        (modify-syntax-entry ?+  "." st)
        (modify-syntax-entry ?-  "." st)
        (modify-syntax-entry ?%  "." st)
        (modify-syntax-entry ?&  "." st)
        (modify-syntax-entry ?|  "." st)
        (modify-syntax-entry ?^  "." st)
        (modify-syntax-entry ?!  "." st)
        (modify-syntax-entry ?=  "." st)
        (modify-syntax-entry ?<  "." st)
        (modify-syntax-entry ?>  "." st)
        (modify-syntax-entry ?/ ". 124b" st)
        (modify-syntax-entry ?*  ". 23" st)
        (modify-syntax-entry ?\n "> b" st)
        (modify-syntax-entry ?\" "\"" st)
        (modify-syntax-entry ?\' "\"" st)
        (modify-syntax-entry ?`  "\"" st)
        (modify-syntax-entry ?\\ "\\" st)
      st))

;;;###autoload
(define-derived-mode move-mode fundamental-mode "move-lang"
  "Major mode for editing move source code."
  (setq font-lock-defaults '(move-mode-font-lock-keywords))

  ;; toggle comments
  (setq-local comment-start "// ")
  (setq-local comment-end "")

  )

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.move\\'" . move-mode))

(provide 'move-mode)
;;; move-mode.el ends here
