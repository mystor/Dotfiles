;;; nasm-mode.el --- mode for editing assembler code

;; Copyright (C) 1991, 2001-2014 Free Software Foundation, Inc.

;; Author: Eric S. Raymond <esr@snark.thyrsus.com>
;; Maintainer: emacs-devel@gnu.org
;; Keywords: tools, languages

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This mode was written by Eric S. Raymond <esr@snark.thyrsus.com>,
;; inspired by an earlier nasm-mode by Martin Neitzel.

;; This minor mode is based on text mode.  It defines a private abbrev table
;; that can be used to save abbrevs for assembler mnemonics.  It binds just
;; five keys:
;;
;;	TAB		tab to next tab stop
;;	:		outdent preceding label, tab to tab stop
;;	comment char	place or move comment
;;			nasm-comment-char specifies which character this is;
;;			you can use a different character in different
;;			Nasm mode buffers.
;;	C-j, C-m	newline and tab to tab stop
;;
;; Code is indented to the first tab stop level.

;; This mode runs two hooks:
;;   1) An nasm-mode-set-comment-hook before the part of the initialization
;; depending on nasm-comment-char, and
;;   2) an nasm-mode-hook at the end of initialization.

;;; Code:

(defgroup nasm nil
  "Mode for editing assembler code."
  :link '(custom-group-link :tag "Font Lock Faces group" font-lock-faces)
  :group 'languages)

(defcustom nasm-comment-char ?\;
  "The comment-start character assumed by Nasm mode."
  :type 'character
  :group 'nasm)

(defvar nasm-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?\n "> b" st)
    (modify-syntax-entry ?/  ". 124b" st)
    (modify-syntax-entry ?*  ". 23" st)
    st)
  "Syntax table used while in Nasm mode.")

(defvar nasm-mode-abbrev-table nil
  "Abbrev table used while in Nasm mode.")
(define-abbrev-table 'nasm-mode-abbrev-table ())

(defvar nasm-mode-map
  (let ((map (make-sparse-keymap)))
    ;; Note that the comment character isn't set up until nasm-mode is called.
    (define-key map ":"		'nasm-colon)
    (define-key map "\C-c;"	'comment-region)
    (define-key map "\C-j"	'newline-and-indent)
    (define-key map "\C-m"	'newline-and-indent)
    (define-key map [menu-bar nasm-mode] (cons "Nasm" (make-sparse-keymap)))
    (define-key map [menu-bar nasm-mode comment-region]
      '(menu-item "Comment Region" comment-region
		  :help "Comment or uncomment each line in the region"))
    (define-key map [menu-bar nasm-mode newline-and-indent]
      '(menu-item "Insert Newline and Indent" newline-and-indent
		  :help "Insert a newline, then indent according to major mode"))
    (define-key map [menu-bar nasm-mode nasm-colon]
      '(menu-item "Insert Colon" nasm-colon
		  :help "Insert a colon; if it follows a label, delete the label's indentation"))
    map)
  "Keymap for Nasm mode.")

(defconst nasm-font-lock-keywords
  (append
   '(
     ("^[ \t]*%\\sw+" . font-lock-type-face)
     ("^\\(\\(\\sw\\|\\s_\\)+\\)\\>:?[ \t]*\\(\\sw+\\(\\.\\sw+\\)*\\)?"
      (1 font-lock-function-name-face) (3 font-lock-keyword-face nil t))
     ;; label started from ".".
     ("^\\(\\.\\(\\sw\\|\\s_\\)+\\)\\>:"
      1 font-lock-function-name-face)
     ("^\\((\\sw+)\\)?\\s +\\(\\(\\.?\\sw\\|\\s_\\)+\\(\\.\\sw+\\)*\\)"
      2 font-lock-keyword-face)
     ;; directive started from ".".
     ("^\\(\\.\\(\\sw\\|\\s_\\)+\\)\\>[^:]?"
      1 font-lock-keyword-face)
     ;; %register
     ("%\\sw+" . font-lock-variable-name-face))
   cpp-font-lock-keywords)
  "Additional expressions to highlight in Nasm mode.")

;;;###autoload
(define-derived-mode nasm-mode prog-mode "Nasm"
  "Major mode for editing typical assembler code.
Features a private abbrev table and the following bindings:

\\[nasm-colon]\toutdent a preceding label, tab to next tab stop.
\\[tab-to-tab-stop]\ttab to next tab stop.
\\[nasm-newline]\tnewline, then tab to next tab stop.
\\[nasm-comment]\tsmart placement of assembler comments.

The character used for making comments is set by the variable
`nasm-comment-char' (which defaults to `?\\;').

Alternatively, you may set this variable in `nasm-mode-set-comment-hook',
which is called near the beginning of mode initialization.

Turning on Nasm mode runs the hook `nasm-mode-hook' at the end of initialization.

Special commands:
\\{nasm-mode-map}"
  (setq local-abbrev-table nasm-mode-abbrev-table)
  (set (make-local-variable 'font-lock-defaults) '(nasm-font-lock-keywords))
  (set (make-local-variable 'indent-line-function) 'nasm-indent-line)
  ;; Stay closer to the old TAB behavior (was tab-to-tab-stop).
  (set (make-local-variable 'tab-always-indent) nil)

  (run-hooks 'nasm-mode-set-comment-hook)
  ;; Make our own local child of nasm-mode-map
  ;; so we can define our own comment character.
  (use-local-map (nconc (make-sparse-keymap) nasm-mode-map))
  (local-set-key (vector nasm-comment-char) 'nasm-comment)
  (set-syntax-table (make-syntax-table nasm-mode-syntax-table))
  (modify-syntax-entry	nasm-comment-char "< b")

  (set (make-local-variable 'comment-start) (string nasm-comment-char))
  (set (make-local-variable 'comment-add) 1)
  (set (make-local-variable 'comment-start-skip)
       "\\(?:\\s<+\\|/[/*]+\\)[ \t]*")
  (set (make-local-variable 'comment-end-skip) "[ \t]*\\(\\s>\\|\\*+/\\)")
  (set (make-local-variable 'comment-end) "")
  (setq fill-prefix "\t"))

(defun nasm-indent-line ()
  "Auto-indent the current line."
  (interactive)
  (let* ((savep (point))
	 (indent (condition-case nil
		     (save-excursion
		       (forward-line 0)
		       (skip-chars-forward " \t")
		       (if (>= (point) savep) (setq savep nil))
		       (max (nasm-calculate-indentation) 0))
		   (error 0))))
    (if savep
	(save-excursion (indent-line-to indent))
      (indent-line-to indent))))

(defun nasm-calculate-indentation ()
  (or
   ;; Flush labels to the left margin.
   (and (looking-at "\\(\\sw\\|\\s_\\)+:") 0)
   ;; Flush directives to halfway
   (and (looking-at "%") 0)
   ;; Same thing for `;;;' comments.
   (and (looking-at "\\s<\\s<\\s<") 0)
   ;; Simple `;' comments go to the comment-column.
   (and (looking-at "\\s<\\(\\S<\\|\\'\\)") comment-column)
   ;; The rest goes at the first tab stop.
   (or (indent-next-tab-stop 0))))

(defun nasm-colon ()
  "Insert a colon; if it follows a label, delete the label's indentation."
  (interactive)
  (let ((labelp nil))
    (save-excursion
      (skip-syntax-backward "w_")
      (skip-syntax-backward " ")
      (if (setq labelp (bolp)) (delete-horizontal-space)))
    (call-interactively 'self-insert-command)
    (when labelp
      (delete-horizontal-space)
      (tab-to-tab-stop))))

;; Obsolete since Emacs-22.1.
(defalias 'nasm-newline 'newline-and-indent)

(defun nasm-comment ()
  "Convert an empty comment to a `larger' kind, or start a new one.
These are the known comment classes:

   1 -- comment to the right of the code (at the comment-column)
   2 -- comment on its own line, indented like code
   3 -- comment on its own line, beginning at the left-most column.

Suggested usage:  while writing your code, trigger nasm-comment
repeatedly until you are satisfied with the kind of comment."
  (interactive)
  (comment-normalize-vars)
  (let (comempty comment)
    (save-excursion
      (beginning-of-line)
      (with-no-warnings
	(setq comment (comment-search-forward (line-end-position) t)))
      (setq comempty (looking-at "[ \t]*$")))

    (cond

     ;; Blank line?  Then start comment at code indent level.
     ;; Just like `comment-dwim'.  -stef
     ((save-excursion (beginning-of-line) (looking-at "^[ \t]*$"))
      (indent-according-to-mode)
      (insert nasm-comment-char nasm-comment-char ?\ ))

     ;; Nonblank line w/o comment => start a comment at comment-column.
     ;; Also: point before the comment => jump inside.
     ((or (null comment) (< (point) comment))
      (indent-for-comment))

     ;; Flush-left or non-empty comment present => just insert character.
     ((or (not comempty) (save-excursion (goto-char comment) (bolp)))
      (insert nasm-comment-char))

     ;; Empty code-level comment => upgrade to next comment level.
     ((save-excursion (goto-char comment) (skip-chars-backward " \t") (bolp))
      (goto-char comment)
      (insert nasm-comment-char)
      (indent-for-comment))

     ;; Empty comment ends non-empty code line => new comment above.
     (t
      (goto-char comment)
      (skip-chars-backward " \t")
      (delete-region (point) (line-end-position))
      (beginning-of-line) (insert "\n") (backward-char)
      (nasm-comment)))))

(provide 'nasm-mode)

;;; nasm-mode.el ends here
