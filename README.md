# lovergine.com

- This is the [haunt](https://dthompson.us/projects/haunt.html)-based version of my personal blog site.
- This is a jamstack web site based on [GNU Guile language](https://www.gnu.org/software/guile/), a Scheme (Lisp variant) dialect.
- Contents are maintained with `vim`, `git `and `rsync`.
- Scripts are based on those written with ❤ by [Dave Thompson](https://git.dthompson.us/haunt.git), [Stephen Lloyd](https://gitlab.com/zosho/somenotes-source) and [Janneke Nieuwenhuizen](https://gitlab.com/janneke/joyofsource.com).
- The whole Planet section is inspired to [planet.guix.gnu.org](https://planet.guix.gnu.org) jamstack.
- The timezone colon-strip trick in parse-date-string — SRFI-19's ~z format doesn't accept +HH:MM; stripping the colon to get +HHMM is a non-obvious workaround that planet.guix already had.
- The namespace alias table — the idea of declaring (atom . "http://www.w3.org/2005/Atom") etc. as aliases so sxpath expressions can use atom:feed instead of the full URI. The specific URIs are standard, but
  planet.guix confirmed the approach.
- Feed config structure — the alist format ((name . "…") (url . "…") (link . "…")) in planet/config.scm is clearly taken from planet.guix.
  Everything else — the HTTP fetch with (web client), XML parsing via ssax:xml->sxml, the Atom/RSS entry parsers, the per-entry catch #t error isolation, the extract-summary / strip-html / decode-html-entities
  pipeline, the pagination logic, all the SXML rendering, and the Haunt builder interface — was written independently to fit Haunt's conventions rather than planet-guix's own static site toolchain.

