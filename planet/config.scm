;;;
;;; planet/config.scm -- Planet feed list for lovergine.com
;;;
;;; Copyright © 2026 Francesco P Lovergine <mbox@lovergine.com>
;;;
;;; This is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or
;;; (at your option) any later version.

(define-module (planet config)
  #:export (planet-feeds))

;;; Each entry is an alist with:
;;;   (name . "Display name")
;;;   (url  . "https://...feed.xml")   ; Atom or RSS feed URL
;;;   (link . "https://...blog/")      ; Blog homepage URL
(define planet-feeds
  '(
    ((name . "Apache News")
     (url  . "https://news.apache.org/feed")
     (link . "https://news.apache.org/"))

    ((name . "Debian Planet")
     (url  . "https://planet.debian.org/atom.xml")
     (link . "https://planet.debian.org/"))

    ((name . "Gnome Planet")
     (url  . "https://planet.gnome.org/atom.xml")
     (link . "https://planet.gnome.org/"))

    ((name . "Guix Planet")
     (url  . "https://planet.guix.gnu.org/atom.xml")
     (link . "https://planet.guix.gnu.org/"))

    ((name . "Jeff Geerling")
     (url  . "https://www.jeffgeerling.com/blog.xml")
     (link . "https://www.jeffgeerling.com/"))

    ((name . "Julia Evans")
     (url  . "https://jvns.ca/atom.xml")
     (link . "https://jvns.ca/"))

    ((name . "KDE Planet")
     (url  . "https://planet.kde.org/atom.xml")
     (link . "https://planet.kde.org/"))

    ((name . "Lars Wirzenius")
     (url  . "https://blog.liw.fi/index.atom")
     (link . "https://blog.liw.fi/"))

    ((name . "LWN")
     (url  . "https://lwn.net/headlines/rss")
     (link . "https://lwn.net/"))

    ((name . "Mozilla Planet")
     (url  . "https://planet.mozilla.org/rss20.xml")
     (link . "https://planet.mozilla.org/"))

    ((name . "OSGeo Planet")
     (url  . "https://planet.osgeo.org/rss20.xml")
     (link . "https://planet.osgeo.org/"))

    ((name . "Qiusheng Wu")
     (url  . "https://gishub.org/rss.xml")
     (link . "https://gishub.org/"))

    ((name . "Scheme Planet")
     (url  . "https://planet.scheme.org/atom.xml")
     (link . "https://planet.scheme.org/"))

    ((name . "Terence Eden")
     (url  . "https://shkspr.mobi/blog/feed/atom/")
     (link . "https://shkspr.mobi/"))

    ))
