;;; ~/.config/doom/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(require 'mozc)
(setq default-input-method "japanese-mozc")
(setq mozc-candidate-style 'overlay)

;; other settings
(setq ring-bell-function 'ignore)

(delete-selection-mode t)

(if (fboundp 'pc-selection-mode)
    (pc-selection-mode))

(setq kill-whole-line t)

(setq kill-read-only-ok t)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(setq auto-image-file-mode t)

(set-default-font "Noto Serif CJK JP")
