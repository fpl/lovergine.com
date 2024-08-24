title: An initial dive into Guix
date: 2024-08-18 19:00
tags: guix, guile, distributions
summary: Some initial notes about Guix, the package manager and the distribution
---

In the last few days, I got familiar with `Guix`, which is both a modern package
management system and the main GNU Project distribution for Linux and Hurd (`the Guix system`).
As a package management system, it can be installed on most _foreign distributions_,
including Debian and any other, as an alternative/additional packaging system.

I both installed the Guix system natively on a small ancient laptop of mine 
(an ASUS EEEpc 1215N), and 
the Guix package manager on one of my Debian stable boxes. An interesting variant could
be installing the whole system under a container in a non-interactive 
mode, but that may be a task for the future. Indeed, the last one could
be the most exciting application of Guix for reproducible deployment. 

## Guix, the package manager

Guix (the package management system) is the most interesting part. It is a _modern_
system with multiple advanced features, inspired by [Nix](https://nixos.wiki/wiki/Nix_package_manager),
a pre-existing system based on a JSON-based DSL.
Nix and Guix are both declarative and functional package managers with similar goals
for software maintenance. 

Both of them declare to have the largest collection of FOSS packages in the world, but ok:
both currently have _hubs_ with tens of thousands of binary packages. 
Maybe not the largest, but respectful.
Of course, Guix is an FSF project and therefore highly choosy about the software
that can be distributed within the Guix archives. That's not specifically different
from the Debian approach, but for the derogation that historically the Debian Project
considered for limited proprietary-but-distributable stuff (the non-free+contrib section).

One interesting aspect of Guix (at least for me) is that it is specifically
based on Guile, an extendable Scheme dialect which is the main DSL used in the GNU ecosystem.
All packages are expressed as small snippets of Guile functions that declare
pre-dependencies, as well as the build, installation and test phases of each software.

Anyone who has worked on software packaging in Debian from the beginning knows that
the mythical `debian/rules` is essentially a _Makefile_ with steroids, accompanied
by a handful of declarative files, lately simplified by the use of some frameworks,
such as [Joey Hess's](https://joeyh.name/) `debhelper` or others commonly used
in the past. Maybe not the most elegant approach to packaging and configuring, let me say. 
Probably at the time - 30 years ago or so - the most pragmatic one, for sure. And it worked even for a lot of years.

In respect with traditional system-wide packaging, the Nix/Guix approach has several
interesting features:

 - transitional, per-user, multi-profile capabilities
 - a rolling-back capability at the system and user level
 - an all-in-one system of packing with dependencies
 - a single expressive way of defining software configurations at both system-wide and per-user levels

Guix _per se_ adds the use of Guile to all the rest so that all configurations are
synthetically expressed in S-exp, without the need to learn yet another DSL to
describe the software chains of dependencies.

## Guix, the system

The Guix free-software-only system has some interesting characteristics, including the use
of `shepherd` as an alternative Guile-based _init system_ and the rolling-on distribution
style. The non-FHS basic organization of the filesystem could also pose some problems
to install software that are strictly dependent on that, that's for sure a good reason
to use Guix-on-Debian instead of Guix-the-system only. That issue is also partially mitigated
by a combination of a container technology support, and an FHS emulation layer.

In my opinion, the whole thing is quite interesting for building development environments 
and exploring reproducible deployment systems.

## The GNU touch

But for the FSF strictly free approach to collecting software (including the missing firmware blobs
for the Linux-libre software, as for Debian until version 12), the Guix system has some typical
geek-only pillars for its ecosystem and community:

- strictly read the reference manuals and info files (i.e., do your homework)
- use mailing lists
- use IRC dedicated channels
- use your brain and experience to solve issues

Nothing different from the traditional Debian project community and approach to personal computing.
Therefore, nowadays something for geeky folk mainly, I guess.

## Issues and challenges

For sure, the user workflow to install and run software changes radically and in a very
different manner. One has the need to get familiar the Guix CLI interface and mode of operations. 
The Guix approach to deployment and maintenance adds an evident overhead to the system 
(for both storage and CPUs), partially
mitigated by the use of substitutes/hubs to reduce building from source requirements. 
Not the best thing for old boxes, I guess. 

Anyway, it is possible to use local _substitutes_ to reduce the load for
average systems. As a rolling distribution and/or software hub, I found it reasonably updated, but
that largely depends on applications and domains. Nobody makes miracles in those regards, 
_DebianGis_ packages in _testing/unstable_ are more up-to-date for geospatial apps,
and probably even more flexible. Sorry, no silver bullet, guys.
Even Guix does not have (still?) a dedicated security team, so I would recommend it currently 
only for personal/development use, not for servers.

An important feature of Guix is its support for reproducible software deployment, as an
alternative/integration to the ubiquitous containers, an aspect to deeply explore.

## References

The main resources about Guix are [the Reference Manual](https://guix.gnu.org/manual/en/html_node/) 
and [The Cookbook](https://guix.gnu.org/en/cookbook/en/html_node/), of course.
I found some interesting non-trivial articles about Guix and its internals on some _indie sites_
here listed:
 - [https://systemcrafters.net/craft-your-system-with-guix/](https://systemcrafters.net/craft-your-system-with-guix/)
 - [https://www.futurile.net/archives.html](https://www.futurile.net/archives.html)
 - [https://github.com/techenthusiastsorg/awesome-guix](https://github.com/techenthusiastsorg/awesome-guix)
 - [https://hpc.guix.info/](https://hpc.guix.info/)

