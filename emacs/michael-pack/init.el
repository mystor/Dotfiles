;; User pack init file
;;
;; Use this file to initiate the pack configuration.
;; See README for more information.

; (setq js2-missing-semi-one-line-override t)
(setq-default js2-basic-offset 2) ; 2 spaces for indentation

;; un-break haskell-mode
(require 'haskell-session)
(require 'haskell-indentation)

;; esc quits
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
  In Delete Selection mode, if the mark is active, just deactivate it;
  then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
	(setq deactivate-mark t)
	(when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
	(abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

(live-add-pack-lib "go-mode")
(require 'go-mode)
