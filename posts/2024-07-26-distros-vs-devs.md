title: Are distributions still relevant?
date: 2024-07-25 18:00
tags: development, containers, distributions
summary: Some notes about development trends and centers of responsability
---

## GNU/Linux distributions

In principle and the traditional vision, the roles were clear enough. Upstream
developers had to create and support their own projects, including multiple
libraries, tools and modules, possibly for multiple operating systems.
Distribution maintainers had the responsibility of collecting a significant software
set, porting on various architectures, choosing versions that work well together
for each piece of software, patching for coherence and well-established
policies, eventually providing a build and installation system for the end
users. At the end of the day, a quite complicated and articulated work that
many people out there do it for fun. Some distributions have been around since the
beginning of the 90s and still release new versions regularly, including Debian GNU/Linux 
an ecosystem where I have lived and collaborated for almost 25 years.

That was an ideal workflow, managed differently and with different goals
by multiple non-profit associations and companies, including the Debian project.
Distribution aimed to to have the most stable and affordable system for
daily use, especially for servers and enterprise ecosystems.

That was until 15 years ago when virtual machines and later containers
changed the games and the whole cloud computing revolution started. In
prospective, that has not been the only driver for the changer. Another important
aspect has been the great relevance that _dynamic languages_ and their ecosystems
assumed during the same period.

## The new world of hubs

Hubs, hubs everywhere and for anyone. For programming languages, as well as for
containers and virtual machines. Starting from Perl and its CPAN archive, all
currently used languages have their own ecosystems of packages/modules hosted
on some third-party delivery networks. Most modern applications are based on
the distributed efforts of thousands of developers that create and maintain 
thousands of tiny or large modules to solve some very specific goals, which 
inevitably live in their respective language hubs. 

Your latest applications, almost for sure, could only exist thanks to dozens - or
hundreds - of `includes/requires/use` clause in some of the prime-time dynamic languages
that currently ride the wave of popularity. Sub-modules that are often developed by
small independent teams or even single developers, packages that are mostly
_open source_ and come with no warranties for their use and destination.

## Hubs for developers

In the latest years, developers learnt to distribute their own laptops with their applications, let me 
simplify. Instead of creating minimal well-engineered traditional packages for some target platforms 
and eventually and installer, we are now distributing container images on some cloud computing resources
with all required software piled up within them. If those images are based on Docker, Podman,
Lilipod or Apptainer it is absolutely secondary. Often most applications are written
in a dynamic language and install gigs of dependency modules and libraries (often
in multiple versions) all together. Giant blobs of software stackend on top of some
very tiny operating system layer. All that started from _continuous integration_
platforms for testing and development and exploded in a pletora of subsytems and tools used for
deployment to the end users.

## Hubs for end-users

Talking about common users, thanks to new container-based systems tought for that - such as
flatpak, snap or appimage - even ordinary users now can use programs that are not more
strictly depending on distribution package managers. For end users, those are the equivalent of Windows
installer in the Linux environments. The installation of new programs or sub-systems is now
simplified: no building from sources, backporting and other more technical workflows. Just install
and update the latest product kindly made available by multiple upstream teams.

It seems a new ideal development and user world for the Linux ecosystems, at least apparently.
Probably it is so for advanced and self-aware users, but ...

_I felt a great disturbance in the Force, as if millions of voices suddenly cried out in terror and 
were suddenly silenced. I fear something terrible has happened (Obi-Wan Kenobi)._

## The splintering of the Linux ecosystems



## Who is responsible of the whole supply chain?
