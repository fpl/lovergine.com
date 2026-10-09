;;;
;;; reader/highlight.scm -- Syntax highlighting of fenced code blocks
;;;
;;; Copyright © 2026 Francesco P Lovergine <pobox@lovergine.com>
;;;
;;; This is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; This is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this software. If not, see <http://www.gnu.org/licenses/>.

;;
;; Maps the language of a fenced code block (```bash, ```scheme, ...) to a
;; guile-syntax-highlight lexer.  guile-syntax-highlight has no shell
;; lexer, so a small one is provided here.
;;

(define-module (reader highlight)
  #:use-module (syntax-highlight)
  #:use-module (syntax-highlight lexers)
  #:use-module (syntax-highlight scheme)
  #:use-module (syntax-highlight xml)
  #:use-module (syntax-highlight c)
  #:use-module (srfi srfi-1)
  #:export (lex-shell
            language->lexer
            highlight-source))

;;; Shell lexer.  Not a real parser: it only has to tell comments,
;;; strings, variables, options, operators and keywords from plain words.

(define %shell-keywords
  '("if" "then" "elif" "else" "fi" "for" "while" "until" "do" "done"
    "case" "esac" "in" "function" "select" "time"))

;; Characters that end a bare word.  A `#' is only a comment at the start
;; of a token, so it is deliberately not here: `a#b' is a single word.
(define %word-rx
  "([^ \t\n\"'$|&;<>()\\\\]|\\\\.)+")

(define lex-shell-word
  (lex-regexp %word-rx))

(define lex-shell-keyword
  (lex-filter (lambda (str) (member str %shell-keywords))
              lex-shell-word))

(define lex-shell-option
  (lex-regexp "--?[A-Za-z0-9][A-Za-z0-9_-]*"))

(define lex-shell-variable
  (lex-any (lex-regexp "\\$\\{[^}\n]*\\}")
           (lex-regexp "\\$\\([^)\n]*\\)")
           (lex-regexp "\\$[A-Za-z_][A-Za-z0-9_]*")
           (lex-regexp "\\$[0-9#?@!$*-]")))

(define lex-shell-string
  (lex-any (lex-regexp "'[^']*'")
           (lex-regexp "\"([^\"\\\\]|\\\\.)*\"")))

(define lex-shell-operator
  ;; The group matters: lex-regexp only anchors the first alternative.
  (lex-regexp "([0-9]?(>>|>&[0-9-]?|>|<<|<)|&&|\\|\\||[|&;()])"))

(define lex-shell
  (lex-consume
   (lex-any (lex-char-set char-set:whitespace)
            (lex-tag 'comment (lex-delimited "#" #:until "\n"))
            (lex-tag 'string lex-shell-string)
            (lex-tag 'variable lex-shell-variable)
            (lex-tag 'attribute lex-shell-option)
            (lex-tag 'keyword lex-shell-keyword)
            (lex-tag 'special lex-shell-operator)
            lex-shell-word
            ;; Catch-all: lex-consume dumps everything after the first
            ;; unlexable character as plain text, so never fail.  (Not
            ;; lex-char-set #:max 1, which returns the rest of the input.)
            (lex-char char-set:full))))

;;; Language dispatch.

(define %lexers
  `(("sh"     . ,lex-shell)
    ("bash"   . ,lex-shell)
    ("shell"  . ,lex-shell)
    ("zsh"    . ,lex-shell)
    ("console" . ,lex-shell)
    ("scheme" . ,lex-scheme)
    ("guile"  . ,lex-scheme)
    ("guix"   . ,lex-scheme)
    ("lisp"   . ,lex-scheme)
    ("xml"    . ,lex-xml)
    ("html"   . ,lex-xml)
    ("c"      . ,lex-c)))

(define (language->lexer lang)
  "Return the lexer for the language name LANG, or #f if unsupported."
  (and=> (assoc lang %lexers) cdr))

(define (highlight-source lang source)
  "Return a list of SXML nodes for SOURCE highlighted as LANG, or #f if LANG
has no lexer."
  (let ((lexer (language->lexer lang)))
    (and lexer
         (highlights->sxml (highlight lexer source)))))
