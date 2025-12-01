title: DebianGis anniversary and the power of being a community
date: 2025-10-16 18:15
mastodon: https://floss.social/@gisgeek/115384755812520352
tags: debian, distributions, foss, development
summary: DebianGis was born 21 years ago
---

A few days before today, 21 years ago, I sent 
[this message](https://lists.debian.org/debian-devel-announce/2004/10/msg00007.html)
to the _debian-devel-announce_ mailing list to solicit helpers in packaging and
to oversee the geospatial software stack included in the main Debian archive.
After so many years, still there.

At that time, the Debian project had already been around for more than 10 years
and even had a few releases behind, but the typical maintenance of software was
still a one-person show, except for a few large and complex pieces of software.
Even the kernel was managed by a single developer, Herbert Xu. Each developer
was responsible for implementing updates, fixing bugs, and releasing updates.
Often jealous of such prerogatives and their stated possession of the package
or task. While there was already a quality assurance team and an orphaning
process for abandoned packages (or inactive developers), these processes were
not very common and were even relatively slow and imperfect.

Since that time, team-based maintenance has become the standard approach in the
Debian community for properly managing the most complicated software
collections. That's at least to ensure proper long-term maintenance,  because
the average developer can provide only a limited continuity to their efforts,
and real life is generally more complicated than the digital one. It is not
secondary that packaging tasks can be tedious in the long term, and it is easy
to lose motivation. The presence of a working team can reduce the risk of
burnout and allow each developer to step down when needed. The most effective
team should be small enough to coordinate more easily and avoid lagging in
changes and migrations, but not too small: presenting a one-person show as a
team work is not a great idea. But too many people in the same team is equally
not a great idea for the opposite reason.

In the specific case of Debian, the system is so modular and lacks many
interdependencies that it favors the creation of fully independent management
groups for hundreds of components and ecosystems of packages. It is not casual
that most of the bugs and inconsistencies are concentrated where too many parts
need to interact appropriately with perfectly aligned programming interfaces.

Talking about DebianGis and the geospatial software, the key motivation at the
time was the lack of a coordinated effort to build and collect together, with
consistency, a lot of different libraries and programs that were (and still
are) specialized enough and based on hundreds of dependencies, often not within
the perimeter of competence of the geodata user. At that time, piling up the
software stack of a typical geospatial application was not an easy task for the
faint of heart, and most (all?) of the Linux distributions lacked in one way or
another.

Anecdotally, I can remember about 15 years ago, the company that sold us a Suse
Enterprise-based solution for a geospatial information system that had so many
problems in completing the required setup that I finally created a chroot-based
environment with a Debian stable plain install to run a working PostGIS DBMS.
That was the time when containerized solutions were still far from being
supported, so the chroot environment was the most immediate solution to such a
problem.  A little win for a community-based distribution and its tiny
geospatial team, which provides a measure of the problems at the time. A giant
step for the whole FOSS concept.

I'm currently much less active in packaging tasks, but still seeing the current
team alive and capable of releasing well-supported products more than twenty
years later gives me reason to be proud of such a community.

