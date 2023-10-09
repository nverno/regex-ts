## Tree-sitter support for regex

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This package is compatible with and was tested against the tree-sitter grammar
for regex found at https://github.com/tree-sitter/tree-sitter-regex.

It provides font-locking support for regex.

## Installing

Emacs 29.1 or above with tree-sitter support is required. 

Tree-sitter starter guide: https://git.savannah.gnu.org/cgit/emacs.git/tree/admin/notes/tree-sitter/starter-guide?h=emacs-29

### Install tree-sitter regex parser

Add the source to `treesit-language-source-alist`. 

```elisp
(add-to-list
 'treesit-language-source-alist
 '(regex "https://github.com/tree-sitter/tree-sitter-regex"))
```

Then run `M-x treesit-install-language-grammar` and select `regex` to install.

### To install regex-ts.el from source

- Clone this repository
- Add the following to your emacs config

```elisp
(require "[cloned nverno/regex-ts]/regex-ts.el")
```

### Troubleshooting

If you get the following warning:

```
⛔ Warning (treesit): Cannot activate tree-sitter, because tree-sitter
library is not compiled with Emacs [2 times]
```

Then you do not have tree-sitter support for your emacs installation.

If you get the following warnings:
```
⛔ Warning (treesit): Cannot activate tree-sitter, because language grammar for regex is unavailable (not-found): (libtree-sitter-regex libtree-sitter-regex.so) No such file or directory
```

then the regex grammar files are not properly installed on your system.
