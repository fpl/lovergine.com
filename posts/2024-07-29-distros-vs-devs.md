title: Are distributions still relevant?
date: 2024-07-29 20:00
tags: development, containers, distributions, rant
summary: Some notes about development trends and centers of responsibility
---

In principle and the traditional vision, the roles were clear enough. Upstream
developers had to create and support their own projects, including multiple
libraries, tools and modules, possibly for multiple operating systems.
Distribution maintainers had the responsibility of collecting a significant software
set, porting on various architectures, choosing versions that work well together
for each piece of software, patching for coherence and well-established
policies, eventually providing a build and installation system for the end
users. At the end of the day, a quite complicated and articulated work that
many people out there do for fun, others as a full-time job. 

Some distributions have been around since the
beginning of the 90s and still release new versions regularly, including Debian GNU/Linux,
an ecosystem where I have lived and collaborated for almost 25 years.
That was an ideal workflow, managed differently and with diverse goals
by multiple non-profit associations and companies, including the Debian project.
Distribution aimed to have the most stable and affordable daily-use system, 
especially for servers and enterprise ecosystems.

That was until 15 years ago or less, when virtual machines and later containers
changed the games and the whole cloud computing revolution started. In
prospective, that has not been the only driver for the change. Another important
aspect has been the great relevance that _dynamic languages_ and their ecosystems
assumed during the same period.

## The new world of hubs

Hubs, hubs everywhere and for anyone. For programming languages, as well as for
containers and virtual machines. Starting from Perl and its CPAN archive, all
currently used languages have their own ecosystems of packages/modules hosted
on some third-party delivery networks. Most modern applications are based on
the distributed efforts of thousands of developers who create and maintain 
thousands of tiny or large modules to solve some very specific goals, which 
inevitably live in their respective language hubs. 

Your latest applications, almost for sure, could only exist thanks to dozens - or
hundreds - of `include/require/use` clauses written in some of the prime-time dynamic languages
that currently ride the wave of popularity. Sub-modules that are often developed by
small independent teams or even single developers, packages that are mostly
_open source_ and come with no warranties for their use and destination.

## Hubs for developers

In recent years, developers learned to distribute their own laptops with their applications: let me 
simplify. Instead of creating minimal, well-engineered traditional packages for some target platforms 
and eventually installers, we are now distributing container images on some cloud computing resources
with all required software piled up within them. If those images are based on Docker, Podman,
Lilipod or Apptainer it is absolutely secondary. Often, most applications are written
in a dynamic language and install gigs of dependency modules and libraries (often
in multiple versions) altogether. Giant software blobs stacked on top of some
very tiny operating system layer. All that started from _continuous integration_
platforms for testing and development and exploded in a plethora of subsystems and tools used for
deployment to the end users.

## Hubs for end-users

Talking about common users, thanks to new container-based systems thought for that - such as
flatpak, snap, or appimage - even ordinary users can now use programs that are not more
strictly dependent on distribution package managers. Those are the equivalent of Windows
installers in the Linux environments for end-users. Installing new programs or sub-systems is now
simplified: no building from sources, backporting and other more technical workflows. Just install
and update the latest product, kindly made available by multiple upstream teams, in terms
of some containerized image with only a minor runtime overhead.

It seems like a new ideal development and user world for Linux ecosystems, at least apparently.
Probably it is so for advanced and self-aware users, but ...

_I felt a great disturbance in the Force, as if millions of voices suddenly cried out in terror and 
were suddenly silenced. I fear something terrible has happened (Obi-Wan Kenobi)._

## The splintering of the Linux ecosystems

The Linux ecosystem has always been extremely fragmented from the point of view of a Windows (or Macos) user.
There are too many distros, too many desktop environments, and too many programs that often do almost the same things, 
but differently in some regards, always in the name of freedom of choice. However, all this is nothing 
in respect with the future. Distributions are going to be always less and less relevant for running 
applications in the cloud and even on the user's desktop. For instance, in the case of Ubuntu and many derivatives distributions, even a big
part of the desktop system is now based on _snap_, and its Ubuntu-specific containerized hub.
Soon, all distributions could become very compact core systems with most of the system applications moved
onto multiple external hubs with different frequencies of update.

## Who is responsible of the whole supply chain?

At the moment, one of the main challenges for the security of applications - that have become more and more
complicated and dependent on _a plethora_ of different third-party software - is certifying the whole
supply chain. A _software bill of materials_ is nowadays required in multiple contexts, but guess what?
A splintering of the whole software stack management responsibility among multiple third-party hubs, development
teams, and end-users is a game changer.
As a user or developer, you will be _directly_ responsible for updating all
your applications and keeping them stable. Not more your distribution, but you. 
Most hubs do not have clear, well-established, and just-in-time policies for security updates.
In most cases, it is a task to be managed by every development team in order to re-collecting all
required pieces - in a consistent way - and rebuilding containerized images when needed. 

Sure, there are _continuous integration_ workflows available in some cases. Still, I don't know so many
application teams that are seriously interested in timely reacting on security reports, starting from
some obscure CVEs, patching, updating multiple source trees and even ensuring to not break anything
by accurate testing platforms. A grunt work done by distribution secteams until now.

Even if basic container images were _bricks_ accurately managed and updated, the final build and
deployment of application images is a different matter, and while the current approach could
be helpful to have the most recent software installed for the end-users desktops, I'm pretty sure
that most of the thousands of embedded devices that now populate our homes are in pathetic
conditions for security. Many of them have opaque and short-term supports, and the use
of multi-hub sources can only render the whole thing worse: we all are potentially living with multiple
little time bombs permanently connected to the net.

This has been so since the very beginnig in the embedded environments, now we are changing the things 
in the same way for desktops and cloud applications.

_Once you start down the dark path, forever will it dominate your destiny (Yoda)_

We live in interesting times...

