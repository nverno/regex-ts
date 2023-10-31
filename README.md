## Tree-sitter support for regex

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This package is compatible with and was tested against the tree-sitter grammar
for regex found at [tree-sitter-regex](https://github.com/tree-sitter/tree-sitter-regex.)

It provides font-locking support for regex, but is intended to be used as an
embedded parser in other languages.

## Installing

Emacs 29.1 or above with tree-sitter support is required. 

### Install tree-sitter parser

Add the source to `treesit-language-source-alist` and run 
`treesit-install-language-grammar`.

```elisp
(let ((treesit-language-source-alist
       '((regex "https://github.com/tree-sitter/tree-sitter-regex"))))
  (treesit-install-language-grammar 'regex))
```
