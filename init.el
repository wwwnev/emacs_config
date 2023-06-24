;; Package management
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
             ("org" . "http://orgmode.org/elpa/")
             ("melpa" . "http://melpa.org/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Very important
(cua-mode)

(use-package mood-line
  :config (mood-line-mode))

(setq-default cursor-type 'bar)

(use-package undo-tree
  :config
  (global-undo-tree-mode t)
  :bind
  ("C-z" . 'undo-tree-undo)
  ("C-S-z" . 'undo-tree-redo)
  ("C-y" . 'undo-tree-redo)
  :custom
  (undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (undo-tree-visualizer-timestamps t))

(use-package ialign)

(use-package helm
  :bind
  (("M-x" . helm-M-x)
   ("C-S-o" . helm-buffers-list)
   ("C-f" . helm-occur))
  :bind
  (:map helm-map
        ("TAB" . dabbrev-expand))
  :config
  (setq helm-allow-mouse t)
  (setq helm-case-fold-search t))



;; --------------------------------------------------
;; ESC as power-C-g
(defun keyboard-escape-quit ()
  "Exit the current \"mode\" (in a generalized sense of the word).
   This command can exit an interactive command such as
   `query-replace', can clear out a prefix argument or a region,
   can get out of the minibuffer or other recursive edit, cancel
   the use of the current buffer (for special-purpose buffers),
   or go back to just one window (by deleting all but the
   selected window)."
  (interactive)
  (cond
   ((eq last-command 'mode-exited) nil)
    ((region-active-p)
     (deactivate-mark))
    ((> (minibuffer-depth) 0)
     (abort-recursive-edit))
    (current-prefix-arg
     nil)
    ((> (recursion-depth) 0)
     (exit-recursive-edit))
    (buffer-quit-function
     (funcall buffer-quit-function))
    ((string-match "^ \\*" (buffer-name (current-buffer)))
     (bury-buffer))))
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)


;; =================
;; Global key bindings
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-w") 'kill-buffer)
(global-set-key (kbd "C-o") 'find-file)

(use-package multiple-cursors
  :config
  (advice-add #'cua-copy-region
              :around (lambda (oldfn &rest args)
                        (if (> (mc/num-cursors) 1)
                            (kill-ring-save 0 0 t)
                          (apply oldfn args))))
  :bind
  (("C-S-n" . mc/mark-next-like-this)
   ("C-S-M-n" . mc/skip-to-next-like-this)
   ("C-S-b" . mc/unmark-previous-like-this)
   ("C-S-M-b" . mc/skip-to-previous-like-this)
   ("C-s-n" . 316k/mc-mark-variable-in-fun)
   :map mc/keymap
   ("<return>" . nil)
   ("M-x" . snippins/helm-M-x)
   ; ("C-c" . nil)
   ))


(use-package visual-regexp)
(use-package visual-regexp-steroids)

(use-package 2048-game)

;; Python stuff
(setq python-shell-interpreter "python3")
(setq-default indent-tabs-mode nil)
;;(setq-default tab-width 2)
(setq python-indent-offset 2)

;; Org stuff
(setq org-image-actual-width nil)

;; Theme
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t ; if nil, is universally disabled
        doom-themes-enable-italics t) ; if nil, ...
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))
