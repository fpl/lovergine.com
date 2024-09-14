;;; Copyright (C) 2018 David Thompson <davet@gnu.org>
;;; Copyright (C) 2018-2023 Janneke Nieuwenhuizen <janneke@gnu.org>
;;; Copyright (C) 2024 Francesco Paolo Lovergine <mbox@lovergine.com>
;;;
;;; Main Guile 3.0 script for generating lovergine.com personal blog with Haunt. 
;;;
;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;;

;;;
;;; This script requires an haunt installation that includes the
;;; following optional modules:
;;;     - guile-reader
;;;     - guile-commonmark
;;;     - guile-syntax-highlight
;;; that need to be installed before haunt.
;;;

(setlocale LC_ALL "C")
(fluid-set! %default-port-encoding "UTF-8")

(use-modules (haunt asset)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder rss)
             (haunt builder assets)
             (haunt builder flat-pages)
             (haunt html)
             (haunt page)
             (haunt post)
             (haunt reader)
             (haunt reader commonmark)
             (haunt reader texinfo)
             (haunt site)
             (haunt utils)
             (commonmark)
             (syntax-highlight)
             (syntax-highlight scheme)
             (syntax-highlight xml)
             (syntax-highlight c)
             (sxml match)
             (sxml transform)
             (texinfo)
             (texinfo html)
             (srfi srfi-1)
             (srfi srfi-19)
             (ice-9 rdelim)
             (ice-9 regex)
             (ice-9 match)
             (web uri))

(define (date year month day)
  "Create a SRFI-19 date for the given YEAR, MONTH, DAY"
  (let ((tzoffset (tm:gmtoff (localtime (time-second (current-time))))))
    (make-date 0 0 0 0 day month year tzoffset)))

(define (stylesheet name)
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/css/" name ".css")))))

(define* (anchor content #:optional (uri content))
  `(a (@ (href ,uri)) ,content))

(define %cc-by-sa-link
  '(a (@ (href "https://creativecommons.org/licenses/by-sa/4.0/"))
      "Creative Commons Attribution Share-Alike 4.0 International"))

(define %cc-by-sa-button
  '(a (@ (class "cc-button")
         (href "https://creativecommons.org/licenses/by-sa/4.0/"))
      (img (@ (src "https://licensebuttons.net/l/by-sa/4.0/80x15.png")))))

;;Creative Commons Attribution-NoDerivs 4.0 license (a.k.a. CC BY-ND) (#ccbynd)
(define %cc-by-nd-link
  '(a (@ (href "https://creativecommons.org/licenses/by-nd/4.0/"))
      "Creative Commons Attribution-NoDerivs 4.0"))

(define %cc-by-nd-button
  '(a (@ (class "cc-button")
         (href "https://creativecommons.org/licenses/by-nd/4.0/"))
      (img (@ (src "https://licensebuttons.net/l/by-nd/4.0/80x15.png")))))

(define (link name uri)
  `(a (@ (href ,uri)) ,name))

(define* (centered-image url #:optional alt)
  `(img (@ (class "centered-image")
           (src ,url)
           ,@(if alt
                 `((alt ,alt))
                 '()))))

(define (first-paragraph post)
  (let loop ((sxml (post-sxml post))
             (result '()))
    (match sxml
      (() (reverse result))
      ((or (('p ...) _ ...) (paragraph _ ...))
       (reverse (cons paragraph result)))
      ((head . tail)
       (loop tail (cons head result))))))

(define lovergine.com-theme
  (theme #:name "lovergine.com"
         #:layout
         (lambda (site title body)
           `((doctype "html")
             (head
              (meta (@ (charset "utf-8")))
              (link (@ (rel "alternate")
                   (type "application/rss+xml")
                   (title "lovergine.com")
                   (href "/rss-feed.xml")))
              (link (@ (rel "alternate")
                   (type "application/atom+xml")
                   (title "lovergine.com")
                   (href "/feed.xml")))

              (title ,(string-append title " — " (site-title site)))
              ,(stylesheet "reset")
              ,(stylesheet "fonts")
              ,(stylesheet "lovergine.com"))
            (body
              (div (@ (class "hide"))(a (@ (rel "me")(href "https://floss.social/@gisgeek")) "Mastodon"))
              (div (@ (class "container"))
                   (div (@ (class "nav"))
                        (ul 
                            (li (h2 ,(site-title site)))
                            (li ,(link "home" "/"))
                            (li ,(link "about" "/about.html"))
                            (li ,(link "contact" "/contact.html"))
                            (li (@ (class "fade-text")) " ")))
                   ,@(if (not (equal? title "Recent Blog Posts")) '()
                       `((div (@ (class "right-box"))
                              ,(anchor (centered-image "images/feed.png" "atom")
                                       "/feed.xml"))))
                   ,body
                   (footer (@ (class "text-center"))
                           (p (@ (class "copyright"))
                              "Copyright (C) 2024 Francesco P. Lovergine"
                              ,%cc-by-sa-button)
                           (p "The text and images on this site are
free culture works available under the " ,%cc-by-sa-link " license.")
                           (p "This website is built with "
                              (a (@ (href "http://haunt.dthompson.us"))
                                 "Haunt")
                              ", a static site generator written in "
                              (a (@ (href "https://gnu.org/software/guile"))
                                 "GNU Guile")
                              "."))))))
         #:post-template
         (lambda (post)
           `((h1 (@ (class "title")),(post-ref post 'title))
             (div (@ (class "date"))
                  ,(date->string (post-date post)
                                 "~B ~d, ~Y"))
             (div (@ (class "tags"))
                   "Tags:"
                   (ul ,@(map (lambda (tag)
                                `(li (a (@ (href ,(string-append "/feeds/tags/"
                                                                 tag ".xml")))
                                        ,tag)))
                              (assq-ref (post-metadata post) 'tags))))
             (div (@ (class "post"))
                  ,(post-sxml post))))
         #:collection-template
         (lambda (site title posts prefix)
           (define (post-uri post)
             (string-append "/" (or prefix "")
                            (site-post-slug site post) ".html"))

           `((h1 ,title)
             ,(map (lambda (post)
                     (let ((uri (string-append "/"
                                               (site-post-slug site post)
                                               ".html")))
                       `(div (@ (class "summary"))
                             (h2 (a (@ (href ,uri))
                                    ,(post-ref post 'title)))
                             (div (@ (class "date"))
                                  ,(date->string (post-date post)
                                                 "~B ~d, ~Y"))
                             (div (@ (class "post"))
                                  ,(first-paragraph post))
                             (a (@ (href ,uri)) "read more ➔"))))
                   posts)))))

(define* (collections #:key (file-name "index.html"))
  `(("Recent Blog Posts" ,file-name ,posts/reverse-chronological)))

(define parse-lang
  (let ((rx (make-regexp "-*-[ ]+([a-z]*)[ ]+-*-")))
    (lambda (port)
      (let ((line (read-line port)))
        (match:substring (regexp-exec rx line) 1)))))

(define (maybe-highlight-code lang source)
  (let ((lexer (match lang
                 ('scheme lex-scheme)
                 ('xml    lex-xml)
                 ('c      lex-c)
                 (_ #f))))
    (if lexer
        (highlights->sxml (highlight lexer source))
        source)))

(define (sxml-identity . args) args)

(define (highlight-code . tree)
  (sxml-match tree
    ((code (@ (class ,class) . ,attrs) ,source)
     (let ((lang (string->symbol
                  (string-drop class (string-length "language-")))))
       `(code (@ ,@attrs)
             ,(maybe-highlight-code lang source))))
    (,other other)))

(define (highlight-scheme code)
  `(pre (code ,(highlights->sxml (highlight lex-scheme code)))))

(define (raw-snippet code)
  `(pre (code ,(if (string? code) code (read-string code)))))

;; Markdown doesn't support video, so let's hack around that!  Find
;; <img> tags with a ".webm" source and substitute a <video> tag.
(define (media-hackery . tree)
  (sxml-match tree
    ((img (@ (src ,src) . ,attrs) . ,body)
     (if (string-suffix? ".webm" src)
         `(video (@ (src ,src) (controls "true"),@attrs) ,@body)
         tree))))

(define %commonmark-rules
  `((code . ,highlight-code)
    (img . ,media-hackery)
    (*text* . ,(lambda (tag str) str))
    (*default* . ,sxml-identity)))

(define (post-process-commonmark sxml)
  (pre-post-order sxml %commonmark-rules))

(define commonmark-reader*
  (make-reader (make-file-extension-matcher "md")
               (lambda (file)
                 (call-with-input-file file
                   (lambda (port)
                     (values (read-metadata-headers port)
                             (post-process-commonmark
                              (commonmark->sxml port))))))))

(define (static-page title file-name body)
  (lambda (site posts)
    (make-page file-name
               (with-layout lovergine.com-theme site title body)
               sxml->html)))

(define (image src alt)
  `(p (img
    (@ (src ,(string-append "/images/" src))))))

(site #:title "frankie-tales"
      #:domain "lovergine.com"
      #:default-metadata
      '((author . "Francesco P. Lovergine")
        (email  . "mbox@lovergine.com"))
      #:readers (list commonmark-reader* texinfo-reader)
      #:builders (list (blog #:theme lovergine.com-theme #:collections (collections))
                       (atom-feed)
                       (rss-feed)
                       (atom-feeds-by-tag)
                       (flat-pages "pages"
                                   #:template (theme-layout lovergine.com-theme))
                       (static-directory "css")
                       (static-directory "fonts")
                       (static-directory "images")
                       (static-directory "videos")))

