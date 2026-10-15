;;; lovergine.com --- ikiwiki-compatible wiki for Haunt
;;; Copyright © 2026 Francesco P Lovergine <pobox@lovergine.com>
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU General Public License as
;;; published by the Free Software Foundation; either version 3 of the
;;; License, or (at your option) any later version.

;;; Commentary:
;;
;; A wiki builder for Haunt that understands (a useful subset of) the
;; ikiwiki page syntax: Markdown files with the .mdwn extension,
;; [[WikiLinks]] and [[!directives]].
;;
;; Supported syntax:
;;
;;   [[page]]  [[text|page]]  [[page#anchor]]  [[/absolute/page]]
;;   [[text|https://example.org]]   \[[escaped]]
;;   [[!meta title="..." author="..." date="..." updated="..."
;;           description="..."]]
;;   [[!tag foo bar]]   [[!taglink foo]]  [[!taglink text|foo]]
;;   [[!img pic.png alt="..." title="..."]]
;;   [[!toc levels=2]]
;;   [[!map pages="glob or tagged(foo)"]]
;;
;; Link resolution follows ikiwiki's "bestlink" rules: from page
;; a/b, a link to "c" tries a/b/c, then a/c, then c; exact matches
;; win over case-insensitive ones.  Missing targets are rendered as
;; <span class="createlink">.  Output uses ikiwiki's "usedirs"
;; layout: page foo/bar becomes PREFIX/foo/bar/index.html.  Every page
;; gets parent links, backlinks, tags and a "last edited" line; tag
;; pages are generated under TAG-BASE unless a real page exists there.
;; Non-page files in the wiki directory are copied verbatim.
;;
;; Wiki syntax is rewritten into plain Markdown before handing the
;; text to guile-commonmark, because the latter supports neither raw
;; HTML nor any extension hook: links become [text](wiki:target)
;; and block directives become placeholder paragraphs, both resolved
;; by the builder once the whole page set is known.  Fenced and
;; indented code blocks and `code spans` are left untouched.
;;
;;; Code:

(define-module (lovergine wiki)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 textual-ports)
  #:use-module (rnrs bytevectors)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-11)
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-26)
  #:use-module (web uri)
  #:use-module (commonmark)
  #:use-module (haunt artifact)
  #:use-module (haunt html)
  #:use-module (haunt reader)
  #:use-module (haunt site)
  #:use-module (haunt utils)
  #:use-module (reader highlight)
  #:use-module ((haunt builder blog)
                #:select ((theme . blog-theme)
                          with-layout
                          (date->string* . blog-date->string)))
  #:export (ikiwiki-preprocess
            ikiwiki-reader
            pagetitle
            default-wiki-template
            wiki))


;;;
;;; Small helpers
;;;

(define (at? s i prefix)
  "Return #t if string S contains PREFIX at index I."
  (let ((n (string-length prefix)))
    (and (<= (+ i n) (string-length s))
         (string=? prefix (substring s i (+ i n))))))

(define (warn fmt . args)
  (apply format (current-error-port) (string-append "wiki: " fmt "~%") args))

(define (intersperse sep lst)
  (match lst
    ((or () (_)) lst)
    ((x . rest) (cons* x sep (intersperse sep rest)))))

(define (pagetitle name)
  "Turn a page (base)name into a human title, like ikiwiki:
underscores become spaces and __NN__ becomes the character NN."
  (string-map (lambda (c) (if (char=? c #\_) #\space c))
              (regexp-substitute/global
               #f "__([0-9]+)__" name
               'pre
               (lambda (m)
                 (string (integer->char
                          (string->number (match:substring m 1)))))
               'post)))

(define (normalize-link link)
  "ikiwiki's linkpage: trim and turn spaces into underscores."
  (string-map (lambda (c) (if (char=? c #\space) #\_ c))
              (string-trim-both link)))

(define char-set:wiki-target
  (string->char-set
   "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~/#"))

(define (encode-target str)
  "Percent-encode STR so that it is a valid Markdown link destination."
  (call-with-output-string
    (lambda (port)
      (string-for-each
       (lambda (c)
         (if (char-set-contains? char-set:wiki-target c)
             (write-char c port)
             (for-each (lambda (b)
                         (display (if (< b 16) "%0" "%") port)
                         (display (string-upcase (number->string b 16)) port))
                       (bytevector->u8-list (string->utf8 (string c))))))
       str))))

(define (encode-url str)
  "Escape the few characters that cannot appear in a Markdown link
destination, leaving the URL otherwise intact."
  (call-with-output-string
    (lambda (port)
      (string-for-each
       (lambda (c)
         (case c
           ((#\space) (display "%20" port))
           ((#\() (display "%28" port))
           ((#\)) (display "%29" port))
           ((#\<) (display "%3C" port))
           ((#\>) (display "%3E" port))
           (else (write-char c port))))
       str))))

(define (md-escape str)
  "Backslash-escape Markdown punctuation in STR."
  (call-with-output-string
    (lambda (port)
      (string-for-each
       (lambda (c)
         (when (memv c '(#\\ #\` #\* #\_ #\[ #\] #\< #\> #\!))
           (write-char #\\ port))
         (write-char c port))
       str))))

(define (parse-date str)
  (or (any (lambda (fmt) (false-if-exception (string->date str fmt)))
           '("~Y-~m-~d ~H:~M:~S" "~Y-~m-~dT~H:~M:~S" "~Y-~m-~d ~H:~M"
             "~Y-~m-~d"))
      (begin (warn "unparseable date '~a'" str) #f)))


;;;
;;; Directive parameters: key="value" key="""value""" key=value "value" value
;;;

(define char-set:param-key
  (char-set-union char-set:letter+digit (string->char-set "-._")))

(define (parse-params str)
  "Parse ikiwiki directive parameters in STR into an alist of
(KEY . VALUE) pairs; KEY is #f for positional parameters."
  (define len (string-length str))
  (define (skip-ws i)
    (if (and (< i len) (char-whitespace? (string-ref str i)))
        (skip-ws (1+ i))
        i))
  (define (read-key i)
    (let loop ((j i))
      (cond
       ((and (< j len) (char-set-contains? char-set:param-key (string-ref str j)))
        (loop (1+ j)))
       ((and (> j i) (< j len) (char=? (string-ref str j) #\=))
        (values (substring str i j) (1+ j)))
       (else (values #f i)))))
  (define (read-value i)
    (cond
     ((at? str i "\"\"\"")
      (let ((end (string-contains str "\"\"\"" (+ i 3))))
        (if end
            (values (substring str (+ i 3) end) (+ end 3))
            (values (substring str (+ i 3)) len))))
     ((at? str i "\"")
      (let ((end (string-index str #\" (1+ i))))
        (if end
            (values (substring str (1+ i) end) (1+ end))
            (values (substring str (1+ i)) len))))
     (else
      (let ((end (or (string-index str char-set:whitespace i) len)))
        (values (substring str i end) end)))))
  (let loop ((i (skip-ws 0)) (acc '()))
    (if (>= i len)
        (reverse acc)
        (let*-values (((key j) (read-key i))
                      ((val k) (read-value j)))
          (loop (skip-ws k) (cons (cons key val) acc))))))

(define (param params key)
  (assoc-ref params key))

(define (positional params)
  (filter-map (match-lambda ((#f . v) v) (_ #f)) params))

(define (find-directive-end s i)
  "Return the index of the ']]' closing a directive whose parameters
start at I, honouring quoted values, or #f."
  (let ((len (string-length s)))
    (let loop ((i i))
      (cond
       ((>= i len) #f)
       ((at? s i "\"\"\"")
        (let ((end (string-contains s "\"\"\"" (+ i 3))))
          (and end (loop (+ end 3)))))
       ((char=? (string-ref s i) #\")
        (let ((end (string-index s #\" (1+ i))))
          (and end (loop (1+ end)))))
       ((at? s i "]]") i)
       (else (loop (1+ i)))))))


;;;
;;; Splitting a page into code and prose
;;;

(define %fence-rx (make-regexp "^[ \t]*(```+|~~~+)"))
(define %list-item-rx (make-regexp "^ *([-*+]|[0-9]+[.)])( +|$)"))

(define (blank? line) (string-every char-whitespace? line))

(define (indentation line)
  "Width of the leading whitespace of LINE, counting tabs as 4."
  (let loop ((i 0) (width 0))
    (if (< i (string-length line))
        (case (string-ref line i)
          ((#\space) (loop (1+ i) (1+ width)))
          ((#\tab) (loop (1+ i) (+ width 4)))
          (else width))
        width)))

(define (list-content-indent m)
  "Column where the content of the list item matched by M starts."
  (let ((spaces (string-length (match:substring m 2))))
    (if (<= 1 spaces 4)
        (match:end m 0)
        (1+ (match:end m 1)))))

(define (split-code text)
  "Split TEXT into a list of (CODE? . STRING) segments, where code
segments are fenced or indented code blocks."
  (define segments '())
  (define current '())
  (define current-code? #f)
  (define (emit! code? line)
    (unless (eq? code? current-code?)
      (unless (null? current)
        (set! segments (cons (cons current-code? (reverse current)) segments)))
      (set! current '())
      (set! current-code? code?))
    (set! current (cons line current)))
  ;; LIST-INDENT is the content column of the innermost open list
  ;; item, or #f outside lists; an indented code block inside a list
  ;; must be indented 4 columns past it.
  (let loop ((lines (string-split text #\newline))
             (fence #f)                 ; open fence marker or #f
             (prev-blank? #t)
             (list-indent #f)
             (in-indented? #f))
    (match lines
      (()
       (unless (null? current)
         (set! segments (cons (cons current-code? (reverse current)) segments)))
       (reverse
        (map (match-lambda ((code? . ls) (cons code? (string-join ls "\n"))))
             segments)))
      ((line . rest)
       (let ((m (regexp-exec %fence-rx line))
             (indent (indentation line)))
         (cond
          (fence
           (emit! #t line)
           (if (and m (string-prefix? fence (match:substring m 1))
                    (blank? (match:suffix m)))
               (loop rest #f #f list-indent #f)
               (loop rest fence #f list-indent #f)))
          (m
           (emit! #t line)
           (loop rest (match:substring m 1) #f list-indent #f))
          ((blank? line)
           (emit! in-indented? line)
           (loop rest #f #t list-indent in-indented?))
          ((and (>= indent (+ (or list-indent 0) 4))
                (or in-indented? prev-blank?))
           (emit! #t line)
           (loop rest #f #f list-indent #t))
          ((regexp-exec %list-item-rx line)
           => (lambda (li)
                (emit! #f line)
                (loop rest #f #f (list-content-indent li) #f)))
          (else
           (emit! #f line)
           (loop rest #f #f
                 (and list-indent
                      (or (not prev-blank?) (>= indent list-indent))
                      list-indent)
                 #f))))))))


;;;
;;; Preprocessor: ikiwiki syntax -> CommonMark + metadata
;;;

(define %external-rx (make-regexp "^([a-zA-Z][a-zA-Z0-9+.-]*://|mailto:)"))

(define (ikiwiki-preprocess text)
  "Rewrite the ikiwiki markup in TEXT into CommonMark.  Return two
values: the Markdown string and a metadata alist."
  (define meta '())
  (define tags '())
  (define links '())
  (define directives '())
  (define counter 0)

  (define (add-meta! key value)
    (set! meta (alist-cons key value (alist-delete key meta))))

  (define (add-link! target)
    (unless (or (string-null? target) (member target links))
      (set! links (cons target links))))

  (define (add-tag! tag)
    (unless (member tag tags)
      (set! tags (append tags (list tag)))))

  (define (wikilink text target)
    ;; TEXT is #f when the link had no explicit label.
    (let* ((target (string-trim-both target))
           (hash (string-index target #\#))
           (page (normalize-link (if hash (substring target 0 hash) target)))
           (anchor (if hash (substring target hash) "")))
      (cond
       ((regexp-exec %external-rx target)
        (string-append "[" (or text (md-escape target)) "]("
                       (encode-url target) ")"))
       (else
        (add-link! page)
        (string-append "["
                       (or text (md-escape (pagetitle (basename page))))
                       "](wiki:" (encode-target (string-append page anchor))
                       ")")))))

  (define (placeholder! name params)
    (set! counter (1+ counter))
    (set! directives (alist-cons counter (cons name params) directives))
    (format #f "\n\nwikidirective-~a\n\n" counter))

  (define (directive name params raw)
    (match name
      ("meta"
       (for-each
        (match-lambda
          ((#f . _) #t)
          ((key . value)
           (let ((sym (string->symbol key)))
             (case sym
               ((date updated)
                (let ((d (parse-date value))) (when d (add-meta! sym d))))
               ((link) (add-link! (normalize-link value)))
               ((tag) (add-tag! value))
               (else (add-meta! sym value))))))
        params)
       "")
      ("tag"
       (for-each add-tag! (positional params))
       "")
      ("taglink"
       (string-join
        (map (lambda (spec)
               (match (string-split spec #\|)
                 ((tag) (add-tag! tag)
                  (string-append "[" (md-escape tag) "](wikitag:"
                                 (encode-target tag) ")"))
                 ((label tag . _) (add-tag! tag)
                  (string-append "[" label "](wikitag:"
                                 (encode-target tag) ")"))))
             (positional params))
        " "))
      ("img"
       (match (positional params)
         ((file . _)
          (string-append "![" (md-escape (or (param params "alt") ""))
                         "](wiki:" (encode-target (normalize-link file))
                         (match (param params "title")
                           (#f "")
                           (t (string-append " \""
                                             (string-delete #\" t) "\"")))
                         ")"))
         (() (warn "img directive without a file name") "")))
      ((or "toc" "map")
       (placeholder! name params))
      (_
       (warn "unsupported directive ~s, rendered literally" name)
       (md-escape raw))))

  (define (transform s)
    (let ((len (string-length s))
          (out (open-output-string)))
      (let loop ((i 0))
        (cond
         ((>= i len) #t)
         ;; Inline code span: copy verbatim.
         ((char=? (string-ref s i) #\`)
          (let* ((j (or (string-skip s #\` i) len))
                 (ticks (substring s i j))
                 (end (let find ((k j))
                        (let ((p (string-contains s ticks k)))
                          (cond
                           ((not p) #f)
                           ;; must be a run of exactly the same length
                           ((and (< (+ p (string-length ticks)) len)
                                 (char=? (string-ref s (+ p (string-length ticks)))
                                         #\`))
                            (find (or (string-skip s #\` p) len)))
                           (else p))))))
            (if end
                (let ((stop (+ end (string-length ticks))))
                  (display (substring s i stop) out)
                  (loop stop))
                (begin (display ticks out) (loop j)))))
         ;; Escaped link or directive: \[[...]] stays literal.
         ((at? s i "\\[[")
          (display "\\[" out)
          (loop (+ i 2)))
         ;; Directive.
         ((at? s i "[[!")
          (let* ((name-end (or (string-skip s char-set:param-key (+ i 3)) len))
                 (name (substring s (+ i 3) name-end))
                 (end (and (not (string-null? name))
                           (find-directive-end s name-end))))
            (if end
                (begin
                  (display (directive name
                                      (parse-params (substring s name-end end))
                                      (substring s i (+ end 2)))
                           out)
                  (loop (+ end 2)))
                (begin (display "\\[" out) (loop (1+ i))))))
         ;; WikiLink.
         ((at? s i "[[")
          (let* ((end (string-contains s "]]" (+ i 2)))
                 (body (and end (substring s (+ i 2) end))))
            (if (and body
                     (not (string-null? (string-trim-both body)))
                     (not (string-index body (char-set #\newline #\[ #\]))))
                (let ((bar (string-index body #\|)))
                  (display (if bar
                               (wikilink (substring body 0 bar)
                                         (substring body (1+ bar)))
                               (wikilink #f body))
                           out)
                  (loop (+ end 2)))
                (begin (display "[" out) (loop (1+ i))))))
         (else
          (write-char (string-ref s i) out)
          (loop (1+ i)))))
      (get-output-string out)))

  (let ((markdown
         (string-join (map (match-lambda
                             ((#t . code) code)
                             ((#f . prose) (transform prose)))
                           (split-code text))
                      "\n")))
    (values markdown
            (append meta
                    `((tags . ,tags)
                      (wiki-links . ,(reverse links))
                      (wiki-directives . ,(reverse directives)))))))

(define ikiwiki-reader
  (make-reader (make-file-extension-matcher "mdwn")
               (lambda (file-name)
                 (let ((text (call-with-input-file file-name get-string-all)))
                   (let-values (((markdown metadata) (ikiwiki-preprocess text)))
                     (values metadata (commonmark->sxml markdown)))))))


;;;
;;; SXML utilities
;;;

(define (sxml-text node)
  (match node
    ((? string? s) s)
    (((? symbol?) ('@ . _) . body) (string-concatenate (map sxml-text body)))
    (((? symbol?) . body) (string-concatenate (map sxml-text body)))
    ((? list? nodes) (string-concatenate (map sxml-text nodes)))
    (_ "")))

(define (sxml-map proc tree)
  "Rebuild TREE bottom-up, calling (PROC TAG ATTRS BODY) on each
element; PROC returns the replacement node."
  (match tree
    (((? symbol? tag) ('@ . attrs) . body)
     (proc tag attrs (map (cut sxml-map proc <>) body)))
    (((? symbol? tag) . body)
     (proc tag '() (map (cut sxml-map proc <>) body)))
    ((? list? nodes) (map (cut sxml-map proc <>) nodes))
    (x x)))

(define (element tag attrs body)
  (if (null? attrs) `(,tag ,@body) `(,tag (@ ,@attrs) ,@body)))

(define (attr-ref attrs key)
  (match (assq key attrs) ((_ value) value) (_ #f)))

(define (attr-set attrs key value)
  (cons (list key value) (remove (lambda (a) (eq? (car a) key)) attrs)))

(define (slugify str)
  (let ((s (string-join (remove string-null?
                                (string-split (string-downcase str)
                                              (lambda (c)
                                                (not (or (char-alphabetic? c)
                                                         (char-numeric? c))))))
                        "-")))
    (if (string-null? s) "section" s)))


;;;
;;; Builder
;;;

(define-record-type <wiki-page>
  (make-wiki-page name source metadata sxml)
  wiki-page?
  (name wiki-page-name)
  (source wiki-page-source)
  (metadata wiki-page-metadata)
  (sxml wiki-page-sxml))

(define (page-ref page key)
  (assq-ref (wiki-page-metadata page) key))

(define (parent-name name)
  (let ((i (string-rindex name #\/)))
    (if i (substring name 0 i) "")))

(define (scan-directory directory keep?)
  "Return the file names under DIRECTORY, relative to it, skipping
anything (including directories) rejected by KEEP?."
  (define prefix-length (1+ (string-length directory)))
  (file-system-fold (lambda (dir stat acc)
                      (or (string=? dir directory) (keep? dir)))
                    (lambda (file stat acc)
                      (if (keep? file)
                          (cons (substring file prefix-length) acc)
                          acc))
                    (lambda (dir stat acc) acc)
                    (lambda (dir stat acc) acc)
                    (lambda (dir stat acc) acc)
                    (lambda (file stat errno acc)
                      (error "wiki directory scanning failed" file errno))
                    '()
                    directory))

(define (source->page-name rel)
  (let* ((ext (file-extension rel))
         (base (string-drop-right rel (1+ (string-length ext)))))
    (cond
     ((string=? base "index") "index")
     ((string-suffix? "/index" base) (string-drop-right base 6))
     (else base))))

(define (git-timestamp file)
  (false-if-exception
   (let* ((port (open-pipe* OPEN_READ "git" "log" "-1" "--format=%ct"
                            "--" file))
          (line (read-line port)))
     (close-pipe port)
     (and (string? line) (string->number line)))))

(define (glob->regexp glob)
  (make-regexp
   (string-append
    "^"
    (string-concatenate
     (map (lambda (c)
            (case c
              ((#\*) ".*")
              ((#\?) ".")
              (else (regexp-quote (string c)))))
          (string->list glob)))
    "$")
   regexp/icase))

(define (pagespec->predicate spec tags-of)
  "Compile a (very) small subset of ikiwiki PageSpecs: globs and
tagged(TAG), combined with 'or'."
  (let ((terms (map (lambda (term)
                      (let ((term (string-trim-both term)))
                        (cond
                         ((string-match "^tagged\\((.*)\\)$" term)
                          => (lambda (m)
                               (let ((tag (match:substring m 1)))
                                 (lambda (name)
                                   (member tag (tags-of name))))))
                         (else
                          (let ((rx (glob->regexp term)))
                            (lambda (name) (regexp-exec rx name)))))))
                    (string-split
                     (regexp-substitute/global #f " +or +" spec
                                               'pre (string #\x1) 'post)
                     #\x1))))
    (lambda (name) (any (cut <> name) terms))))

(define (default-wiki-template site info)
  "Render the body of a wiki page.  INFO is an alist with the keys
name, url, title, description, body, parents, tags, backlinks and
last-edited.  Lists of links are (TEXT . URL) pairs, where URL may be
#f; description and last-edited may be #f."
  (define (ref key) (assq-ref info key))
  (define (link-or-text pair)
    (match pair
      ((text . #f) text)
      ((text . url) `(a (@ (href ,url)) ,text))))
  `(div (@ (class "wiki-page"))
        ,(match (ref 'parents)
           (() '())
           (parents
            `(nav (@ (class "wiki-parentlinks"))
                  ,@(append-map (lambda (p) (list (link-or-text p) " / "))
                                parents))))
        (h1 (@ (class "title")) ,(ref 'title))
        ,(ref 'body)
        ,(match (ref 'tags)
           (() '())
           (tags
            `(div (@ (class "tags"))
                  "Tags:"
                  (ul ,@(map (lambda (t) `(li ,(link-or-text t))) tags)))))
        ,(match (ref 'backlinks)
           (() '())
           (links
            `(p (@ (class "wiki-backlinks"))
                "Links to this page: "
                ,@(intersperse ", " (map link-or-text links)))))
        ,(match (ref 'last-edited)
           (#f '())
           (date `(p (@ (class "wiki-lastedit"))
                     "Last edited " ,(blog-date->string date))))))

(define* (wiki #:key
               (directory "wiki")
               (prefix "wiki")
               (title "Wiki")
               (theme #f)
               (readers (list ikiwiki-reader))
               (tag-base "tags")
               (git-dates? #f)
               (template default-wiki-template))
  "Return a builder that renders every page found in DIRECTORY as an
ikiwiki-style wiki rooted at the URL /PREFIX/.  The root page is
DIRECTORY/index.mdwn and is titled TITLE.

THEME: a Haunt theme whose layout wraps every page (default: Haunt's).
READERS: readers for page sources; other files are copied verbatim.
TAG-BASE: wiki path under which tag pages live (tags/foo).
GIT-DATES?: use 'git log' for the last-edited date instead of mtime.
TEMPLATE: procedure (SITE INFO) -> SXML, see default-wiki-template."
  (lambda (site posts)
    (define directory* (string-trim-right directory #\/))
    (define theme* (or theme (blog-theme #:name "Wiki")))
    (define out-prefix (if (string-null? prefix) "" (string-append prefix "/")))
    (define url-root (if (string-null? prefix) "" (string-append "/" prefix)))
    (define (encode-path name)
      (string-join (map uri-encode (string-split name #\/)) "/"))

    ;; --- Read sources -------------------------------------------------
    (define-values (pages files)
      (let loop ((rels (if (file-exists? directory*)
                           (sort (scan-directory directory* (site-file-filter site))
                                 string<?)
                           '()))
                 (pages '())
                 (files '()))
        (match rels
          (() (values (reverse pages) (reverse files)))
          ((rel . rest)
           (let ((source (string-append directory* "/" rel)))
             (match (reader-find readers source)
               (#f (loop rest pages (cons rel files)))
               (reader
                (let-values (((metadata sxml) (reader-read reader source)))
                  (loop rest
                        (cons (make-wiki-page (source->page-name rel)
                                              source metadata sxml)
                              pages)
                        files)))))))))

    ;; --- Index of everything a link can point to --------------------
    (define kinds (make-hash-table))      ; name -> page | file | (tag . T)
    (define lower (make-hash-table))      ; lowercase name -> name
    (define by-name (make-hash-table))    ; name -> <wiki-page>
    (define (register! name kind)
      (when (hash-ref kinds name)
        (error "wiki: duplicate page name" name))
      (hash-set! kinds name kind)
      (unless (hash-ref lower (string-downcase name))
        (hash-set! lower (string-downcase name) name)))
    (for-each (lambda (p)
                (register! (wiki-page-name p) 'page)
                (hash-set! by-name (wiki-page-name p) p))
              pages)
    (for-each (cut register! <> 'file) files)

    (define (tags-of name)
      (match (hash-ref by-name name)
        (#f '())
        (page (or (page-ref page 'tags) '()))))

    (define all-tags
      (delete-duplicates (append-map (lambda (p) (tags-of (wiki-page-name p)))
                                     pages)))

    (define (exists? name) (hash-ref kinds name))

    (define (bestlink from link)
      (let* ((absolute? (string-prefix? "/" link))
             (link (string-trim-both link #\/)))
        (and (not (string-null? link))
             (let loop ((cwd (if absolute? "" from)))
               (let ((l (if (string-null? cwd) link (string-append cwd "/" link))))
                 (cond
                  ((exists? l) l)
                  ((hash-ref lower (string-downcase l)) => identity)
                  ((string-null? cwd) #f)
                  (else (loop (parent-name cwd)))))))))

    (define (tag-page-name tag)
      (let ((name (string-append tag-base "/" (normalize-link tag))))
        (or (bestlink "" (string-append "/" name)) name)))

    ;; Tag pages that have no source get generated.
    (define auto-tags
      (filter-map (lambda (tag)
                    (let ((name (tag-page-name tag)))
                      (and (not (exists? name))
                           (begin (register! name (cons 'tag tag))
                                  (cons name tag)))))
                  all-tags))

    (define (url name)
      (match (hash-ref kinds name)
        ('file (string-append url-root "/" (encode-path name)))
        (_ (if (string=? name "index")
               (string-append url-root "/")
               (string-append url-root "/" (encode-path name) "/")))))

    (define (title-of name)
      (match (hash-ref kinds name)
        ('page (let ((page (hash-ref by-name name)))
                 (or (page-ref page 'title)
                     (if (string=? name "index")
                         title
                         (pagetitle (basename name))))))
        (('tag . tag) (string-append "Tag: " tag))
        (_ (pagetitle (basename name)))))

    ;; --- Backlinks ----------------------------------------------------
    (define backlinks (make-hash-table))
    (for-each
     (lambda (page)
       (let ((from (wiki-page-name page)))
         (for-each
          (lambda (target)
            (unless (or (not target) (string=? target from))
              (let ((current (hash-ref backlinks target '())))
                (unless (member from current)
                  (hash-set! backlinks target (cons from current))))))
          (append (map (cut bestlink from <>)
                       (or (page-ref page 'wiki-links) '()))
                  (map tag-page-name (tags-of from))))))
     pages)

    (define (sort-by-title names)
      (sort names (lambda (a b) (string-ci<? (title-of a) (title-of b)))))

    (define (links-to names)
      (map (lambda (n) (cons (title-of n) (url n))) (sort-by-title names)))

    ;; --- Directives needing the whole wiki ----------------------------
    (define (render-map params)
      (let* ((pred (pagespec->predicate (or (param params "pages") "*")
                                        tags-of))
             (names (sort (filter (lambda (n)
                                    (and (not (string=? n "index")) (pred n)))
                                  (map wiki-page-name pages))
                          string<?)))
        (define (insert tree comps)
          (match comps
            (() tree)
            ((c . rest)
             (match (assoc c tree)
               (#f (append tree (list (cons c (insert '() rest)))))
               (node (map (lambda (n)
                            (if (eq? n node) (cons c (insert (cdr n) rest)) n))
                          tree))))))
        (define (render tree path)
          `(ul ,@(map (match-lambda
                        ((comp . children)
                         (let ((full (if path (string-append path "/" comp) comp)))
                           `(li ,(if (exists? full)
                                     `(a (@ (href ,(url full))) ,(title-of full))
                                     (pagetitle comp))
                                ,@(if (null? children)
                                      '()
                                      (list (render children full)))))))
                      tree)))
        `(div (@ (class "wiki-map"))
              ,(render (fold (lambda (n tree) (insert tree (string-split n #\/)))
                             '() names)
                       #f))))

    (define (render-toc params headings)
      (let* ((levels (or (and=> (param params "levels") string->number) 1))
             (top (if (null? headings) 1 (apply min (map car headings))))
             (headings (filter (lambda (h) (< (car h) (+ top levels))) headings)))
        (define (build hs level)
          (let loop ((hs hs) (acc '()))
            (match hs
              (() (values (reverse acc) '()))
              (((l id text) . rest)
               (cond
                ((< l level) (values (reverse acc) hs))
                ((= l level)
                 (let-values (((children rest*) (build rest (1+ level))))
                   (loop rest*
                         (cons `(li (a (@ (href ,(string-append "#" id))) ,text)
                                    ,@(if (null? children) '()
                                          `((ul ,@children))))
                               acc))))
                (else
                 (let-values (((children rest*) (build hs (1+ level))))
                   (loop rest* (cons `(li (ul ,@children)) acc)))))))))
        (let-values (((items _) (build headings top)))
          `(nav (@ (class "wiki-toc")) (ul ,@items)))))

    ;; --- Rendering ----------------------------------------------------
    (define (resolve-href from href)
      ;; Return a URL string, or #f for a missing page.
      (let* ((target (uri-decode (substring href 5)))
             (hash (string-index target #\#))
             (page (if hash (substring target 0 hash) target))
             (anchor (if hash (substring target hash) "")))
        (if (string-null? page)
            anchor
            (and=> (bestlink from page)
                   (lambda (name) (string-append (url name) anchor))))))

    (define (render-body page)
      (define from (wiki-page-name page))
      (define ids (make-hash-table))
      (define headings '())
      (define (unique-id base)
        (let ((n (hash-ref ids base 0)))
          (hash-set! ids base (1+ n))
          (if (zero? n) base (format #f "~a-~a" base (1+ n)))))
      (define pass1
        (sxml-map
         (lambda (tag attrs body)
           (let ((href (attr-ref attrs 'href))
                 (src (attr-ref attrs 'src)))
             (cond
              ((and (eq? tag 'a) href (string-prefix? "wiki:" href))
               (match (resolve-href from href)
                 (#f `(span (@ (class "createlink")
                               (title "this page does not exist yet"))
                            ,@body))
                 (u (element tag (attr-set attrs 'href u) body))))
              ((and (eq? tag 'a) href (string-prefix? "wikitag:" href))
               (let ((name (tag-page-name (uri-decode (substring href 8)))))
                 (element tag (attr-set attrs 'href (url name)) body)))
              ((and (eq? tag 'img) src (string-prefix? "wiki:" src))
               (element tag
                        (attr-set attrs 'src
                                  (or (resolve-href from src)
                                      (uri-decode (substring src 5))))
                        body))
              ((memq tag '(h1 h2 h3 h4 h5 h6))
               (let ((id (or (attr-ref attrs 'id)
                             (unique-id (slugify (sxml-text body)))))
                     (level (- (char->integer
                                (string-ref (symbol->string tag) 1))
                               (char->integer #\0))))
                 (set! headings (cons (list level id (sxml-text body)) headings))
                 (element tag (attr-set attrs 'id id) body)))
              ((eq? tag 'code)
               (element tag attrs (highlight-code-body attrs body)))
              (else (element tag attrs body)))))
         (wiki-page-sxml page)))
      (define directives (or (page-ref page 'wiki-directives) '()))
      (sxml-map
       (lambda (tag attrs body)
         (match (cons tag body)
           (('p (? string? s))
            (match (string-match "^wikidirective-([0-9]+)$" s)
              (#f (element tag attrs body))
              (m (match (assv-ref directives
                                  (string->number (match:substring m 1)))
                   (("toc" . params) (render-toc params (reverse headings)))
                   (("map" . params) (render-map params))
                   (_ (element tag attrs body))))))
           (_ (element tag attrs body))))
       pass1))

    (define (last-edited page)
      (or (page-ref page 'updated)
          (let ((secs (or (and git-dates? (git-timestamp (wiki-page-source page)))
                          (stat:mtime (stat (wiki-page-source page))))))
            (time-utc->date (make-time time-utc 0 secs)))))

    (define (parents name)
      (if (string=? name "index")
          '()
          (cons (cons title (url "index"))
                (let loop ((comps (drop-right (string-split name #\/) 1))
                           (path #f))
                  (match comps
                    (() '())
                    ((c . rest)
                     (let ((full (if path (string-append path "/" c) c)))
                       (cons (cons (if (exists? full) (title-of full) (pagetitle c))
                                   (and (exists? full) (url full)))
                             (loop rest full)))))))))

    (define (output-file name)
      (if (string=? name "index")
          (string-append out-prefix "index.html")
          (string-append out-prefix name "/index.html")))

    (define (emit name body tags last backlinks?)
      (let ((page-title (title-of name))
            (page (hash-ref by-name name)))
        (serialized-artifact
         (output-file name)
         (with-layout theme* site page-title
                      (template site
                                `((name . ,name)
                                  (url . ,(url name))
                                  (title . ,page-title)
                                  (description . ,(and page
                                                       (page-ref page 'description)))
                                  (body . ,body)
                                  (parents . ,(parents name))
                                  (tags . ,(map (lambda (t)
                                                  (cons t (url (tag-page-name t))))
                                                tags))
                                  (backlinks . ,(if backlinks?
                                                    (links-to
                                                     (hash-ref backlinks name '()))
                                                    '()))
                                  (last-edited . ,last))))
         sxml->html)))

    (append
     (map (lambda (page)
            (let ((name (wiki-page-name page)))
              (emit name (render-body page) (tags-of name) (last-edited page) #t)))
          pages)
     (map (match-lambda
            ((name . tag)
             (emit name
                   `((ul (@ (class "wiki-tagged"))
                         ,@(map (lambda (n) `(li (a (@ (href ,(url n)))
                                                     ,(title-of n))))
                                (sort-by-title
                                 (filter (lambda (n) (member tag (tags-of n)))
                                         (map wiki-page-name pages))))))
                   '() #f #f)))
          auto-tags)
     (map (lambda (rel)
            (verbatim-artifact (string-append directory* "/" rel)
                               (string-append out-prefix rel)))
          files))))
