title: Talk at LinuxDay 2026. Playing with Guix on foreign distributions.
date: 2026-09-21 19:30
mastodon: https://floss.social/@gisgeek/117310335639297894
tags: technology, event, guix, talk, distribution
summary: Linux Day 2026 talk about Guix for newbies. 
---

Three years after my last public appearance at a local FOSS event, my old friend
Marco brought me on board again as a speaker for LinuxDay 2026 in October. While
my latest speeches were mostly about the status and governance of the FOSS
domain, this time I’ll present something more technical. 

Lately, I’m rarely inspired by specific technologies; I generally find them not
gripping enough. Still, I see Guix as one of the most innovative concepts among
distributions and package management, so I will try to inspire other techies to
discover it, starting with other distributions.

Because of my proverbial laziness (kudos to Larry Wall for recognizing it as a
virtue), this is a good occasion to bring order to the chaos of my how-tos and
notes and emerge with something useful for general use (or at least for my
reuse).

Recently, I wrote a couple of posts about Guix, and 
[Steve George](https://www.futurile.net/resources/guix/) also wrote multiple notes
about using Guix on foreign distributions, and possibly moving to use Guix as
primary distribution, after that.

As explained [here](https://lovergine.com/an-initial-dive-into-guix.html), using
Guix as your main distribution could be variously challenging, even if, in some
aspects, limitations can be bypassed using the new linux-debian kernel to
include firmware blobs or the non-guix repository for other issues.

The purpose of the speech is to present the concept of _reproducible computing_ at
large, something that is rarely exploited by common users, but is of primary
interest to developers. The Guix system is fully transactional and source-based,
with an invariant, but multi-profile base system. Also, it is elegant and
coherent thanks to the use of a fully functional programming language (i.e., 
[GNU Guile](https://www.gnu.org/software/guile/), a Scheme implementation). 
While understanding Scheme is not a strict
requirement for a generic user, using such a language allows a fully declarative
distribution implementation homogeneously. Indeed, such an approach is
light-years away from traditional distribution tool sets.

The speech will include a demo session to avoid talking in general and instead
show Guix as a daily driver within a foreign distribution. I have a few weeks to
prepare an interesting session that fully exploits Guix's potential in multiple
contexts.

See you [in Bari on 24th of October](https://bari.ils.org/2026/linux-day-bari-2026/#), 
if you can.
