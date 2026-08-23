;;; builder/sitemap.scm --- XML sitemap generator for lovergine.com
;;; Copyright © 2026 Francesco P Lovergine <pobox@lovergine.com>
;;;
;;; This file lives outside of Haunt itself, in the site's own
;;; lovergine namespace, so that no upstream Haunt files need to be
;;; touched.

;;; Commentary:
;;
;; Generates a sitemap.xml file conforming to the Sitemaps XML
;; protocol <https://www.sitemaps.org/protocol.html>, so that search
;; engines (e.g. via Google Search Console) can efficiently discover
;; every post and page on the site.
;;
;; Usage in haunt.scm:
;;
;;   (use-modules (builder sitemap))
;;
;;   (site #:builders (list (blog #:theme lovergine-theme)
;;                          (atom-feed)
;;                          (sitemap)
;;                          ...))
;;
;; If 'blog' is configured with a non-default #:prefix or
;; #:post-prefix, pass matching values to 'sitemap' so that post URLs
;; are computed correctly, e.g. (sitemap #:post-prefix "posts").
;;

(define-module (builder sitemap)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-26)
  #:use-module (sxml simple)
  #:use-module (haunt artifact)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (web uri)
  #:export (sitemap))

(define (sxml->xml* sxml port)
  "Write SXML to PORT, preceded by an <?xml> declaration."
  (display "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" port)
  (sxml->xml sxml port))

(define (date->w3c-string date)
  "Convert DATE to a W3C Datetime string suitable for <lastmod>."
  (date->string date "~Y-~m-~dT~H:~M:~SZ"))

(define (site-url site path)
  "Return the absolute URL for the site-relative PATH on SITE."
  (uri->string
   (build-uri (site-scheme site)
              #:host (site-domain site)
              #:path path)))

(define (post-path prefix post-prefix site post)
  "Return the site-relative path of POST's rendered page.  This must
mirror the file name that the 'blog' builder produces for the same
PREFIX and POST-PREFIX arguments."
  (string-append
   (if prefix (string-append "/" prefix) "")
   (if post-prefix (string-append "/" post-prefix) "")
   "/" (site-post-slug site post) ".html"))

(define (tag-paths posts)
  "Return tag page paths, mirroring (haunt builder tag-pages)'s
hard-coded 'tags/TAG.html' naming convention."
  (cons "/tags/index.html"
        (map (match-lambda ((tag . _) (string-append "/tags/" tag ".html")))
             (posts/group-by-tag posts))))

(define* (url-entry site path #:optional lastmod)
  `(url (loc ,(site-url site path))
        ,@(if lastmod `((lastmod ,(date->w3c-string lastmod))) '())))

(define* (sitemap #:key
                   (file-name "sitemap.xml")
                   (prefix #f)
                   (post-prefix #f)
                   (filter posts/reverse-chronological)
                   (extra-paths '("/"))
                   (tags? #t))
  "Return a builder procedure that renders a sitemap.xml listing every
post plus EXTRA-PATHS (the site root by default).  All arguments are
optional:

FILE-NAME: The sitemap's output file name.

PREFIX, POST-PREFIX: Must match the values passed to the 'blog'
builder so that post URLs are computed correctly.

FILTER: A procedure applied to the full post list before rendering,
in case some posts should be excluded from the sitemap.

EXTRA-PATHS: A list of additional site-relative paths to include,
such as the front page or any flat pages.

TAGS?: When true (the default), also include the tag index and every
per-tag page produced by (haunt builder tag-pages)."
  (lambda (site posts)
    (let* ((posts (filter posts))
           (post-entries (map (lambda (post)
                                 (url-entry site
                                            (post-path prefix post-prefix
                                                       site post)
                                            (post-date post)))
                               posts))
           (extra-entries (map (cut url-entry site <>) extra-paths))
           (tag-entries (if tags?
                             (map (cut url-entry site <>) (tag-paths posts))
                             '())))
      (serialized-artifact file-name
                           `(urlset
                             (@ (xmlns
                                 "http://www.sitemaps.org/schemas/sitemap/0.9"))
                             ,@extra-entries
                             ,@post-entries
                             ,@tag-entries)
                           sxml->xml*))))

