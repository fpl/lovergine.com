;;;
;;; builder/planet.scm -- Planet aggregator builder for lovergine.com
;;;
;;; Copyright © 2026 Francesco P Lovergine <mbox@lovergine.com>
;;;
;;; This is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; Fetches Atom/RSS feeds at build time, extracts first-paragraph
;;; excerpts, sorts by date, and renders paginated HTML pages at
;;; planet/index.html, planet/page_2.html, etc.

(define-module (builder planet)
  #:use-module (ice-9 regex)
  #:use-module (rnrs bytevectors)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-11)
  #:use-module (srfi srfi-19)
  #:use-module (web client)
  #:use-module (web response)
  #:use-module (sxml ssax)
  #:use-module (sxml xpath)
  #:use-module (haunt html)
  #:use-module (haunt artifact)
  #:use-module (haunt site)
  #:use-module (haunt builder blog)
  #:export (planet-builder))

;;; XML namespace aliases used during feed parsing.
(define %namespaces
  '((atom    . "http://www.w3.org/2005/Atom")
    (content . "http://purl.org/rss/1.0/modules/content/")
    (dc      . "http://purl.org/dc/elements/1.1/")))

;;; Like (sxpath path) but returns the first result or raises.
(define (sxpath1 path)
  (compose car (sxpath path)))

;;;
;;; HTTP / XML helpers
;;;

(define (fetch-feed url)
  "Fetch URL and return its body as a UTF-8 string, or #f on error."
  (catch #t
    (lambda ()
      (call-with-values
        (lambda () (http-get url #:decode-body? #f))
        (lambda (response body)
          (let ((code (response-code response)))
            (if (= code 200)
                (utf8->string body)
                (begin
                  (format (current-error-port)
                          "planet: HTTP ~a fetching ~a~%" code url)
                  #f))))))
    (lambda (key . args)
      (format (current-error-port)
              "planet: fetch error for ~a: ~a~%" url key)
      #f)))

(define (xml-string->sxml xml-str)
  "Parse XML-STR into an SXML tree, or #f on error."
  (catch #t
    (lambda ()
      (call-with-input-string xml-str
        (lambda (port)
          (ssax:xml->sxml port %namespaces))))
    (lambda (key . args)
      (format (current-error-port)
              "planet: XML parse error: ~a~%" key)
      #f)))

;;;
;;; Date parsing (handles ISO 8601 and RFC 822)
;;;

(define %date-formats
  '("~Y-~m-~dT~H:~M:~S~z"
    "~a, ~d ~b ~Y ~H:~M:~S ~z"))

(define %epoch (make-date 0 0 0 0 1 1 1970 0))

(define (parse-date-string str)
  "Parse STR into an SRFI-19 date. Falls back to the epoch on failure."
  (if (not (string? str))
      %epoch
      ;; SRFI-19 ~z does not accept colon-separated offsets (+HH:MM);
      ;; strip the colon so +01:00 becomes +0100.
      (let* ((m (string-match "([+-][0-9][0-9]):([0-9][0-9])$" str))
             (s (if m
                    (string-append (substring str 0 (match:start m 1))
                                   (match:substring m 1)
                                   (match:substring m 2))
                    str)))
        (let loop ((fmts %date-formats))
          (if (null? fmts)
              %epoch
              (or (false-if-exception (string->date s (car fmts)))
                  (loop (cdr fmts))))))))

(define (date->sort-key d)
  (time-second (date->time-utc d)))

;;;
;;; HTML stripping, entity decoding, and summary extraction
;;;

(define %html-tag-rx (make-regexp "<[^>]*>" regexp/extended))

(define (strip-html str)
  "Remove HTML tags from STR."
  (let loop ((s str) (parts '()))
    (let ((m (regexp-exec %html-tag-rx s)))
      (if m
          (loop (match:suffix m)
                (cons (match:prefix m) parts))
          (string-join (reverse (cons s parts)) "")))))

;;; Named HTML entities covering the most common cases in feed content.
(define %html-entities
  '(("nbsp"   . " ")       ; non-breaking space rendered as plain space in excerpts
    ("amp"    . "&")
    ("lt"     . "<")
    ("gt"     . ">")
    ("quot"   . "\"")
    ("apos"   . "'")
    ("mdash"  . "—")
    ("ndash"  . "–")
    ("hellip" . "…")
    ("ldquo"  . "“")
    ("rdquo"  . "”")
    ("lsquo"  . "‘")
    ("rsquo"  . "’")
    ("laquo"  . "«")
    ("raquo"  . "»")
    ("copy"   . "©")
    ("reg"    . "®")
    ("trade"  . "™")
    ("euro"   . "€")
    ("pound"  . "£")
    ("bull"   . "•")
    ("middot" . "·")
    ("eacute" . "é") ("Eacute" . "É")
    ("egrave" . "è") ("Egrave" . "È")
    ("ecirc"  . "ê") ("Ecirc"  . "Ê")
    ("agrave" . "à") ("Agrave" . "À")
    ("aacute" . "á") ("Aacute" . "Á")
    ("oacute" . "ó") ("Oacute" . "Ó")
    ("uacute" . "ú") ("Uacute" . "Ú")
    ("ocirc"  . "ô") ("Ocirc"  . "Ô")
    ("iuml"   . "ï") ("Iuml"   . "Ï")
    ("ccedil" . "ç") ("Ccedil" . "Ç")
    ("szlig"  . "ß")
    ("auml"   . "ä") ("Auml"   . "Ä")
    ("ouml"   . "ö") ("Ouml"   . "Ö")
    ("uuml"   . "ü") ("Uuml"   . "Ü")))

(define %entity-rx
  (make-regexp "&([a-zA-Z][a-zA-Z0-9]*|#[0-9]+|#[xX][0-9a-fA-F]+);"
               regexp/extended))

(define (decode-html-entities str)
  "Replace &entity; references in STR with the corresponding characters."
  (let loop ((s str) (parts '()))
    (let ((m (regexp-exec %entity-rx s)))
      (if m
          (let* ((ref (match:substring m 1))
                 (replacement
                  (or (cond
                        ;; Numeric hex: &#xNN; or &#XNN;
                        ((or (string-prefix? "#x" ref) (string-prefix? "#X" ref))
                         (let ((n (string->number (substring ref 2) 16)))
                           (and n (string (integer->char n)))))
                        ;; Numeric decimal: &#NNN;
                        ((string-prefix? "#" ref)
                         (let ((n (string->number (substring ref 1))))
                           (and n (string (integer->char n)))))
                        ;; Named entity
                        (else (assoc-ref %html-entities ref)))
                      ;; Unknown entity: keep as-is
                      (match:substring m 0))))
            (loop (match:suffix m)
                  (cons replacement (cons (match:prefix m) parts))))
          (string-join (reverse (cons s parts)) "")))))

(define (extract-summary raw)
  "Strip HTML tags and entities from RAW; return at most 300 characters."
  (if (not (string? raw))
      ""
      (let* ((stripped (string-trim-right
                         (string-trim
                           (decode-html-entities (strip-html raw)))))
             (len (string-length stripped)))
        (if (<= len 300)
            stripped
            (let loop ((i 300))
              (cond
                ((= i 0)
                 (string-append (substring stripped 0 300) "…"))
                ((char=? (string-ref stripped i) #\space)
                 (string-append (substring stripped 0 i) "…"))
                (else (loop (- i 1)))))))))

;;;
;;; Feed detection and parsing
;;;

(define (atom-feed? sxml)
  (not (null? ((sxpath '(atom:feed)) sxml))))

(define (rss-feed? sxml)
  (not (null? ((sxpath '(rss)) sxml))))

(define (make-entry name blog-link title link date raw-summary)
  `((name      . ,name)
    (blog-link . ,blog-link)
    (title     . ,(decode-html-entities (or title "")))
    (link      . ,link)
    (date      . ,date)
    (summary   . ,(extract-summary raw-summary))))

(define (parse-atom-entry entry name blog-link)
  "Parse one Atom ENTRY alist. Returns #f if the entry is unusable."
  (catch #t
    (lambda ()
      (let* ((title   (or (false-if-exception
                            ((sxpath1 '(atom:title *text*)) entry))
                          "(no title)"))
             (link    (false-if-exception
                        ((sxpath1 '(atom:link @ href *text*)) entry)))
             (date-s  (or (false-if-exception
                            ((sxpath1 '(atom:published *text*)) entry))
                          (false-if-exception
                            ((sxpath1 '(atom:updated *text*)) entry))))
             (summary (or (false-if-exception
                            ((sxpath1 '(atom:summary *text*)) entry))
                          (false-if-exception
                            ((sxpath1 '(atom:content *text*)) entry)))))
        (and link
             (make-entry name blog-link title link
                         (parse-date-string date-s)
                         summary))))
    (lambda (key . args) #f)))

(define (parse-atom-entries sxml name blog-link)
  "Extract entries from an Atom SXML tree."
  (filter-map (lambda (entry) (parse-atom-entry entry name blog-link))
              ((sxpath '(atom:feed atom:entry)) sxml)))

(define (parse-rss-entry item name blog-link)
  "Parse one RSS ITEM alist. Returns #f if the item is unusable."
  (catch #t
    (lambda ()
      (let* ((title   (or (false-if-exception
                            ((sxpath1 '(title *text*)) item))
                          "(no title)"))
             (link    (false-if-exception
                        ((sxpath1 '(link *text*)) item)))
             (date-s  (false-if-exception
                        ((sxpath1 '(pubDate *text*)) item)))
             (summary (or (false-if-exception
                            ((sxpath1 '(description *text*)) item))
                          (false-if-exception
                            ((sxpath1 '(content:encoded *text*)) item)))))
        (and link
             (make-entry name blog-link title link
                         (parse-date-string date-s)
                         summary))))
    (lambda (key . args) #f)))

(define (parse-rss-entries sxml name blog-link)
  "Extract entries from an RSS SXML tree."
  (filter-map (lambda (item) (parse-rss-entry item name blog-link))
              ((sxpath '(rss channel item)) sxml)))

(define (fetch-feed-entries feed-config)
  "Fetch and parse FEED-CONFIG. Returns a list of entry alists."
  (let* ((name  (assq-ref feed-config 'name))
         (url   (assq-ref feed-config 'url))
         (link  (assq-ref feed-config 'link)))
    (catch #t
      (lambda ()
        (let ((xml (fetch-feed url)))
          (if xml
              (let ((sxml (xml-string->sxml xml)))
                (if sxml
                    (cond
                      ((atom-feed? sxml)
                       (parse-atom-entries sxml name link))
                      ((rss-feed? sxml)
                       (parse-rss-entries sxml name link))
                      (else
                       (format (current-error-port)
                               "planet: unknown feed type for ~a~%" url)
                       '()))
                    '()))
              '())))
      (lambda (key . args)
        (format (current-error-port)
                "planet: error processing ~a: ~a~%" url key)
        '()))))

(define (sort-by-date entries)
  (sort entries
        (lambda (a b)
          (> (date->sort-key (assq-ref a 'date))
             (date->sort-key (assq-ref b 'date))))))

(define* (fetch-and-sort-feeds feeds-config #:optional (entries-per-feed #f))
  "Fetch all feeds and return entries sorted newest-first.
If ENTRIES-PER-FEED is set, take at most that many recent entries per feed
before merging, preventing any single prolific feed from dominating."
  (sort-by-date
    (apply append
           (map (lambda (feed-config)
                  (let* ((entries (sort-by-date (fetch-feed-entries feed-config)))
                         (n       (length entries))
                         (limit   (if entries-per-feed (min entries-per-feed n) n)))
                    (take entries limit)))
                feeds-config))))

;;;
;;; Pagination
;;;

(define (split-at-safe lst k)
  "Split LST at position K. Returns (head . tail) pair."
  (let loop ((l lst) (i k) (acc '()))
    (if (or (null? l) (= i 0))
        (cons (reverse acc) l)
        (loop (cdr l) (- i 1) (cons (car l) acc)))))

(define (paginate lst n)
  "Split LST into pages of N items."
  (if (null? lst)
      (list '())
      (let loop ((remaining lst) (pages '()))
        (if (null? remaining)
            (reverse pages)
            (let* ((split (split-at-safe remaining n))
                   (page  (car split))
                   (rest  (cdr split)))
              (loop rest (cons page pages)))))))

;;;
;;; SXML rendering
;;;

(define (format-date d)
  (date->string d "~B ~d, ~Y"))

(define (render-entry entry)
  (let ((title     (assq-ref entry 'title))
        (link      (assq-ref entry 'link))
        (name      (assq-ref entry 'name))
        (blog-link (assq-ref entry 'blog-link))
        (date      (assq-ref entry 'date))
        (summary   (assq-ref entry 'summary)))
    `(article (@ (class "planet-post"))
       (header
         (h2 (a (@ (href ,link) (target "_blank") (rel "noopener noreferrer")) ,title))
         (p (@ (class "planet-meta"))
            (a (@ (href ,blog-link) (target "_blank") (rel "noopener noreferrer")) ,name)
            " — "
            (span (@ (class "date")) ,(format-date date))))
       (p (@ (class "planet-excerpt")) ,summary)
       (a (@ (href ,link) (class "read-more") (target "_blank") (rel "noopener noreferrer")) "read more ➔"))))

(define (render-pagination page-num total-pages)
  (if (<= total-pages 1)
      '()
      `(div (@ (class "pagination"))
         ,(if (> page-num 0)
              `(a (@ (href ,(if (= page-num 1)
                                "/planet/"
                                (format #f "/planet/page_~a.html" page-num)))
                     (class "prev"))
                  "← Newer")
              "")
         ,(if (< page-num (- total-pages 1))
              `(a (@ (href ,(format #f "/planet/page_~a.html" (+ page-num 2)))
                     (class "next"))
                  "Older →")
              ""))))


(define (render-sources-page title feeds-config)
  `((h1 ,title)
    (ul (@ (class "planet-feeds-list"))
      ,@(map (lambda (feed)
               `(li (a (@ (href ,(assq-ref feed 'link))
                          (target "_blank") (rel "noopener noreferrer"))
                       ,(assq-ref feed 'name))
                    " "
                    (a (@ (href  ,(assq-ref feed 'url))
                          (class "feed-icon")
                          (title "Feed URL")
                          (target "_blank") (rel "noopener noreferrer"))
                       "[feed]")))
             feeds-config))))

(define (render-planet-page title page-entries page-num total-pages)
  `((h1 ,title)
    ,@(if (null? page-entries)
          '((p "No posts found."))
          (map render-entry page-entries))
    ,(render-pagination page-num total-pages)))

;;;
;;; Builder entry point
;;;

(define* (planet-builder #:key
                         (theme #f)
                         (title "Planet")
                         (feeds '())
                         (posts-per-page 10)
                         (entries-per-feed #f))
  "Return a builder that fetches FEEDS and renders paginated planet pages.

Each page goes to planet/index.html (page 0) or planet/page_N.html (N≥2).
THEME is the Haunt theme used for layout. POSTS-PER-PAGE controls how many
entries appear per page (default 10)."
  (lambda (site haunt-posts)
    (let* ((all-entries  (fetch-and-sort-feeds feeds entries-per-feed))
           (pages        (paginate all-entries posts-per-page))
           (total-pages  (length pages)))
      (cons
        (serialized-artifact "planet/sources.html"
                             (with-layout theme site "Planet Feeds"
                               (render-sources-page "Planet Feeds" feeds))
                             sxml->html)
        (map (lambda (page-entries page-num)
               (let ((file-name (if (= page-num 0)
                                    "planet/index.html"
                                    (format #f "planet/page_~a.html"
                                            (+ page-num 1)))))
                 (serialized-artifact
                   file-name
                   (with-layout theme site title
                     (render-planet-page title page-entries
                                         page-num total-pages))
                   sxml->html)))
             pages
             (iota total-pages))))))
