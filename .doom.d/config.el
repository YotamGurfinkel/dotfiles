;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yotam Gurfinkel"
      user-mail-address "yotam706@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-font (font-spec :family "Cascadia Code" :size 16))
(setq doom-theme 'doom-one)
;; (add-hook 'python-mode-hook 'jedi:setup)

(defun my/sql-mode-hook ()
  (setq-local company-backends '(company-dabbrev-code))
  )

(setq +lsp-company-backends '(:separate company-capf :with company-yasnippet company-dabbrev-code))
(set-company-backend! 'sql-mode '(company-dabbrev-code))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
;;(flycheck-add-next-checker 'python-pylint t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(global-set-key (kbd "C->") #'mc/mark-next-like-this)
(global-set-key (kbd "C-<") #'mc/mark-previous-like-this)
(global-set-key (kbd "M-]") #'mc/mmlte--down)
(global-set-key (kbd "M-[") #'mc/mmlte--up)

(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (newline)
  (yank))

(defun rc/add-semicolon ()
  "Add Semicolon at End of Line"
  (interactive)
  (move-end-of-line 1)
  (insert ";"))

(global-set-key (kbd "C-M-;") 'rc/add-semicolon)
(global-set-key (kbd "C-,") 'rc/duplicate-line)


(global-set-key (kbd "C-{") 'evil-shift-left-line)
(global-set-key (kbd "C-}") 'evil-shift-right-line)
(define-key evil-insert-state-map (kbd "C-M-{") 'evil-shift-left)
(define-key evil-insert-state-map (kbd "C-M-}") 'evil-shift-right)

(add-hook! c++-mode-hook 'irony-mode)
(add-hook! c-mode-hook 'irony-mode)
(add-hook! objc-mode-hook 'irony-mode)

(add-hook! irony-mode-hook 'irony-cdb-autosetup-compile-options)
(defun insert-line-below ()
  "Insert an empty line below the current line."
  (interactive)
  (save-excursion
    (end-of-line)
    (open-line 1)))
(defun insert-line-above ()
  "Insert an empty line below the current line."
  (interactive)
  (save-excursion
    (end-of-line 0)
    (open-line 1)))

(global-set-key (kbd "<M-return>") 'insert-line-below)
(global-set-key (kbd "C-j") 'insert-line-above)
;; Maybe for bypassing doom emacs
(define-key evil-insert-state-map (kbd "C-k") 'kill-line)
(define-key evil-insert-state-map (kbd "C--") 'text-scale-decrease)
(define-key evil-insert-state-map (kbd "C-=") 'text-scale-increase)
(define-key evil-insert-state-map (kbd "C-y") 'yank)
(define-key evil-insert-state-map (kbd "C-j") 'insert-line-above)

(use-package! dashboard
  :init      ;; tweak dashboard config before loading it
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  ;;(setq dashboard-startup-banner "~/.config/doom/doom-emacs-dash.png")  ;; use custom image as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 5)
                          (projects . 5)
                          (registers . 5)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents . "file-text")
			            (bookmarks . "book"))))

(use-package! lsp-java :config (add-hook 'java-mode-hook 'lsp))

;; Add keybindings for interacting with Cargo
;(use-package cargo
;  :hook (rust-mode . cargo-minor-mode))

;;(use-package! flycheck-rust
;;  :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
;;
(menu-bar--display-line-numbers-mode-relative)

(after! lsp-mode
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-enable-folding nil)
  (setq lsp-ui-sideline-show-code-actions nil)
  (setq lsp-enable-snippet nil))

(setq rustic-lsp-server 'rust-analyzer)
(setq lsp-rust-server 'rust-analyzer)
