title: The Guix system, take two
date: 2024-09-02 20:00
tags: guix, guile, distributions
summary: More notes about Guix as a distribution
---

Let's give a second look at `Guix-the-system` the main GNU Project distribution
I dealt with in [a previous
post](http://lovergine.com/an-initial-dive-into-guix.html).  This post is not
specifically limited to the distribution, it is also of interest when using Guix
in a foreign distribution, even if some configuration details change.

## Substitutes and grafts

As said previously, the daily use of a store-based rolling distribution adds
some overhead to the system at both upgrade and installation time. This pain
(that remembers me the old times of the source-based [Gentoo
distribution](https://gentoo.org) with its `emerge` tool) is specifically
alleviated by the use of the so-called `substitutes servers`, which provide
pre-built binaries for the base system, as well as alternative/unofficial
packages, too.

The _fall-back_ alternative is based on regular build-from-sources on the host
system, which could imply long times for both installations and distribution
upgrades. The official Guix system comes with a couple of official substitutes
(i.e., `ci.guix.gnu.org` and `bordeaux.guix.gnu.org`) but others can be added,
including possibly any suitable user's server in the LAN.

Another trick in Guix for alleviating the need for long _local_ rebuilds is the
use of _grafts_ that are sort of _in-place_ replacements for binary
dependencies, expressed at the source level. To explain in brief, if a package `A@1`
has been replaced by `A@2` and they both maintain the same ABI, any _reverse
dependency_ `B` can avoid being rebuilt. This is called a _graft_ in Guix, and
greatly simplifies the long chains of forced rebuilds in many cases (for
instance, in case of security upgrades). Specifically, the `@` in a Guix package
is the version separator.

## A monorepo for the whole distribution

The Guix source archive is strictly based on `git` and distributed development by
means of a [monorepo](https://en.wikipedia.org/wiki/Monorepo),
which, along with the need to represent the tree of dependencies for any
package and its updates at run-time require some operations that are specific
of the Guix package management approach:

 - pulling
 - garbage collection
 - branching
 - using channels

The pull phase specifically could require ages (hours on my old low-end Asus
EEEpc), so it is an operation that should be applied typically in batch mode and quite often
in order to minimize execution times. It is not a potentially destructive
operation - similar to an `apt update` with steroids - so it is better
to perform it quite often, every few days. At the end of the day, it does not
alter the status of the system, so it is safe enough for background execution.

The `gc` operation works directly on the store to purge _obsolete_ (out of
the current status tree of dependencies) entries. If you jump to a past status,
the purge would impact bandwidth and CPU loads, of course.

The `branch` specification has the same role as any sane distributed
environment organization of code. It is usable to pull from separate branches of
archives, instead of following the default one, `latest`. This feature can be
paired with the Guix _time-machine_ to jump to any past tree of packages in the
chronology of the archive sources.

Finally, a _channel_ is simply an alternative archive of sources that is prepared
by third-party teams to integrate the official Guix one. For instance, a few independent
packages are offered by [INRIA](https://www.inria.fr/en) and other institutions for 
[the HPC community](https://hpc.guix.info/about/), as well as an handful of non-free
packages hosted on [the nonguix repository](https://gitlab.com/nonguix/nonguix) to
solve the well-known users-hostages' dilemma about using closed-source firmwares 
and a few other proprietary stuff.

## One Scheme to Rule Them All

An exciting feature of Guix-the-System is the use of [Guile](https://www.gnu.org/software/guile/) 
to describe the whole system, including the core, all services, and even users. 
In perspective, all installed packages could be also fully configured by using functional 
Guile snippets of code. This is something currently done in Debian only in
a limited way, through `debconf templates` and `dpkg selections`. 
In practice, today, one has to use `ansible` or similar tools to declare 
configurations in some _ad hoc_ DSL, using
tons of plugins and templates, case by case. In a word, it is a mess.

This is, at least for me, the most intriguing feature and open exciting possibilities.

Currently, any developer with a reasonably decent computer can easily use Guix to rebuild and customize
Guix itself by starting from a monorepo fork, changing its main configuration and
adding/modifying packages in a totally independent and self-consistent way. Something that
in traditional distributions is done by a plethora of tools and interfaces, written in multiple
generale-purpose or specific languages, and often not wholly documented and held together
with the glue.

Once added a layer of general-purpose configurators for common packages the
whole distribution generation could become fully autoconsistent and complete for
any host or set of boxes. Isn't that challenging?

## Guix in foreign distributions

Using Guix as an additional package manager in a foreign distribution 
has more limitations, of course. First of all, one must
deal with `systemd` as the typical init system. Therefore, the general
configuration of the host cannot be expressed in a synthetic way as a
Scheme script. That said, it is perfectly possible to use Guix as
a development environment for multiple languages ecosystems, thanks
to various Guile build modules. Even, it is possible to run Guix-the-system
in a _container_ (or a _virtual machine_), to use the host system just as a basic
platform and create Guix-based services and applications on top.

But those will be the topics for other posts...

## References

 - [https://guix.gnu.org/manual/en/html_node/Substitutes.html](https://guix.gnu.org/manual/en/html_node/Substitutes.html)
 - [https://guix.gnu.org/en/blog/2020/grafts-continued/](https://guix.gnu.org/en/blog/2020/grafts-continued/)
 - [https://guix.gnu.org/en/manual/devel/en/html_node/Managing-Patches-and-Branches.html](https://guix.gnu.org/en/manual/devel/en/html_node/Managing-Patches-and-Branches.html)
 - [https://guix.gnu.org/manual/en/html_node/Complex-Configurations.html](https://guix.gnu.org/manual/en/html_node/Complex-Configurations.html)
