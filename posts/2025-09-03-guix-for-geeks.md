title: Guix for geeks
date: 2025-09-03 19:40
mastodon: https://floss.social/@gisgeek/115141698554474701
tags: guix, development, distributions
summary: About current experiences with Guix environment
---

In the last few months, I have installed and upgraded my second preferred
GNU/Linux system, GNU Guix, on multiple boxes. Regarding that system, I have
already [written a few introductory posts](https://lovergine.com/tags/guix.html) 
in the recent past. This is an update
about my experiences as a user and developer. I still think Guix is a giant
step forward in packaging and management, in comparison with Debian and other
distributions, for elegance and inner coherence.

On the negative side, I can confirm that the most important aspects to consider
in order to adopt Guix for daily use are as follows.  

* Guix is essentially a
roll-on type of distribution with a limited user base, so a grain of salt is
required at upgrade time because instabilities are somehow expected. The
integrated time machine can be used to step back in case of problems, anyway.

* The development team and other support teams are tiny enough that I would avoid
using Guix for publicly exposed services. Also, it can lag on specific
applications and issues. Tasks and goals do not specifically structure teams,
so there is no proper security team, but I guess all maintainers can
participate to cover all required tasks.  

* Packages are not always up-to-date
with the latest upstream versions. Some packages are even older than in Debian
stable, so if you are looking for the latest and coolest products, that's not
the place.  

* Some choices for the core distribution are not mainstream, such as
using shepherd as its init system instead of systemd. This implies some delays
because patches are sometimes due for complex software, such as Gnome, which
introduced strict dependencies on systemd in recent years. This is the reason
why, as of the current date, Gnome is still at version 46, while Debian stable
is at version 48.

* The geospatial tools and libraries available are still quite
limited, which may require a more in-depth analysis to estimate the level of
lag. See the section below.  

* The readiness for immediate use is not comparable
to the main distributions. For instance, if one absolutely needs a non-free
Linux kernel due to firmware constraints, the nonguix add-on repository is
available; however, one must build and install an ad hoc ISO installer by hand.
Nothing transcendental, but complicated enough to discourage most users. [Here](https://github.com/fpl/guix-installer/)
is my fork of the [System Crafters](https://systemcrafters.net/) repository to prepare such an ISO image,
updated for use of the current main Guix (now hosted on Codeberg) and NonGuix
channels. That could be easily prepared on any foreign distribution that
includes the `guix` package management software, such as Debian.

As of the current date, I have installed at least a few laptops and VMs,
including a Dell Inspiron 15, an Asus EEE 1215P, and an old Acer Travelmate. I
strongly suggest using at least a box with 8GB of RAM and a 512GB SSD, because
building from sources can be overwhelming. My dual-core Atom EEE Pc has only 2
GB of RAM, and it is slow enough, but it has the big advantage of being fully
supported by the official GNU Linux libre kernel.

Additionally, I believe that having a local build host for substitutions within
the home/work LAN is the most efficient solution. That is because the
officially provided worldwide substitution hosts could be generally heavily
loaded and occasionally fail (when that happens, the time of recovery is on a
best effort basis). 

Of course, it is also entirely possible to use Guix only as a package
management system on a foreign distribution, having most of the advantages of a
reproducible environment, as well as within a container or a virtual machine.
In that case, one has to consider that the host system is typically based on
the systemd init system, which can cause a few headaches when porting existing
package descriptions for services taken from the Guix repository. Probably the
best compromise is still using a foreign distribution on the physical box and a
Guix-based container to prepare an execution environment, something I already
experimented as explained in previous posts.

## Guix and geospatial software

In 2004, Paolo Cavallini and I started a subproject within the Debian community
of developers and users to improve the status of geospatial software in Debian.
That was the birth of what is today the
[DebianGIS pure blend](https://www.debian.org/blends/), with a mildly
coordinated team of developers and maintainers that work together in Debian
(and derivative distributions) on a set of essential libraries and tools for
the geospatial community. For people interested in the history of FOSS, I wrote
a [contribution to the ASITA
conference in 2009 about that](http://atti.asita.it/Asita2009/Pdf/069.pdf). That was and still is grunt work, often
neglected and at the time perceived as a secondary effort by upstream
developers. Indeed, that is an essential task instead, because collecting
together properly and ensuring that you have a complete and well-built stack of
software for a geospatial application is not trivial at all.

One of such base libraries is GDAL, which can be built with multiple optional
dependencies and plugins. Like other platforms, some of those optional
dependencies are missing in the Guix package, and that should be taken into
consideration. Some tools are instead totally missing, such as MapServer and
others. Of course, some packages could be patched here and there in Debian, or
can require a Guix-specific patching (because of the peculiarities of such a
system, which does not respect the Linux FHS), and that definitely could be a
reason to have a package in good shape or not. That's to say that the Guix 
ecosystem would need a
serious help for packaging such niche packages, but where most people can see a
lack, I see an opportunity in that regard. After all, when I started my life in
the Debian project, it was because I did not trust an operating environment
that I could not develop and adjust personally for whatever reason.  That's the
way and Guix seems a brilliant example of a vibrant community for that.

