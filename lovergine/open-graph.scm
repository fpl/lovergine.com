;;; lovergine/open-graph.scm --- Open Graph / social preview metadata
;;;
;;; Copyright © 2026 Francesco P Lovergine <pobox@lovergine.com>
;;;
;;; Local extension for lovergine.com.  Kept in the site's own
;;; (lovergine ...) namespace, per the project's convention of never
;;; touching files that belong to the Haunt package itself.
;;;
;;; Purpose: build the <meta property="og:..."> (and a couple of
;;; companion Twitter/X Card) tags that let link-preview generators —
;;; including Mastodon's — show a title, description and illustrative
;;; image when a lovergine.com URL is shared.
;;;
;;; This module deliberately does NOT depend on (haunt site): Haunt's
;;; blog builder calls a theme's #:post-template as (post-template
;;; post) — it never passes the <site> object in.  So instead of a
;;; site record, open-graph-meta-tags takes plain SITE-TITLE and
;;; DOMAIN strings, which callers can supply from their own
;;; top-level constants regardless of whether a <site> object is in
;;; scope at the call site.
;;;
;;; Since #:layout (which DOES get a <site>, but no POST) is called
;;; right after #:post-template for the same post, CURRENT-POST-OG-TAGS
;;; is provided as a simple carrier: post-template sets it, layout
;;; reads it and clears it again.  See the integration example below.
;;;
;;; Usage, from haunt.scm's custom theme:
;;;
;;;   (use-modules (lovergine open-graph))
;;;
;;;   (define %site-title  "frankie-tales")
;;;   (define %site-domain "lovergine.com")
;;;
;;;   ;; in #:post-template, BEFORE building and returning the body:
;;;   (current-post-og-tags
;;;     (open-graph-meta-tags %site-title %site-domain (post-ref post 'title)
;;;       #:path        (string-append "/" (post-slug post) ".html")
;;;       #:type        "article"
;;;       #:description (post-ref post 'description)
;;;       #:image       (post-ref post 'image)
;;;       #:published-time (date->string (post-date post) "~Y-~m-~dT~H:~M:~SZ")
;;;       #:author      (post-ref post 'author)))
;;;
;;;   ;; in #:layout, inside the <head> list:
;;;   ,@(let ((tags (current-post-og-tags)))
;;;       (if (null? tags)
;;;           (open-graph-meta-tags %site-title %site-domain title)
;;;           (begin (current-post-og-tags '())
;;;                  tags)))
;;;
;;; Code:

(define-module (lovergine open-graph)
  #:use-module (web uri)
  #:export (open-graph-meta-tags
            current-post-og-tags
            %default-og-image
            %default-og-image-width
            %default-og-image-height))

;; Site-relative path of the default illustrative image.  Copy
;; og-default.png into the site's images/ directory; it will be
;; picked up verbatim by the existing (static-directory "images")
;; builder, the same way other site images already are.
(define %default-og-image "/images/og-default.png")
(define %default-og-image-width "1200")
(define %default-og-image-height "1200")

;; Carries the current post's meta-tag list from #:post-template to
;; #:layout, which runs immediately afterwards for the same post but
;; has no direct access to the post object.  Holds '() whenever the
;; page being rendered isn't a post (index, tag pages, static
;; pages), so layout's fallback to the generic site-wide tags kicks
;; in automatically.  Callers should reset it to '() right after
;; reading it inside layout, so it doesn't leak into the next page.
(define current-post-og-tags
  (make-parameter '()))

(define* (og-absolute-url domain path #:key (scheme 'https))
  "Return an absolute URL string for PATH, a site-relative path
beginning with '/', on DOMAIN using SCHEME (a symbol, e.g. 'https)."
  (uri->string
   (build-uri scheme #:host domain #:path path)))

(define* (open-graph-meta-tags site-title domain title
                                #:key
                                (scheme 'https)
                                (path "/")
                                (type "website")
                                (description #f)
                                (image #f)
                                (image-width %default-og-image-width)
                                (image-height %default-og-image-height)
                                (image-alt "lovergine.com")
                                (published-time #f)
                                (author #f))
  "Return a list of SXML <meta> nodes carrying Open Graph metadata for
a page titled TITLE on DOMAIN, suitable for splicing into a <head>.

SITE-TITLE is used for og:site_name.  PATH is the site-relative path
of the page being rendered, used to build the canonical og:url.  TYPE
is the Open Graph object type, e.g. \"website\" or \"article\".  IMAGE,
when given, may be a site-relative path (\"/images/foo.png\") or a
full URL; it defaults to %default-og-image.  DESCRIPTION,
PUBLISHED-TIME (an ISO-8601 string) and AUTHOR are only emitted when
non-#f; the latter two only apply when TYPE is \"article\"."
  (define img (og-absolute-url domain (or image %default-og-image) #:scheme scheme))
  (define url (og-absolute-url domain path #:scheme scheme))
  `((meta (@ (property "og:type") (content ,type)))
    (meta (@ (property "og:site_name") (content ,site-title)))
    (meta (@ (property "og:title") (content ,title)))
    ,@(if description
          `((meta (@ (property "og:description") (content ,description))))
          '())
    (meta (@ (property "og:url") (content ,url)))
    (meta (@ (property "og:image") (content ,img)))
    (meta (@ (property "og:image:width") (content ,image-width)))
    (meta (@ (property "og:image:height") (content ,image-height)))
    (meta (@ (property "og:image:alt") (content ,image-alt)))
    ,@(if (and (string=? type "article") published-time)
          `((meta (@ (property "article:published_time") (content ,published-time))))
          '())
    ,@(if (and (string=? type "article") author)
          `((meta (@ (property "article:author") (content ,author))))
          '())
    (meta (@ (name "twitter:card") (content "summary_large_image")))
    (meta (@ (name "twitter:image") (content ,img)))))
