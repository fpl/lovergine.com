;;;
;;; reader/commonmark.scm -- Reader to generate sxml document from commonmark
;;;
;;; Copyright © 2025 Francesco P Lovergine <pobox@lovergine.com>
;;;
;;; This is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; This is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this software. If not, see <http://www.gnu.org/licenses/>.

;;
;; CommonMark post reader with external link processing in order to
;; add some attributes automagically.
;;

(define-module (reader commonmark)
  #:use-module (commonmark)
  #:use-module (haunt post)
  #:use-module (haunt reader)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-1)
  #:export (commonmark-reader*))

(define (external-link? href)
  "Return #t if HREF is an external link (starts with http:// or https://)."
  (and (string? href)
       (or (string-prefix? "http://" href)
           (string-prefix? "https://" href))))

(define (get-href attrs)
  "Extract the href string from SXML attributes.
ATTRS is a list like ((href \"https://...\") (class \"foo\")).
Returns the href value as a string, or #f if not found."
  (let ((href-pair (assq 'href attrs)))
    (and href-pair
         (pair? (cdr href-pair))
         (cadr href-pair))))

(define (add-external-link-attrs attrs)
  "Add target=\"_blank\" and rel=\"noopener noreferrer\" to ATTRS."
  (let ((filtered (filter (lambda (attr)
                            (not (memq (car attr) '(target rel))))
                          attrs)))
    (append filtered
            '((target "_blank")
              (rel "noopener noreferrer")))))

(define (text->id-slug text)
  "Convert TEXT to a URL-safe ID slug.
Converts to lowercase, replaces spaces and special characters with hyphens,
and removes consecutive hyphens."
  (let* ((lower (string-downcase text))
         ;; Replace spaces and common punctuation with hyphens
         (with-hyphens (string-map (lambda (c)
                                     (if (or (char-alphabetic? c)
                                             (char-numeric? c))
                                         c
                                         #\-))
                                   lower))
         ;; Remove consecutive hyphens
         (cleaned (regexp-substitute/global #f "-+" with-hyphens 'pre "-" 'post))
         ;; Trim leading/trailing hyphens
         (trimmed (string-trim-both cleaned #\-)))
    trimmed))

(define (extract-heading-text sxml)
  "Extract plain text from heading SXML content."
  (match sxml
    ((? string? str) str)
    (((? symbol? _) . rest)
     (string-join (map extract-heading-text rest) " "))
    ((? list? lst)
     (string-join (map extract-heading-text lst) " "))
    (_ "")))

(define (add-heading-id attrs body)
  "Add an id attribute based on the heading text content."
  (let ((text (extract-heading-text body)))
    (cons `(id ,(text->id-slug text)) attrs)))

(define (transform-sxml sxml)
  "Transform SXML tree, applying various enhancements:
- Add target=\"_blank\" and rel attributes to external links
- Add id attributes to heading elements for anchor linking."
  (match sxml
    ;; Anchor tag with attributes
    (('a ('@ . attrs) . body)
     (let ((href (get-href attrs)))
       (if (and href (external-link? href))
           `(a (@ ,@(add-external-link-attrs attrs))
               ,@(map transform-sxml body))
           `(a (@ ,@attrs)
               ,@(map transform-sxml body)))))
    
    ;; Anchor tag without attributes (shouldn't happen for links, but handle it)
    (('a . body)
     `(a ,@(map transform-sxml body)))
    
    ;; Heading with attributes
    (((and (? symbol? tag) (or 'h1 'h2 'h3 'h4 'h5 'h6)) ('@ . attrs) . body)
     `(,tag (@ ,@(add-heading-id attrs body))
            ,@(map transform-sxml body)))
    
    ;; Heading without attributes
    (((and (? symbol? tag) (or 'h1 'h2 'h3 'h4 'h5 'h6)) . body)
     `(,tag (@ ,@(add-heading-id '() body))
            ,@(map transform-sxml body)))
    
    ;; Any other element with attributes
    (((? symbol? tag) ('@ . attrs) . body)
     `(,tag (@ ,@attrs) ,@(map transform-sxml body)))
    
    ;; Any other element without attributes
    (((? symbol? tag) . body)
     `(,tag ,@(map transform-sxml body)))
    
    ;; List of nodes (but not an element)
    ((? list? lst)
     (map transform-sxml lst))
    
    ;; Atoms (strings, numbers, etc.)
    (atom atom)))

(define commonmark-reader*
  (make-reader (make-file-extension-matcher "md")
               (lambda (file)
                 (call-with-input-file file
                   (lambda (port)
                     (values (read-metadata-headers port)
                             (transform-sxml
                              (commonmark->sxml port))))))))
