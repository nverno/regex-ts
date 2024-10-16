;;; regex-ts.el --- Tree-sitter support for regexps -*- lexical-binding: t; -*-

;; Author: Noah Peart <noah.v.peart@gmail.com>
;; URL: https://github.com/nverno/regex-ts-mode
;; Version: 0.0.1
;; Package-Requires: ((emacs "29.1"))
;; Created:  6 October 2023
;; Keywords: languages tree-sitter regex regexp

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Tree-sitter font-lock support for regular expressions.
;;
;; This mode is compatible with the tree-sitter parser found at
;; https://github.com/tree-sitter/tree-sitter-regex.
;;
;;; Code:

(eval-when-compile (require 'cl-lib))
(require 'treesit)

(defface regex-ts-operator-face
  '((t (:inherit font-lock-operator-face)))
  "Face to highlight regex operators."
  :group 'font-lock-highlighting-faces)

(defface regex-ts-bracket-face
  '((t (:inherit font-lock-regexp-face)))
  "Face to highlight regex brackets around character classes/ranges."
  :group 'font-lock-highlighting-faces)

(defface regex-ts-range-face
  '((t (:inherit font-lock-type-face :slant italic)))
  "Face to hightlight regex character ranges."
  :group 'font-lock-highlighting-faces)

(defface regex-ts-character-class-face
  '((t (:inherit font-lock-type-face)))
  "Face to highlight characters in regex character classes."
  :group 'font-lock-highlighting-faces)

(defface regex-ts-escape-face
  '((t (:inherit font-lock-escape-face)))
  "Face to highlight regex escape sequences."
  :group 'font-lock-highlighting-faces)

(defface regex-ts-count-face
  '((t (:inherit font-lock-regexp-face :slant italic)))
  "Face to highlight regex count groups."
  :group 'font-lock-highlighting-faces)

(defvar regex-ts-font-lock-feature-list
  '(( pattern)
    ( grouping operator)
    ( escape-sequence char-class)
    ( )) ;; error
  "`treesit-font-lock-feature-list' for `regex-ts-mode'.")

(defun regex-ts--fontify-identity-escape (node override &rest _)
  "Fontify identity escape NODE with FACE using OVERRIDE."
  (let ((beg (treesit-node-start node))
        (end (treesit-node-end node)))
    (treesit-fontify-with-override beg end 'font-lock-regexp-face override)))

(defun regex-ts-font-lock-rules (&optional override)
  "Create tree-sitter font-lock rules for regexps with OVERRIDE."
  (treesit-font-lock-rules
   :language 'regex
   :feature 'pattern
   :override override
   '([(pattern_character)] @font-lock-regexp-face)

   :language 'regex
   :feature 'char-class
   :override override
   '((character_class "^" @font-lock-negation-char-face)
     (character_class (identity_escape) @regex-ts-character-class-face)
     (class_character) @regex-ts-character-class-face
     (class_range) @regex-ts-range-face
     (count_quantifier) @regex-ts-count-face)

   :language 'regex
   :feature 'operator
   :override override
   '(["*" "+" "?" (any_character) (lazy)] @regex-ts-operator-face)

   :language 'regex
   :feature 'grouping
   :override override
   '(["|" "=" "(" "(?" "(?:" ")" "(?<" ">"] @font-lock-regexp-grouping-construct
     ["!"] @font-lock-negation-char-face
     (group_name) @font-lock-property-name-face
     ["[" "]"] @regex-ts-bracket-face)

   :language 'regex
   :feature 'escape-sequence
   :override override
   '([(control_letter_escape)
      (character_class_escape)
      (control_escape)
      (start_assertion)
      (end_assertion)
      (boundary_assertion)
      (non_boundary_assertion)]
     @regex-ts-escape-face
     (identity_escape) @regex-ts--fontify-identity-escape)))

;;; Major mode

(defvar regex-ts-mode-syntax-table
  (let ((table (make-syntax-table)))
    (cl-loop for c across ".^$|,"
             do (modify-syntax-entry c "." table))
    (cl-loop for c across "*+?"
             do (modify-syntax-entry c "_" table))
    (cl-loop for c across "@_&#%`~'\"/:;"
             do (modify-syntax-entry c "w" table))
    (modify-syntax-entry ?- "." table)
    table)
  "Regex syntax table.")

;;;###autoload
(define-derived-mode regex-ts-mode prog-mode "Regex"
  "Major mode for regular expressions."
  :group 'regex
  :syntax-table regex-ts-mode-syntax-table
  (when (treesit-ready-p 'regex)
    (treesit-parser-create 'regex)
    (setq-local treesit-font-lock-settings (regex-ts-font-lock-rules))
    (setq-local treesit-font-lock-feature-list regex-ts-font-lock-feature-list)
    (treesit-major-mode-setup)))

(when (treesit-ready-p 'regex)
  (add-to-list 'auto-mode-alist '("\\.regex\\'" . regex-ts-mode)))

(provide 'regex-ts)
;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
;;; regex-ts.el ends here
